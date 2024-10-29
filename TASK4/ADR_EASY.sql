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