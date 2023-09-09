CREATE OR REPLACE FUNCTION check_password()
RETURNS TRIGGER
LANGUAGE plpgsql AS
$$
BEGIN
	IF (CHAR_LENGTH(NEW.password) < 8) THEN
		RAISE 'Password must be at least 8 characters long';
	ELSIF (NOT NEW.password ~ '[[:alpha:]]') THEN
		RAISE 'Password does not contain any characters';
	ELSIF (NOT NEW.password ~ '\d') THEN
		RAISE 'Password does not contain any numbers';
	ELSIF (CHAR_LENGTH(NEW.username) != 10) THEN
		RAISE 'Username must be exactly 10 characters long';
	ELSIF (NEW.username ~ '[[:alpha:]]') THEN
		RAISE 'Username must only contain numbers';
	ELSE
		NEW.password = MD5(NEW.password);
		RETURN NEW;
	END IF;
COMMIT;
END;
$$;

CREATE TRIGGER _check_password
BEFORE INSERT
ON accounts
FOR EACH ROW 
EXECUTE PROCEDURE check_password();