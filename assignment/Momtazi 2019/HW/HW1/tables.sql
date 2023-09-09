/*
 * In The Name of God
 * =======================================
 * [] File Name : tables.sql
 *
 * [] Creation Date : 11-10-2019
 *
 * [] Created By : Parham Alvani (parham.alvani@gmail.com)
 * =======================================
*/
/*
 * Copyright (c) 2019 Parham Alvani.
*/
drop database if exists snapp;
create database snapp;
use snapp;

drop table if exists drivers;
create table drivers ( id int primary key auto_increment, first_name text not null, last_name text not null, status int default 0, phone text not null);

drop table if exists passengers;
create table passengers ( id int primary key auto_increment, first_name text not null, last_name text not null, phone text not null);

drop table if exists rides;
create table rides ( id int primary key auto_increment, passenger int references passengers(id), driver int references drivers(id),
        source_lat decimal(10, 8) not null, source_lng decimal(11, 8) not null,
        destination_lat decimal(10, 8) not null, destination_lng decimal(11, 8) not null,
        second_destination_lat decimal(10, 8), second_destination_lng decimal(11, 8),
        total_price int not null, final_price int not null, discount text,
        start_time datetime not null, finish_time datetime not null, score int not null);

drop table if exists discounts;
create table discounts ( code varchar(20), passenger int references passengers(id), availables int not null, primary key (code, passenger))
