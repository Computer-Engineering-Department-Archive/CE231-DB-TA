CREATE OR REPLACE PROCEDURE make_injection(
	administrated_to varchar,
    time_stamp date,
    vaccination_center_name varchar,
    vial_serial_number int,
	_token varchar
)
LANGUAGE plpgsql AS
$$
DECLARE
    _administrated_to varchar;
    _vaccination_center_name varchar;
	_serial_number int;
	_username varchar;	
	_dose_counts int;
	_previous_serial_number int;	-- This refers to the previously injected vial (They must match!)
	_code varchar;
BEGIN
	-- Check request username exists (Token is valid)
	SELECT username from sessions WHERE token = _token INTO _username;
    IF _username IS NULL THEN RAISE 'Invalid token'; END IF;

    -- Check if nurse code is valid (qualified)
    SELECT code FROM nurses WHERE username = _username INTO _code;
    IF _code IS NULL THEN RAISE 'User not qualified for this action'; END IF;

    -- Check if vial serial number exists
    SELECT serial_number FROM vials WHERE serial_number = vial_serial_number INTO _serial_number;
    IF _serial_number IS NULL THEN RAISE 'Vial not found'; END IF;
	
	-- Check if administrated_to account exists
	SELECT username FROM accounts WHERE username = administrated_to INTO _administrated_to;
	IF _administrated_to IS NULL THEN RAISE 'Username not found'; END IF;
	
	-- Check if vaccination_center_name exists
	SELECT name FROM vaccination_centers WHERE name = vaccination_center_name INTO _vaccination_center_name;
	IF _vaccination_center_name IS NULL THEN RAISE 'Vaccination_center_name not found'; END IF;
	
	-- Check does counts (Must be available)
	SELECT dose_counts FROM vials WHERE serial_number = _serial_number INTO _dose_counts;	
	IF _dose_counts <= 0 THEN RAISE 'Vial is empty, no more doses available'; END IF;
	
	-- Check vials compatibility
	SELECT administrations.vial_serial_number FROM administrations WHERE administrations.administrated_to = _administrated_to INTO _previous_serial_number;
	IF _previous_serial_number IS NOT NULL AND _previous_serial_number != _serial_number THEN RAISE 'Vaccine is different from the previously injected one. You must administrate the same vaccine'; END IF;
	
	-- Insert into administrations
    INSERT INTO administrations VALUES (_administrated_to, time_stamp, _code, _vaccination_center_name, _serial_number);
	
	-- Update does counts for the vial
	UPDATE vials SET dose_counts = _dose_counts - 1 WHERE serial_number = _serial_number;
COMMIT;
END;
$$