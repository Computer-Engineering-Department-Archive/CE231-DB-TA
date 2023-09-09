CREATE OR REPLACE PROCEDURE register(
	username varchar,
	first_name varchar,
	last_name varchar,
	gender boolean,
	birth_date date,
	sickness_history boolean,
	password varchar,
	association_number varchar,
	code varchar,
	type varchar,
	nurse_or_doctor varchar
)
LANGUAGE plpgsql AS
$$ 
BEGIN	
	-- Insert to accounts
	INSERT INTO accounts VALUES (username, first_name, last_name, gender, birth_date, sickness_history, password);
	
	-- Insert to nurses/doctors/none
	IF (nurse_or_doctor = 'nurse') THEN
		CALL register_nurse(username, type, code);
	ELSIF (nurse_or_doctor = 'doctor') THEN
		CALL register_doctor(username, association_number);
	END IF;

	-- Add log
	INSERT INTO logs (type, status, username, time_stamp) VALUES ('registration', 'success', username, NOW());
COMMIT;
END;
$$