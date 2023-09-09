--CREATE TABLES
create table user
(
    name        varchar(255) primary key,
    cellphone   varchar(20) unique,
    referred_by varchar(255) null,
    FOREIGN KEY (referred_by) REFERENCES user (name)
);

create table foods
(
    id     int primary key auto_increment,
    name   varchar(255),
    author varchar(255),
    recipe text null,
    time int not null,
    FOREIGN KEY (author) REFERENCES user (name)
);

create table ingredients
(
    id    int primary key auto_increment,
    name  varchar(255),
    price int not null,
    constraint valid_price check ( price % 500 = 0 )
);
create table food_ingredients
(
    food_id       int,
    ingredient_id int,
    amount        int not null,
    foreign key (food_id) references foods (id),
    foreign key (ingredient_id) references ingredients (id)
);
create table user_ingredients
(
    user_name     varchar(255),
    ingredient_id int,
    amount        int not null,
    foreign key (user_name) references user (name),
    foreign key (ingredient_id) references ingredients (id)
);
create table comments
(
    id        int primary key auto_increment,
    user_name varchar(255),
    food_id   int,
    rate      int,
    comment   text null,
    constraint limit_rate check ( rate >= 1 and rate <= 5 ),
    constraint prevent_comment check ( comment not like '%bimaze%' ),
    FOREIGN KEY (user_name) REFERENCES user (name),
    FOREIGN KEY (food_id) REFERENCES foods (id),
    UNIQUE (user_name,food_id)

);
--INSERT DATA

--users
insert into user values ('farbod','0912121212',null);
insert into user values ('amirali','0919314132',null);
insert into user values ('aylin','0913141212','amirali');
insert into user values ('nastaran','0912894322','farbod');

--foods
insert into foods (name, author, recipe, time)
VALUES ('qorme sabzi', 'nastaran', 'this is qorme sabazi recipe', 300);

insert into foods (name, author, recipe, time)
VALUES ('pizza', 'farbod', 'this is pizza recipe', 45);

insert into foods (name, author, recipe, time)
VALUES ('nimroo', 'aylin', 'this is nimroo recipe', 5);

insert into foods (name, author, recipe, time)
VALUES ('adas polo', 'farbod', 'this is adas polo recipe', 180);

--ingredients
insert into ingredients (name, price)
VALUES ('sabzi', 500);

insert into ingredients (name, price)
VALUES ('adas', 2000);

insert into ingredients (name, price)
VALUES ('polo', 1000);

insert into ingredients (name, price)
VALUES ('panir', 3000);

insert into ingredients (name, price)
VALUES ('sabzi', 500);

insert into ingredients (name, price)
VALUES ('egg', 1500);

--food_ingredients
insert into food_ingredients values (1, 1, 2);
insert into food_ingredients values (4, 6, 1);
insert into food_ingredients values (2, 3, 10);
insert into food_ingredients values (3, 4, 6);

--user_ingredients
insert into user_ingredients values ('farbod', 6, 20);
insert into user_ingredients values ('farbod', 4, 200);
insert into user_ingredients values ('aylin', 1, 100);
insert into user_ingredients values ('aylin', 2, 2);

--comments
insert into comments (user_name, food_id, rate, comment)
values ('farbod',1,5,'awli bood');

insert into comments (user_name, food_id, rate, comment)
values ('aylin',1,1,'eftezah bood');

insert into comments (user_name, food_id, rate, comment)
values ('farbod',2,3,'average');

insert into comments (user_name, food_id, rate, comment)
values ('amirali',1,5,'aaali booddd');

--REPORT QUERIES

--A
select name from foods where name like '%polo%';

--B
select avg(rate),user_name from comments group by user_name;

--C
select author,avg(c.rate) from foods join user on user.name = foods.author right join  comments c on foods.id = c.food_id group by author;

--D 
--1 (works on postgres)
delete from comments where id in(select c.id from comments c join foods f on c.food_id = f.id where c.user_name =  f.author); 
--2 works everywhere
create temporary table cidstodelete as select c.id from comments c join foods f on c.food_id = f.id where c.user_name =  f.author;
delete from comments where id in (select id from idstodelete);

--E
select * from (select referred_by, count(referred_by) c from user where referred_by is not null group by referred_by order by c desc) c limit 1;

--F
delete from foods where id not in (select food_id from food_ingredients);

--G
--Function coalesce is used to convert null value into 0 in a select statement which has extra point in this question.(not neccessary)
select name, coalesce(sum(cost), 0) as total_price
from (
         select fo.name, amount * price as cost
         from foods as fo
                  left join food_ingredients fi on fo.id = fi.food_id
                  left join ingredients i on fi.ingredient_id = i.id) f
group by name;


--H
select user_name, sum(p) as sum
from (
         select user_name, amount * price as p
         from user_ingredients
                  left join ingredients i on user_ingredients.ingredient_id = i.id) a
group by user_name order by sum desc limit 1;

--I
select distinct (food_id)
from (
         select *
         from food_ingredients as fi
                  join (select user_name, ingredient_id as ii, amount as am
                        from user_ingredients
                        where user_name = 'farbod') ui
                       on fi.ingredient_id = ui.ii) c
where amount <= am
  and food_id not in (
    select food_id
    from food_ingredients
    where ingredient_id not in (select user_ingredients.ingredient_id from user_ingredients where user_name = 'farbod')
);

  --J
  select food_id, count(rate) cn, avg(rate) av, name
from (
         select food_id, name, rate
         from comments
                  join foods f on comments.food_id = f.id
        ) x
group by food_id
having cn >= 5 order by av desc limit 10;

--K
--1 (postgres)
update ingredients set price = price * 3 where id in (select id from ingredients order by price asc limit 3);
--2 (everywhere)
create temporary table lowest as select * from ingredients order by price asc limit 3;
update ingredients set price = price * 3 where id in (select id from lowest);

--L
select avg(time)
from foods
where id in (
    select distinct (food_id)
    from ingredients
             join food_ingredients fi on ingredients.id = fi.ingredient_id
    where price > 1000);








