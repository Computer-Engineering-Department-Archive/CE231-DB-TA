CREATE OR REPLACE PROCEDURE add_new_vial(
	serial_number varchar,
    dose_counts int,
    created_on date,
    brand_name varchar,
	_token varchar
)
LANGUAGE plpgsql AS
$$
DECLARE
	_username varchar;
	_code varchar;
BEGIN
	-- username
	SELECT username from sessions WHERE token = _token INTO _username;
	IF _username IS NULL THEN RAISE 'Invalid token'; END IF;

	IF (serial_number ~ '[[:alpha:]]') THEN
		RAISE 'serial_number must not contain any characters';
	END IF;

	-- code
	SELECT code FROM nurses WHERE username = _username AND type = 'metron' INTO _code;
	IF _code IS NULL THEN RAISE 'User not qualified for this action'; END IF;
	
	-- Add to vials
	INSERT INTO vials VALUES (serial_number::int, dose_counts, NULL, created_on, NULL, brand_name);
COMMIT;
END;
$$