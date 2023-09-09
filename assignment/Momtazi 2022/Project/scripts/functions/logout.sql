CREATE OR REPLACE FUNCTION logout(_token varchar)
RETURNS varchar
LANGUAGE 'plpgsql'
AS $$
DECLARE
	_username varchar;
BEGIN
	-- Find username
	SELECT username from sessions WHERE token = _token INTO _username;

	-- Create log
	INSERT INTO logs (type, status, username, time_stamp) VALUES ('logout', 'success', _username, NOW());
	
	-- Delete all active session for the user
	DELETE FROM sessions WHERE username = _username;
	
	return NULL;	-- JIC
END;
$$;