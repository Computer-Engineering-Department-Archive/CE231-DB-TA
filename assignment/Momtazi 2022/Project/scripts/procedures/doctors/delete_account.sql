CREATE OR REPLACE PROCEDURE delete_account(
	username_to_delete varchar,
	_token varchar
)
LANGUAGE plpgsql AS
$$
DECLARE
	_username varchar;
	_username_to_delete varchar;
	_association_number varchar;
BEGIN
	-- Validate username request
	SELECT username from sessions WHERE token = _token INTO _username;
    IF _username IS NULL THEN RAISE 'Invalid token'; END IF;

    -- Validate association_number access
	SELECT association_number FROM doctors WHERE username = _username INTO _association_number;
    IF _association_number IS NULL THEN RAISE 'User not qualified for this action'; END IF;

    -- Validate username that we shoud delete
	SELECT username from accounts WHERE username = username_to_delete INTO username_to_delete;	
    IF username_to_delete IS NULL THEN RAISE 'Username not found'; END IF;
	
    -- Delete account from the entire platform (Cascade)
	DELETE FROM accounts WHERE username = username_to_delete;
COMMIT;
END;
$$