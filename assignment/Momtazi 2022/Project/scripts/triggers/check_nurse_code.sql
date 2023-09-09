CREATE OR REPLACE FUNCTION check_nurse_code()
RETURNS TRIGGER
LANGUAGE plpgsql AS
$$
BEGIN
	IF (NEW.type NOT IN ('nurse', 'metron', 'paramedic', 'supervisor')) THEN
		RAISE 'Nurse type is not correctly issued';
	ELSIF (NEW.code ~ '[[:alpha:]]') THEN
		RAISE 'Nurse code must only contain numbers';
	ELSIF (CHAR_LENGTH(NEW.code) != 8) THEN
		RAISE 'Nurse code must be only 8 characters long';
	ELSE
		RETURN NEW;
	END IF;
COMMIT;
END;
$$;

CREATE TRIGGER _check_nurse_code
BEFORE INSERT
ON nurses
FOR EACH ROW 
EXECUTE PROCEDURE check_nurse_code();