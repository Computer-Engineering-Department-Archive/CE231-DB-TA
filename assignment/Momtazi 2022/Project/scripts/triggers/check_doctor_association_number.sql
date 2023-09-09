CREATE OR REPLACE FUNCTION check_doctor_association_number()
RETURNS TRIGGER
LANGUAGE plpgsql AS
$$
BEGIN
	IF (NEW.association_number ~ '[[:alpha:]]') THEN
		RAISE 'Doctor association_number must only contain numbers';
	ELSIF (CHAR_LENGTH(NEW.association_number) != 5) THEN
		RAISE 'Doctor association_number must be only 5 characters long';
	ELSE
		RETURN NEW;
	END IF;
COMMIT;
END;
$$;

CREATE TRIGGER _check_doctor_association_number
BEFORE INSERT
ON doctors
FOR EACH ROW 
EXECUTE PROCEDURE check_doctor_association_number();