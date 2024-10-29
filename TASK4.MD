Предыдущее занятие |         &nbsp;          | Следующее занятие
:----------------:|:-----------------------:|:----------------:
[Задание 3](TASK3.MD) | [Содержание](README.MD) | [Задание 5](TASK5.MD)


# PostgreSQL Создание хранимой процедуры adr


### `ADR` - простая версия


```sql
CREATE FUNCTION get_avg(date_s date, date_e date)
RETURNS real
LANGUAGE plpgsql
AS
$$
DECLARE
   adr_result real;
BEGIN
   SELECT sum(t.total_price) / sum(t.days) AS avg  
   INTO adr_result
	FROM
   (SELECT 
	b.booking_id,
	b.date_start,
	b.date_end, 
	rc.price, 
	DATE_PART('day', b.date_end::timestamp - b.date_start ::timestamp) AS days,
	DATE_PART('day', b.date_end::timestamp - b.date_start ::timestamp) * price 
	AS total_price FROM bookings b JOIN rooms r ON b.room_id = r.room_id 
	JOIN room_categories rc ON r.room_category_id = rc.room_category_id
	WHERE b.date_start>= date_s AND b.date_end <= date_e AND b.date_end NOTNULL) AS t;
	RETURN avg_result;
END;
$$;
```

Формируется запрос, который выбирает из соединения таблиц `bookings + rooms + category_rooms` только те
записи _дата начала проживания_ **больше или равна** _началу интервала_ и при этом
_дата окончания проживания_ **меньше или равна** _концу интервала временного_ промежутка.

С помощью команды `DATE_PART('day', b.date_end::timestamp - b.date_start ::timestamp)` находится количество дней между двумя датами.




### `ADR` - сложная версия

```sql
CREATE OR REPLACE FUNCTION get_avg_hard_full_version(from_start_date date, to_end_date date)
RETURNS real
LANGUAGE plpgsql
AS $$
DECLARE
   adr_result real;
BEGIN
    SELECT 
		sum(t.price * DATE_PART('day', t.end_date::timestamp - t.start_date ::timestamp)) / 
			NULLIF(sum(DATE_PART('day', t.end_date::timestamp - t.start_date ::timestamp)), 0) AS adr_value   
   INTO adr_result
	FROM
   (SELECT 
	b.booking_id,
	rc.price AS price, 
	CASE WHEN b.date_start > from_start_date THEN b.date_start
	ELSE from_start_date
	END AS start_date,
	CASE WHEN b.date_end < to_end_date THEN b.date_end
	ELSE to_end_date
	END AS end_date
	FROM bookings b JOIN rooms r ON b.room_id = r.room_id 
	JOIN room_categories rc ON r.room_category_id = rc.room_category_id
	WHERE ((b.date_end >= from_start_date AND b.date_end <= to_end_date) 
				OR  (b.date_start>= from_start_date AND b.date_start <= to_end_date)) 
				AND b.date_end NOTNULL) AS t;
	RETURN adr_result;
END;
$$;
```

В этом варианте запрос имеет более сложную логику.
Формируется запрос, который выбирает из соединения таблиц `bookings + rooms + category_rooms` те
записи для которых выполняется следующее условие:

```
((from_start_date <= дата начала проживания <= to_end_date) ИЛИ (from_start_date <= дата окончания проживания <= to_end_date)) 
И (дата окончания проживания НЕ ПУСТОЕ)
```

Вначале в результирующую таблицу передается следующая информация:
* booking_id
* price - стоимость комнаты за сутки
* start_date (выполняется сравнение переданной в функцию даты `from_start_date` с той, которая будет получена у брони `date_start`. 
 Если `date_start > from_start_date`, то в качестве значения для `start_date` берется значение `date_start` у брони, иначе берется значение `from_start_date`)
* end_date (выполняется сравнение переданной даты `to_end_date` с той, которая будет получена у брони `date_end`. 
 Если `to_end_date > date_end`, то в качестве значения для `end_date` берется значение `date_end` у брони, иначе берется значение `to_end_date`)
 
Далее результат анализируется следующим образом:

* `DATE_PART('day', t.end_date::timestamp - t.start_date ::timestamp)` - эта команда позваоляет получить разницу в днях между двумя датами.
*  `t.price * DATE_PART('day', t.end_date::timestamp - t.start_date ::timestamp)` - стоимость за съем номера на n-дней.
* `NULLIF(sum(DATE_PART('day', t.end_date::timestamp - t.start_date ::timestamp)), 0)` - позволяет проверить не равно ли количество дней 0. В этом случае результат будет 0.
* Итоговый результат мы рассчитываем по формуле `сумма_продаж / число_ночей` т.е. 

```
sum(t.price * DATE_PART('day', t.end_date::timestamp - t.start_date ::timestamp)) / 
			NULLIF(sum(DATE_PART('day', t.end_date::timestamp - t.start_date ::timestamp)), 0)
```



### `ADR` - разделение на два отлельных запроса

Можно разбить описанную выше функцию на две небольшие.

> get_bookings(from_start_date date, to_end_date date) - запрос который возвращает список действующих заказов в рамках указанного периода 

```sql
-- DROP FUNCTION get_bookings(date, date);

CREATE OR REPLACE FUNCTION get_bookings(from_start_date date, to_end_date date)
 RETURNS TABLE(booking_id bigint, price real, start_date date, end_date date)
 LANGUAGE plpgsql
AS $function$
BEGIN
	RETURN query
		SELECT 
			b.booking_id,
			rc.price AS price, 
			CASE WHEN b.date_start > from_start_date 
				THEN b.date_start
				ELSE from_start_date
			END AS start_date,
			CASE WHEN b.date_end < to_end_date 
				THEN b.date_end
				ELSE to_end_date
			END AS end_date
			
		FROM bookings b JOIN rooms r ON b.room_id = r.room_id 
				JOIN room_categories rc ON r.room_category_id = rc.room_category_id
		WHERE ((b.date_end >= from_start_date AND b.date_end <= to_end_date) 
				OR  (b.date_start>= from_start_date AND b.date_start <= to_end_date)) 
				AND b.date_end NOTNULL;
	
END;
$function$
;

```
> get_adr_hard_version(date_s date, date_e date) - вызывает функцию выше. 

```sql
-- DROP FUNCTION get_adr_hard_version(date, date);

CREATE OR REPLACE FUNCTION get_adr_hard_version(date_s date, date_e date)
 RETURNS real
 LANGUAGE plpgsql
AS $function$
DECLARE
   adr_result decimal(10,2);
BEGIN
   SELECT sum(t.price * DATE_PART('day', t.end_date::timestamp - t.start_date ::timestamp)) / NULLIF(sum(DATE_PART('day', t.end_date::timestamp - t.start_date ::timestamp)), 0) AS avg  
   INTO adr_result
	FROM get_bookings(date_s, date_e) AS t;
	RETURN adr_result;
END;
$function$
;

```

# Задания 


[Учетные данные 215 Группа](docs/215.md)

1. Создайте функцию get_room_categories_count согласно примеру. Протестируйте его.

2. Изучите дополнительную информацию о входных и выходных параметрах из [статьи](https://neon.tech/postgresql/postgresql-plpgsql/plpgsql-function-parameters).

3. Создайте хранимые функции:
   * функция, которая возвращает количество клиентов родившихся не ранее заданной даты
   * функция, которая возвращает количество клиентов родившихся не позднее заданной даты
   * функция, которая возвращает количество клиентов, дата рождения которых находится в пределах заданных дат.
   * функция, которая возвращает стоимость и название самой дорогой дополнительной услуги.
   * функция, которая возвращает стоимость и название самой дешевой дополнительной услуги.
   * функция, которая возвращает стоимость и название самого дорогой категории номеров.
   * функция, которая возвращает стоимость и название самого дешевой категории номера.
   
4. Отправьте скрипты, созданных функций в репозиторий на gogs-сервер(назовите репозиторий **UP04_TASK3**).

## Критерии оценивания

* На оценку 5(отлично) - Создана функция get_room_categories_count согласно примеру. Созданы все функции, которые нужно сделать по заданию.
* На оценку 4(хорошо) - Создана функция get_room_categories_count согласно примеру. Созданы любые пять функции, которые нужно было сделать по заданию.
* На оценку 3(удовл) - Создана функция get_room_categories_count согласно примеру. Созданы любые три функции, которые нужно было сделать по заданию.



