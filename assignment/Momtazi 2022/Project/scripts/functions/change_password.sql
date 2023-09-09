CREATE OR REPLACE FUNCTION change_password(old_password varchar, new_password varchar, _token varchar)
RETURNS varchar
LANGUAGE 'plpgsql'
AS $$
DECLARE
	_username varchar;
	_password varchar;
BEGIN

	-- Check if username exists
	SELECT username from sessions WHERE token = _token INTO _username;
	IF _username IS NULL THEN RAISE 'Invalid token'; END IF;
	
	-- Validate old password
	SELECT password FROM accounts WHERE username = _username INTO _password;
	IF (MD5(old_password) != _password) THEN RAISE 'Password do not match'; END IF;
	
	-- Validate new password
	IF (CHAR_LENGTH(new_password) < 8) THEN
		RAISE 'Password must be at least 8 characters long';
	ELSIF (NOT new_password ~ '[[:alpha:]]') THEN
		RAISE 'Password does not contain any characters';
	ELSIF (NOT new_password ~ '\d') THEN
		RAISE 'Password does not contain any numbers';
	END IF;
	
	-- Update password
	UPDATE accounts SET password = MD5(new_password) WHERE username = _username;
	RETURN 'Password updated';
END;
$$;