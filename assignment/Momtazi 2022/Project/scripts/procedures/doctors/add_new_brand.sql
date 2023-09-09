CREATE OR REPLACE PROCEDURE add_new_brand(
	name varchar,
	institude varchar,
	nationality varchar,
	period int,
	institude_type varchar,
	dose_count int,
	_token varchar
)
LANGUAGE plpgsql AS
$$
DECLARE
	_username varchar;
	_association_number varchar;
BEGIN
	-- username
	SELECT username from sessions WHERE token = _token INTO _username;
	IF _username IS NULL THEN RAISE 'Invalid token'; END IF;	

	-- assosicartion_number
	SELECT association_number FROM doctors WHERE username = _username INTO _association_number;
	IF _association_number IS NULL THEN RAISE 'User not qualified for this action'; END IF;
	
	-- Add to brands
	INSERT INTO brands VALUES (name, institude, nationality, institude_type, dose_count, _association_number, period);
COMMIT;
END;
$$