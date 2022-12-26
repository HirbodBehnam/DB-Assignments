CREATE OR REPLACE FUNCTION make_room_available()
  RETURNS trigger AS 
$BODY$
BEGIN
  IF (NEW.Type = 'double' AND OLD.Type = 'single') THEN
    UPDATE Room SET Unavailable = FALSE WHERE Roomnumber = OLD.Roomnumber;
  END IF;
	RETURN NEW;
end
$BODY$
  LANGUAGE 'plpgsql' SECURITY INVOKER
;

CREATE TRIGGER make_room_available_trigger AFTER UPDATE ON Room 
FOR EACH ROW EXECUTE PROCEDURE make_room_available()