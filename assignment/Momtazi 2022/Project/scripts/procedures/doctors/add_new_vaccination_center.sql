CREATE OR REPLACE PROCEDURE add_new_vaccination_center(
	name varchar,
	address varchar,
	_token varchar
)
LANGUAGE plpgsql AS
$$
DECLARE
	_username varchar;
	_association_number varchar;
BEGIN
	-- Find username
	SELECT username from sessions WHERE token = _token INTO _username;
	IF _username IS NULL THEN RAISE 'Invalid token'; END IF;

	-- association_number
	SELECT association_number FROM doctors WHERE username = _username INTO _association_number;
	IF _association_number IS NULL THEN RAISE 'User not qualified for this action'; END IF;
	
	-- Add vaccination_center
	INSERT INTO vaccination_centers VALUES (name, address);
COMMIT;
END;
$$