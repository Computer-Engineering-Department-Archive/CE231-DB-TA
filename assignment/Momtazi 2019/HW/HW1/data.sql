/*
 * In The Name of God
 * =======================================
 * [] File Name : data.sql
 *
 * [] Creation Date : 15-10-2019
 *
 * [] Created By : Parham Alvani (parham.alvani@gmail.com)
 * =======================================
*/
/*
 * Copyright (c) 2019 Parham Alvani.
*/
use snapp;

insert into passengers (first_name, last_name, phone) values ('Elahe', 'Jalalpour', '+98 (912) 22399094');

insert into drivers (first_name, last_name, phone) values ('Parham', 'Alvani', '+98 (939) 0909540');
insert into drivers (first_name, last_name, phone) values ('Mohammad', 'Mahboubi', '+98 (919) 3249981');

insert into rides (passenger, driver, source_lat, source_lng, destination_lat, destination_lng, total_price, final_price, start_time, finish_time, score) values (1, 1, 35.8049436, 51.400326, 35.7358481, 51.3942474, 10000, 10000, '2019-10-15 14:29:36', '2019-10-15 14:45:00', 5);
insert into rides (passenger, driver, source_lat, source_lng, destination_lat, destination_lng, total_price, final_price, start_time, finish_time, score) values (1, 1, 35.8049436, 51.400326, 35.7358481, 51.3942474, 10000, 10000, '2019-10-15 14:29:36', '2019-10-15 14:45:00', 5);
