Предыдущее занятие |         &nbsp;          | Следующее занятие
:----------------:|:-----------------------:|:----------------:
[Задание 4](TASK4.MD) | [Содержание](README.MD) | [Задание 6](TASK6.MD)


# Решение заданий из Модуля №3

1. [Запрос 1](#запрос-1)
    * [Формулировка](#формулировка)
    * [Решение - группировка результата по клиенту](#решение---группировка-результата-по-клиенту)
    * [Решение - группировка результата по брони](#решение---группировка-результата-по-брони)
2. [Запрос 2](#запрос-2)
    * [Формулировка](#формулировка-1)
    * [Решение](#решение)
3. [Задания](#задания)

## Запрос 1

### Формулировка

> Выведите список клиентов с указанием суммы к оплате, с учетом
проживания и всех используемых дополнительных услуг.

### Решение - группировка результата по клиенту


```sql
-- Группировка по клиенту
-- т.е подсчитывается общая сумма, которую потратил клиент с учетом того,
-- что клиент мог оформить много разных броней
-- учитываются дополнительные услуги
SELECT
	t.client_name,
	sum(t.total)
FROM
	(
	SELECT
		b.booking_id,
		c.client_id,
		c.first_name || ' ' || c.last_name AS client_name,
		rc.price * DATE_PART('day',
		b.date_end::timestamp - b.date_start::timestamp) +
	COALESCE(SUM(bas.count * as2.price),
		0) AS total
		-- COALESCE(value, return_if_value_null) - в случае если результат 
		-- будут NULL, вместо NULL подставится число 0
	FROM
		bookings b
	JOIN clients c ON
		b.client_id = c.client_id
	JOIN rooms r ON
		b.room_id = r.room_id
	JOIN room_categories rc ON
		r.room_category_id = rc.room_category_id
		-- left join используется, так как возможно клиент не заказывал ничего из
		-- списка дополнительных услуг
	LEFT JOIN booking_additional_services bas ON
		b.booking_id = bas.booking_id
	LEFT JOIN additional_services as2 
	ON
		bas.additional_service_id = as2.additional_service_id
	GROUP BY
		b.booking_id,
		c.client_id,
		rc.price) AS t
GROUP BY
	t.client_name;
```

### Решение - группировка результата по брони

```sql
-- Группировка по брони. Т.е ведется расчет суммы которую потратил клиент в рамках одной брони
-- учитываются дополнительные услуги
SELECT
	b.booking_id,
	c.client_id,
	c.first_name || ' ' || c.last_name AS client_name,
	rc.price * DATE_PART('day',
	b.date_end::timestamp - b.date_start::timestamp) +
	COALESCE(SUM(bas.count * as2.price),
	0) AS total
FROM
	bookings b
JOIN clients c ON
	b.client_id = c.client_id
JOIN rooms r ON
	b.room_id = r.room_id
JOIN room_categories rc ON
	r.room_category_id = rc.room_category_id
	-- left join используется, так как возможно клиент не заказывал ничего из
	-- списка дополнительных услуг
LEFT JOIN booking_additional_services bas ON
	b.booking_id = bas.booking_id
LEFT JOIN additional_services as2 
	ON
	bas.additional_service_id = as2.additional_service_id
GROUP BY
	b.booking_id,
	c.client_id,
	rc.price;
```

## Запрос 2

### Формулировка

> Обновите у всех номеров со статусом `Назначен к уборке` на статус
`Чистый`.

### Решение

```sql
UPDATE
	rooms
SET
	room_status_id = (
	SELECT
		room_status_id
	FROM
		room_status
	WHERE
		title = 'Чистый')
WHERE
	room_status_id = (
	SELECT
		room_status_id
	FROM
		room_status
	WHERE
		title = 'Назначен к уборке');
```

# Задания

[Учетные данные 215 Группа](docs/215.md)

[Учетные данные 217 Группа](docs/217.md)

[Справочник по SQL](https://unetway.com/tutorials/sql)

**Задание 1**

Выведите список клиентов с указанием количества дней, который прожил клиент в рамках текущего заказа.   

**Задание 2**

Выведите список уборщиц.

**Задание 3**

Выведите список сотрудников и руководителей с указанием их username и password.

**Задание 4**

Выведите количество номеров на каждом этаже гостиницы.

**Задание 5**

Выведите среднюю стоимость номеров на каждом этаже гостиницы.

Отправьте скрипты созданных запросов (репозиторий **UP04_TASK5**).

## Критерии оценивания

* На оценку 5(отлично) - Выполнены все задания.
* На оценку 4(хорошо) - Созданы три любых запроса.
* На оценку 3(удовл) - Создан один любой запроса.



