/* CREATE TABLES */
create table users
(
	name varchar(255) primary key,
	gender varchar(10),
	age int,
	phone varchar(20) unique,
	referred_by varchar(255) null,
	user_point int default 0,
	FOREIGN KEY (referred_by) REFERENCES users (name),
	CHECK (gender = 'male' OR gender = 'female')
);

create table categories
(
	id int primary key auto_increment,
	name varchar(255) unique,
	parent_id int null,
	FOREIGN KEY (parent_id) REFERENCES categories (id)
);

create table posts
(
	id int primary key auto_increment,
	title varchar(255) not null ,
	created_at date,
	status varchar(5),
	content varchar(1024),
	user_name varchar(255) not null,
	category_id int not null,
	FOREIGN KEY (user_name) REFERENCES users (name) on delete cascade,
	FOREIGN KEY (category_id) REFERENCES categories (id) on delete cascade,
	CHECK (status = 'draft' or status = 'post')
);

create table comments
(
	id int primary key auto_increment,
	user_name varchar(255) not null,
	post_id int not null,
	comment text null,
	constraint prevent_comment check ( comment not like '%harf bad%' ),
	FOREIGN KEY (user_name) REFERENCES users (name) on delete cascade,
	FOREIGN KEY (post_id) REFERENCES posts (id) on delete cascade,
);

create table followers
(
	user_name varchar(255),
	following_name varchar(255),
	FOREIGN KEY (user_name) REFERENCES users (name) on delete cascade,
	FOREIGN KEY (following_name) REFERENCES users (name) on delete cascade,
	PRIMARY KEY (user_name, following_name)
);

create table likes
(
	user_name varchar(255),
	post_id int,
	FOREIGN KEY (user_name) REFERENCES users (name),
	FOREIGN KEY (post_id) REFERENCES posts (id),
	PRIMARY KEY (user_name, post_id)
);

/* INSERT DATA */
/* users */
insert into users values ('farbod', 'male', 32, '0912121212', null, 10);
insert into users values ('amirali','male', 20, '0919314132', null, 0);
insert into users values ('aylin', 'female', 38, '0913141212', 'amirali', 15);
insert into users values ('nastaran', 'female', 16, '0912894322', 'farbod', 4);
insert into users values ('amir', 'male', 19, '09124424322', 'farbod', 2);

/* categories*/
insert into categories (name, parent_id)
	values ('general', null);
insert into categories (name, parent_id)
	VALUES ('fun', null);
insert into categories (name, parent_id)
	VALUES ('society', null);
insert into categories (name, parent_id)
	VALUES ('politics', 3);
insert into categories (name, parent_id)
	VALUES ('comedy', 2);

/* posts */
insert into posts (title, status, content, user_name, category_id)
	VALUES ('golang', 'post', 'go is a powerfull programming language', 'farbod', 1);
insert into posts (title, status, content, user_name, category_id)
	VALUES ('hello', 'post', 'hi everyone!', 'aylin', 1);
insert into posts (title, status, content, user_name, category_id)
	VALUES ('joke', 'post', 'a funny joke', 'amirali', 2);
insert into posts (title, status, content, user_name, category_id)
	VALUES ('goverment', 'draft', 'some political content', 'farbod', 3);
insert into posts (title, status, content, user_name, category_id)
	VALUES ('school', 'draft', 'goodbye final exams!', 'nastaran', 2);

/* followers */
insert into followers values ('farbod', 'amirali');
insert into followers values ('farbod', 'nastaran');
insert into followers values ('nastaran', 'aylin');
insert into followers values ('aylin', 'nastaran');
insert into followers values ('nastaran', 'farbod');
insert into followers values ('aylin', 'amirali');

/* likes */
insert into likes (post_id, user_name)
	values (1, 'farbod');
insert into likes (post_id, user_name)
	values (2, 'farbod');
insert into likes (post_id, user_name)
	values (2, 'nastaran');
insert into likes (post_id, user_name)
	values (1, 'aylin');
insert into likes (post_id, user_name)
	values (1, 'amirali');

/* comments */
insert into comments (user_name, post_id, comment)
	values ('amirali',1 ,'yes it is');
insert into comments (user_name, post_id, comment)
	values ('farbod',2 ,'hi :)');
insert into comments (user_name, post_id, comment)
	values ('amirali',5 ,'bye bye');
insert into comments (user_name, post_id, comment)
	values ('nastaran',1 ,'i believe so');
insert into comments (user_name, post_id, comment)
	values ('aylin',1 ,'sure');

/* REPORT QUERIES */
/* A */
select *
from users
where phone like '%523%' and phone not like '%06';

/* B */
select id, max(total)
from (  select p.id as id, count(c.id) as total
		from ( comments as c join posts as p on c.post_id = p.id )
			join categories as ct on p.category_id = ct.id
		where ct.name = 'society'
		group by id
	) as it;
	
/* C */
delete from posts 
where id IN (  select posts.id from posts join users on users.name = posts.user_name where users.age < 20 AND posts.status = 'draft' );

/* D */
select max(posts_count), name
from ( select count(posts.id) as posts_count, users.name as name
		from (posts join categories on posts.category_id = categories.id) join users on users.name = posts.user_name
        where categories.name = 'society' or categories.parent_id = (select id from categories where categories.name = 'society')
		group by name
	) as res;

/* E */
delete from comments
where user_name IN (select name from users where name NOT IN (select following_name from followers)) and user_name IN (select name from users where name NOT IN (select user_name from posts));

/* F */
select users.name, count(followers.following_name) as total_followers
from users left join followers on users.name = followers.following_name 
group by users.name 
order by total_followers desc
limit 10;

/* G */
select users.phone
from users
where users.referred_by = 'Amir' and users.gender = 'male' and users.age > 20
  and users.name not in
      (select u.name
      from (users as u join posts p on u.name = p.user_name) join categories on categories.id = p.category_id
      where categories.name = 'Fun'
);

/* H */
select distinct title 
from posts
where (select count(*) from posts as P join likes on P.id = likes.post_id where P.id = posts.id) > 5
	AND (select count(followers.user_name) from followers where following_name = posts.user_name) > 20;

/* I */
update users
set user_point = user_point + 10
where name in ( select posts.user_name
                from posts join categories on posts.category_id = categories.id
                where (select count(*) from posts as P join likes on P.id = likes.post_id where P.id = posts.id) > 100
	                AND (select count(*) from posts as PO join comments on PO.id = comments.post_id where PO.id = posts.id) > 20);

/* J */
update posts
set status = 'draft'
where posts.user_name IN (select name from users where age < 18) OR posts.user_name IN (select following_name from followers group by following_name having count(user_name) < 20);

/* K */
update users
set user_point = user_point * 2
where user_point % 10 = 0;
