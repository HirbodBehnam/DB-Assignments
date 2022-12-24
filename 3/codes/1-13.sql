CREATE OR REPLACE FUNCTION change_room_availiblity()
  RETURNS trigger AS 
$BODY$
DECLARE
	is_bad BOOLEAN;
BEGIN
    -- TODO
	RETURN NEW;
end
$BODY$
  LANGUAGE 'plpgsql' SECURITY INVOKER
;

CREATE TRIGGER room_type_changer BEFORE INSERT ON Room 
FOR EACH ROW EXECUTE PROCEDURE change_room_availiblity()