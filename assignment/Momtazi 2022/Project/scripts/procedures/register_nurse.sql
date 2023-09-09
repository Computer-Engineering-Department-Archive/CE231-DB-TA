CREATE OR REPLACE PROCEDURE register_nurse(
	username varchar,	
	type varchar,
	code varchar
)
LANGUAGE plpgsql AS
$$
BEGIN
	IF (type NOT IN ('nurse', 'metron', 'paramedic', 'supervisor')) THEN
		RAISE 'Nurse type is not correctly issued';
	ELSIF (code ~ '[[:alpha:]]') THEN
		RAISE 'Nurse code must only contain numbers';
	ELSIF (CHAR_LENGTH(code) != 8) THEN
		RAISE 'Nurse code must be at least 8 characters long';
	ELSE
		INSERT INTO nurses VALUES (username, type, code);
	END IF;
COMMIT;
END;
$$