-- https://wiki.livid.pp.ru/students/dbms/lectures/7.html
CREATE OR REPLACE FUNCTION check_free_rooms()
   RETURNS TRIGGER
   LANGUAGE PLPGSQL
AS $$
	DECLARE	 rooms_count integer;
BEGIN
   SELECT count(*) 
   INTO rooms_count
   FROM rooms r JOIN room_status rs ON r.room_status_id = rs.room_status_id 
   WHERE rs.title = 'Чистый'; 
   IF rooms_count = 0 THEN
   		RAISE SQLSTATE '45000' USING MESSAGE = 'ALL ROOMS RESERVED';
   	
   END IF;
   RETURN NULL;

END;
$$


CREATE OR REPLACE TRIGGER check_rooms
BEFORE INSERT ON bookings 
EXECUTE FUNCTION check_free_rooms();


INSERT INTO bookings(client_id, date_start, date_end, room_id) VALUES (1, '2024-11-01', '2024-11-05',6); 


CREATE OR REPLACE FUNCTION reserve_room()
   RETURNS TRIGGER
   LANGUAGE PLPGSQL
AS $$
	
BEGIN
   UPDATE rooms r SET room_status_id = (
   SELECT room_status_id FROM room_status rs WHERE rs.title = 'Занят')
   WHERE r.room_id = NEW.room_id;
   RETURN NEW;
END;
$$

CREATE OR REPLACE TRIGGER set_reserve_rooms
AFTER INSERT ON bookings
FOR EACH ROW 
EXECUTE FUNCTION reserve_room();


CREATE OR REPLACE FUNCTION is_current_room_free()
   RETURNS TRIGGER
   LANGUAGE PLPGSQL
AS $$
	DECLARE	 rooms_count integer;
BEGIN
   SELECT count(*) 
   INTO rooms_count
   FROM rooms r JOIN room_status rs ON r.room_status_id = rs.room_status_id 
   WHERE rs.title = 'Чистый' AND r.room_id = NEW.room_id;
   IF rooms_count = 0 THEN
   		RAISE SQLSTATE '45000' USING MESSAGE = 'ROOM WITH ID ' || NEW.room_id || ' RESERVED';	
   END IF;
   RETURN NEW;
END;
$$

CREATE OR REPLACE TRIGGER check_current_rooms
BEFORE INSERT ON bookings
FOR EACH ROW 
EXECUTE FUNCTION is_current_room_free();






