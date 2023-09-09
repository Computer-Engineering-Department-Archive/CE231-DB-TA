-- A
SELECT *, (
	SELECT COUNT(*) FROM friends WHERE students.id = friends.student_id
) AS friends_count
FROM students;

-- B
SELECT friends.student_id, p1_grades.grade AS student_grade, friends.friend_id, p2_grades.grade AS friend_grade
FROM friends
INNER JOIN db_grades AS p1_grades
	ON p1_grades.student_id = friends.student_id
INNER JOIN db_grades AS p2_grades
	ON p2_grades.student_id = friends.friend_id
WHERE
	p1_grades.grade < 10 AND p2_grades.grade >= 10
GROUP BY friends.student_id;										-- To remove the duplicates

-- C
SELECT *
FROM friends
WHERE student_id NOT IN (
	SELECT student_id
	FROM friends
	WHERE
		10 < ALL (
			SELECT grade
			FROM db_grades AS grades
			WHERE friends.friend_id = grades.student_id
		)
);

-- D
SELECT *
FROM friends
INNER JOIN db_grades AS self
	USING(student_id)
WHERE
	EXISTS (
		SELECT *
        FROM db_grades
        WHERE friends.friend_id = db_grades.student_id
			AND self.grade > db_grades.grade
    )
    AND EXISTS (
		SELECT *
        FROM db_grades
        WHERE friends.friend_id = db_grades.student_id
			AND self.grade < db_grades.grade
    );

-- E
SELECT AVG(POWER(grade, 2)) - POWER(AVG(grade), 2) AS variance
FROM db_grades
WHERE grade < 10