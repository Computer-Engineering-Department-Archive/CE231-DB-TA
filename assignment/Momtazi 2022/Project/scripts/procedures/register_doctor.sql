CREATE OR REPLACE PROCEDURE register_doctor(
	username varchar,
	association_number varchar
)
LANGUAGE plpgsql AS
$$
BEGIN
	IF (association_number ~ '[[:alpha:]]') THEN
		RAISE 'Doctor association_number must only contain numbers';
	ELSIF (CHAR_LENGTH(association_number) != 5) THEN
		RAISE 'Doctor association_number must be exactly 5 characters long';
	ELSE
		INSERT INTO doctors VALUES (username, association_number);
	END IF;
COMMIT;
END;
$$