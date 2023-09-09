-- doctors
CALL register('0123456789', 'Keivan', 'Ipchi Hagh', true, '2001-04-01', false, '1234ABCD', '01234', NULL, NULL, 'doctor');
-- nurses
CALL register ('1234567890', 'John', 'Doe', true, '2011-05-11', true, '4321DCBA', NULL, '12345678', 'paramedic', 'nurse');
CALL register ('2345678901', 'Jane', 'Doe', false, '2021-12-23', false, '1111AAAA', NULL, '23456789', 'supervisor', 'nurse');
-- users
CALL register ('3456789012', 'Kristen', 'Stewart', false, '1998-06-16', true, '2222BBBB', NULL, NULL, NULL, NULL);
CALL register ('4567890123', 'Taylor', 'Swift', false, '1998-02-13', false, '3333CCCC', NULL, NULL, NULL, NULL);

-- delete from sessions