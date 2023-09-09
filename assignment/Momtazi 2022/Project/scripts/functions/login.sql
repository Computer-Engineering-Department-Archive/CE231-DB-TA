CREATE OR REPLACE FUNCTION login(_username varchar, _password varchar)
RETURNS varchar
LANGUAGE 'plpgsql'
AS $$
DECLARE
	_token varchar;
BEGIN
	IF (SELECT username FROM accounts WHERE accounts.username = _username AND accounts.password = MD5(_password)) IS NOT NULL THEN
		-- Calculate session token
		_token = MD5(NOW()::varchar);

		-- Add log
		INSERT INTO logs (type, status, username, time_stamp) VALUES ('login', 'granted', _username, NOW());

		-- Remove previous sessions
		DELETE FROM sessions WHERE username = _username;

		-- Create session
		INSERT INTO sessions VALUES (_username, NOW(), NOW() + INTERVAL '1 DAY', _token);

		-- Return token
		RETURN _token;
	ELSE
		RAISE 'Invalid username or password';
	END IF;
END;
$$;