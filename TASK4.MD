Предыдущее занятие |         &nbsp;          | Следующее занятие
:----------------:|:-----------------------:|:----------------:
[Задание 3](TASK3.MD) | [Содержание](README.MD) | [Задание 5](TASK5.MD)


# PostgreSQL Создание хранимой процедуры adr 

`ADR` - простая версия
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

`ADR` - сложная версия
```sql
CREATE FUNCTION get_avg_hard_version(date_s date, date_e date)
RETURNS real
LANGUAGE plpgsql
AS
$$
DECLARE
   adr_result real;
BEGIN
   SELECT sum(t.price * DATE_PART('day', t.end_date::timestamp - t.start_date ::timestamp)) / sum(DATE_PART('day', t.end_date::timestamp - t.start_date ::timestamp)) AS avg  
   INTO adr_result
	FROM
   (SELECT 
	b.booking_id,
	rc.price AS price, 
	CASE WHEN b.date_start > date_s THEN b.date_start
	ELSE date_s
	END AS start_date,
	CASE WHEN b.date_end < date_end THEN b.date_end
	ELSE date_e
	END AS end_date
	FROM bookings b JOIN rooms r ON b.room_id = r.room_id 
	JOIN room_categories rc ON r.room_category_id = rc.room_category_id
	WHERE (b.date_start>= date_s OR b.date_end <= date_e) AND b.date_end NOTNULL) AS t;
	RETURN adr_result;
END;
$$;
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



