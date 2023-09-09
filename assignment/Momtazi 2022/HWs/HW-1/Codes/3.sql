-- ***************************************************** Create Tables *****************************************************
-- user
CREATE TABLE user (
	name				varchar(50),
    cellphone			varchar(11) UNIQUE NOT NULL,
    referred_by			varchar(50) NULL,
    
	PRIMARY KEY (name),
    FOREIGN KEY (referred_by) REFERENCES user(name)
);
INSERT INTO user VALUES ('Keivan Ipchi', '09197270223', NULL);
INSERT INTO user VALUES ('farbod', '11111111111', 'Keivan Ipchi');
INSERT INTO user VALUES ('Jane Doe #1', '22222222222', 'farbod');
INSERT INTO user VALUES ('John Doe #2', '33333333333', NULL);
INSERT INTO user VALUES ('Jane Doe #2', '44444444444', 'Keivan Ipchi');

-- foods
CREATE TABLE foods (
	id					int AUTO_INCREMENT,
    name				varchar(50),
    author				varchar(50),
    recipe				text,
    time				int,	-- Could use 'time', but 'int' will do just fine
    
    PRIMARY KEY (id),
    FOREIGN KEY (author) REFERENCES user(name)
);
INSERT INTO foods (name, author, recipe, time) VALUES ('Pizza', 'Keivan Ipchi', 'Pizza recipe', 60);		-- 1
INSERT INTO foods (name, author, recipe, time) VALUES ('Salad', 'farbod', 'Salad recipe', 15);			-- 2
INSERT INTO foods (name, author, recipe, time) VALUES ('Lasagna', 'Jane Doe #1', 'Lasagna recipe', 90);		-- 3
INSERT INTO foods (name, author, recipe, time) VALUES ('Burger', 'John Doe #2', 'Burger recipe', 45);		-- 4
INSERT INTO foods (name, author, recipe, time) VALUES ('Hotdog', 'Jane Doe #1', 'Hotdog recipe', 35);		-- 5
INSERT INTO foods (name, author, recipe, time) VALUES ('Polo Morgh', 'Keivan Ipchi', 'Polo Morgh recipe', 35);		-- 6

-- ingredients
CREATE TABLE ingredients (
	id					int AUTO_INCREMENT,
    name				varchar(30),
    price				int CHECK(MOD(price, 500) = 0), -- Must be dividable by 500
    
    PRIMARY KEY (id)
);
INSERT INTO ingredients (name, price) VALUES ('salt', 25000);		-- 1
INSERT INTO ingredients (name, price) VALUES ('suger', 2000);		-- 2
INSERT INTO ingredients (name, price) VALUES ('pasta', 9000);		-- 3
INSERT INTO ingredients (name, price) VALUES ('meat', 30000);		-- 4
INSERT INTO ingredients (name, price) VALUES ('sausage', 12000);	-- 5

-- food_ingredients
CREATE TABLE food_ingredients (
	food_id				int,
    ingredient_id		int,
    amount				double,		-- Can support floats
    
    FOREIGN KEY (food_id) REFERENCES foods(id),
    FOREIGN KEY (ingredient_id) REFERENCES ingredients(id)
);
INSERT INTO food_ingredients VALUES (1, 1, 30);
INSERT INTO food_ingredients VALUES (1, 4, 10);
INSERT INTO food_ingredients VALUES (2, 1, 70);
INSERT INTO food_ingredients VALUES (2, 3, 57);
INSERT INTO food_ingredients VALUES (3, 3, 35);
INSERT INTO food_ingredients VALUES (3, 4, 60);
INSERT INTO food_ingredients VALUES (4, 4, 32);
INSERT INTO food_ingredients VALUES (4, 3, 75);
INSERT INTO food_ingredients VALUES (4, 1, 80);
INSERT INTO food_ingredients VALUES (5, 5, 55);

-- user_ingredients
CREATE TABLE user_ingredients (
	user_name			varchar(50),
    ingredient_id		int,
    amount				double,		-- Can support floats
    
    FOREIGN KEY (user_name)	 REFERENCES user(name),
    FOREIGN KEY (ingredient_id)	 REFERENCES ingredients(id)
);
INSERT INTO user_ingredients VALUES ('Keivan Ipchi', 1, 100);
INSERT INTO user_ingredients VALUES ('Keivan Ipchi', 2, 55);
INSERT INTO user_ingredients VALUES ('Keivan Ipchi', 3, 0);
INSERT INTO user_ingredients VALUES ('farbod', 1, 30);
INSERT INTO user_ingredients VALUES ('farbod', 5, 200);
INSERT INTO user_ingredients VALUES ('Jane Doe #1', 4, 35);
INSERT INTO user_ingredients VALUES ('Jane Doe #1', 3, 500);
INSERT INTO user_ingredients VALUES ('John Doe #2', 4, 35);
INSERT INTO user_ingredients VALUES ('John Doe #2', 2 , 150);
INSERT INTO user_ingredients VALUES ('Jane Doe #2', 1, 25);
INSERT INTO user_ingredients VALUES ('Jane Doe #2', 3, 300);
INSERT INTO user_ingredients VALUES ('Jane Doe #2', 5, 40);
INSERT INTO user_ingredients VALUES ('John Doe #2', 1, 10);
INSERT INTO user_ingredients VALUES ('John Doe #2', 2, 20);
INSERT INTO user_ingredients VALUES ('John Doe #2', 3, 30);
INSERT INTO user_ingredients VALUES ('John Doe #2', 4, 40);

-- comments
CREATE TABLE comments (
	id					int,
    user_name			varchar(50),
    food_id				int,
    rate				int CHECK (rate BETWEEN 1 AND 5),
    comment				text CHECK (comment NOT LIKE '%bimaze%'),
    
    PRIMARY KEY (user_name, food_id), -- Each user can comment on each food only once (Can also be done with "CONSTRAINT cond UNIQUE (user_name, food_id)")
    FOREIGN KEY (user_name) REFERENCES user(name),
    FOREIGN KEY (food_id) REFERENCES foods(id)
);
INSERT INTO comments (id, user_name, food_id, rate, comment) VALUES (0, 'Keivan Ipchi', 1, 4, 'Perfecto');
INSERT INTO comments (id, user_name, food_id, rate, comment) VALUES (1, 'Keivan Ipchi', 2, 3, 'Good');
INSERT INTO comments (id, user_name, food_id, rate, comment) VALUES (1, 'Keivan Ipchi', 3, 3, 'Very Good');
INSERT INTO comments (id, user_name, food_id, rate, comment) VALUES (2, 'farbod', 3, 5, 'I licked my fingers');
INSERT INTO comments (id, user_name, food_id, rate, comment) VALUES (3, 'farbod', 5, 1, 'OMG! Horrible food');
INSERT INTO comments (id, user_name, food_id, rate, comment) VALUES (4, 'Jane Doe #1', 1, 1, 'Bad, just bad.');
INSERT INTO comments (id, user_name, food_id, rate, comment) VALUES (5, 'Jane Doe #1', 2, 2, 'Not that bad.');
INSERT INTO comments (id, user_name, food_id, rate, comment) VALUES (6, 'Jane Doe #1', 3, 4, 'Neat.');
INSERT INTO comments (id, user_name, food_id, rate, comment) VALUES (7, 'John Doe #2', 4, 4, 'That is called a proper food');
INSERT INTO comments (id, user_name, food_id, rate, comment) VALUES (8, 'John Doe #2', 3, 1, 'Disgusting');
INSERT INTO comments (id, user_name, food_id, rate, comment) VALUES (9, 'Jane Doe #2', 2, 3, 'Could be better');
INSERT INTO comments (id, user_name, food_id, rate, comment) VALUES (10, 'Jane Doe #2', 1, 2, 'Nah, not my taste');

-- For deleting tables in sequence
-- DROP TABLE comments, user_ingredients, food_ingredients, ingredients, foods, user;

-- ***************************************************** Queries *****************************************************

-- A
SELECT name
FROM foods
WHERE name LIKE '%Polo%';

-- B
SELECT user_name, AVG(rate) AS 'User AVG rating'
FROM comments
GROUP BY (user_name);

-- C
SELECT author, AVG(rate)
FROM foods
	INNER JOIN comments
		ON comments.food_id = foods.id
GROUP BY (author);

-- D
DELETE FROM comments
WHERE comments.id IN (
	SELECT c.id
	FROM (
		SELECT tmp.id
		FROM foods
		INNER JOIN comments AS tmp
			ON foods.author = tmp.user_name AND foods.id = tmp.food_id
	) AS c
);

-- E
SELECT referred_by, COUNT(*)
FROM user
WHERE referred_by IS NOT NULL	-- Removed the NULL ones
GROUP BY referred_by;

-- F
DELETE FROM foods
WHERE foods.id IN (
    SELECT f.id
    FROM (
		SELECT foods.id
		FROM foods
		WHERE foods.id NOT IN (
			SELECT food_id
			FROM food_ingredients
			WHERE food_id = foods.id
		)
	) AS f
);

-- G
SELECT foods.*, SUM(amount * price) AS total_price
FROM food_ingredients
INNER JOIN foods
	ON food_ingredients.food_id = foods.id
INNER JOIN ingredients
	ON food_ingredients.ingredient_id = ingredients.id
GROUP BY food_id;

-- H
SELECT *, SUM(price) AS value
FROM user_ingredients
INNER JOIN user
	ON user_ingredients.user_name = user.name
INNER JOIN ingredients
	ON user_ingredients.ingredient_id = ingredients.id
GROUP BY user_name
ORDER BY value DESC
LIMIT 1;

-- I
