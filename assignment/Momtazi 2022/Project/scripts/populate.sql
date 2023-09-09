-- doctors
CALL register('0000000000', 'doctor1', 'doctor1', true, '2001-04-01', false, '0000000A', '00000', NULL, NULL, 'doctor');
CALL register('1111111111', 'doctor2', 'doctor2', false, '2011-11-06', true, '0000000B', '11111', NULL, NULL, 'doctor');
CALL register('2222222222', 'doctor3', 'doctor3', true, '2011-01-18', true, '0000000C', '22222', NULL, NULL, 'doctor');
-- nurses
CALL register ('3333333333', 'nurse1', 'nurse1', true, '2011-05-11', true, '0000000D', NULL, '33333333', 'metron', 'nurse');
CALL register ('4444444444', 'nurse2', 'nurse2', false, '2011-12-23', true, '0000000E', NULL, '44444444', 'supervisor', 'nurse');
CALL register ('5555555555', 'nurse3', 'nurse3', true, '2018-10-30', false, '0000000F', NULL, '55555555', 'nurse', 'nurse');
CALL register ('6666666666', 'nurse4', 'nurse4', false, '2001-02-14', false, '0000000G', NULL, '66666666', 'paramedic', 'nurse');
-- users
CALL register ('7777777777', 'user1', 'user1', false, '1998-06-16', true, '0000000H', NULL, NULL, NULL, NULL);
CALL register ('8888888888', 'user2', 'user2', true, '1998-02-13', false, '0000000I', NULL, NULL, NULL, NULL);
CALL register ('9999999999', 'user3', 'user3', true, '1998-02-13', false, '0000000J', NULL, NULL, NULL, NULL);
-- brands
INSERT INTO brands VALUES ('vaccine1', 'vaccine1', 'american', 'semi', 3, '00000', 31);
INSERT INTO brands VALUES ('vaccine2', 'vaccine2', 'english', 'goverment', 1, '11111', 60);
INSERT INTO brands VALUES ('vaccine3', 'vaccine3', 'american', 'semi', 7, '11111', 90);
INSERT INTO brands VALUES ('vaccine4', 'vaccine4', 'english', 'private', 2, '22222', 14);
-- vaccination centers
INSERT INTO vaccination_centers VALUES ('0x01', 'USA');
INSERT INTO vaccination_centers VALUES ('0x02', 'England');
INSERT INTO vaccination_centers VALUES ('0x03', 'Itely');
INSERT INTO vaccination_centers VALUES ('0x04', 'Japan');
INSERT INTO vaccination_centers VALUES ('0x05', 'China');
-- vials
INSERT INTO vials VALUES (11111, 3, NULL, '2021/11/02', '0x01', 'vaccine1');
INSERT INTO vials VALUES (11112, 3, NULL, '2019/10/18', '0x03', 'vaccine2');
INSERT INTO vials VALUES (11113, 9, NULL, '2021/11/02', '0x02', 'vaccine3');
INSERT INTO vials VALUES (11114, 1, NULL, '2029/10/31', '0x01', 'vaccine4');
INSERT INTO vials VALUES (11115, 4, NULL, '2029/05/19', '0x02', 'vaccine1');
INSERT INTO vials VALUES (11116, 2, NULL, '2029/08/16', '0x04', 'vaccine2');
INSERT INTO vials VALUES (11117, 5, NULL, '2029/09/12', '0x05', 'vaccine3');
INSERT INTO vials VALUES (11118, 4, NULL, '2029/12/11', '0x02', 'vaccine3');
INSERT INTO vials VALUES (11119, 4, NULL, '2029/04/01', '0x02', 'vaccine1');
-- injections
INSERT INTO administrations VALUES ('0000000000', '2021/04/12', '33333333', '0x01', 11111);
INSERT INTO administrations VALUES ('1111111111', '2021/05/13', '33333333', '0x02', 11112);
INSERT INTO administrations VALUES ('1111111111', '2021/06/17', '44444444', '0x03', 11112);
INSERT INTO administrations VALUES ('1111111111', '2021/07/21', '44444444', '0x04', 11112);
INSERT INTO administrations VALUES ('2222222222', '2021/08/25', '44444444', '0x05', 11115);
INSERT INTO administrations VALUES ('3333333333', '2021/04/08', '55555555', '0x01', 11115);
INSERT INTO administrations VALUES ('3333333333', '2021/05/11', '55555555', '0x02', 11115);
INSERT INTO administrations VALUES ('4444444444', '2021/12/12', '66666666', '0x03', 11113);
INSERT INTO administrations VALUES ('4444444444', '2021/11/13', '55555555', '0x04', 11113);
INSERT INTO administrations VALUES ('4444444444', '2021/10/19', '33333333', '0x03', 11113);
INSERT INTO administrations VALUES ('3333333333', '2021/05/12', '55555555', '0x02', 11115);