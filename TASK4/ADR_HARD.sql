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