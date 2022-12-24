CREATE OR REPLACE FUNCTION check_room_capacity()
  RETURNS trigger AS 
$BODY$
DECLARE
	is_bad BOOLEAN;
BEGIN
	SELECT Unavailable INTO is_bad FROM Room WHERE Number = NEW.Room;
	IF (is_bad) THEN
		RAISE EXCEPTION 'Unauthorized action: Room is not available!';
    ELSE
        UPDATE Room SET Unavailable = TRUE WHERE Number = NEW.Room AND Roomtype = 'single';
	END IF;
	RETURN NEW;
end
$BODY$
  LANGUAGE 'plpgsql' SECURITY INVOKER
;

CREATE TRIGGER room_capacity_checker BEFORE INSERT ON Stay 
FOR EACH ROW EXECUTE PROCEDURE check_room_capacity()