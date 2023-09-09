CREATE OR REPLACE FUNCTION check_username()
RETURNS TRIGGER
LANGUAGE plpgsql AS
$$
DECLARE
	_username varchar;
BEGIN
	-- Find username
	SELECT username from accounts WHERE username = NEW.username INTO _username;
	IF _username IS NOT NULL THEN RAISE 'User already exists'; END IF;

	IF (CHAR_LENGTH(NEW.username) != 10) THEN
		RAISE 'Username must be exactly 10 characters long';
	ELSIF (NEW.username ~ '[[:alpha:]]') THEN
		RAISE 'Username must only contain numbers';
	ELSE
		RETURN NEW;
	END IF;
COMMIT;
END;
$$;

CREATE TRIGGER _check_username
BEFORE INSERT
ON accounts
FOR EACH ROW 
EXECUTE PROCEDURE check_username();