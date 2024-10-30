-- Выведите список клиентов с указанием суммы к оплате, с учетом проживания и всех используемых дополнительных услуг
-- Группировка по клиенту
-- т.е подсчитывается общая сумма, которую потратил клиент с учетом того,
-- что клиент мог оформить много разных броней
-- учитываются дополнительные услуги
select t.client_name, sum(t.total)
from
	(select b.booking_id, c.client_id, c.first_name||' '|| c.last_name as client_name,
	rc.price * DATE_PART('day', b.date_end::timestamp - b.date_start::timestamp) +
	COALESCE(SUM(bas.count * as2.price), 0) as total
	-- COALESCE(value, return_if_value_null) - в случае если результат 
	-- будут NULL, вместо NULL подставится число 0
	from bookings b 
	join clients c on b.client_id = c.client_id 
	join rooms r on b.room_id = r.room_id
	join room_categories rc on r.room_category_id = rc.room_category_id
	-- left join используется, так как возможно клиент не заказывал ничего из
	-- списка дополнительных услуг
	left join booking_additional_services bas on b.booking_id = bas.booking_id
	left join additional_services as2 
	on bas.additional_service_id = as2.additional_service_id 
	group by b.booking_id, c.client_id, rc.price) as t
group by t.client_name;

--- Выведите список клиентов с указанием суммы к оплате, с учетом проживания и всех используемых дополнительных услуг.
--- Группировка по брони. Т.е ведется рассчет суммы которую потратил клиент в рамках одной брони
--- учитываются дополнительные услуги
select b.booking_id, c.client_id, c.first_name||' '|| c.last_name as client_name,
	rc.price * DATE_PART('day', b.date_end::timestamp - b.date_start::timestamp) +
	COALESCE(SUM(bas.count * as2.price), 0) as total
	from bookings b 
	join clients c on b.client_id = c.client_id 
	join rooms r on b.room_id = r.room_id
	join room_categories rc on r.room_category_id = rc.room_category_id
	-- left join используется, так как возможно клиент не заказывал ничего из
	-- списка дополнительных услуг
	left join booking_additional_services bas on b.booking_id = bas.booking_id
	left join additional_services as2 
	on bas.additional_service_id = as2.additional_service_id 
	group by b.booking_id, c.client_id, rc.price;
	

-- UPDATE

update rooms set room_status_id = (select room_status_id from room_status where title = 'Чистый')
where room_status_id = (select room_status_id from room_status where title = 'Назначен к уборке');


