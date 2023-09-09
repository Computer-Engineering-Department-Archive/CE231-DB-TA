CREATE OR REPLACE FUNCTION rate_administration(_vaccination_center_name varchar, _score int, _token varchar)
RETURNS varchar
LANGUAGE 'plpgsql'
AS $$
DECLARE
	_username varchar;
BEGIN

	-- Check username is valid
	SELECT username FROM sessions WHERE token = _token INTO _username;
	IF _username IS NULL THEN RAISE 'Invalid token'; END IF;
	
	-- Check if user has done injections before
	SELECT administrated_to FROM administrations WHERE administrated_to = _username AND vaccination_center_name = _vaccination_center_name INTO _username;
	IF _username IS NULL THEN RAISE 'You have not administrated any injections here before.'; END IF;
	
	-- Check if user has already rated the center before
	SELECT administrated_to FROM administrations WHERE administrated_to = _username AND score IS NULL AND vaccination_center_name = _vaccination_center_name INTO _username;
	IF _username IS NULL THEN RAISE 'You have already rated this center.'; END IF;
	
	-- Update score
	UPDATE administrations SET score = _score WHERE administrated_to = _username AND score IS NULL AND vaccination_center_name = _vaccination_center_name;	
	RETURN 'Thanks for your feedback (:';
END;
$$;