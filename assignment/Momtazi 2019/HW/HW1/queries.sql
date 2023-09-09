/*
 * In The Name of God
 * =======================================
 * [] File Name : queries.sql
 *
 * [] Creation Date : 07-11-2019
 *
 * [] Created By : Parham Alvani (parham.alvani@gmail.com)
 * =======================================
*/
/*
 * Copyright (c) 2019 Parham Alvani.
*/
-- drivers that has more than 1 ride
select distinct(r1.driver) from rides as r1 where 1 < (select count(r2.driver) from rides as r2 where r2.driver = r1.driver);
