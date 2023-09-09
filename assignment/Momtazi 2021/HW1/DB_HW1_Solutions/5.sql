/* A */
SELECT request_date, round(1 - 1.0*sum(CASE WHEN status = 'completed' THEN 1 ELSE 0 END)/count(*), 2) AS cancel_rate
FROM trips
WHERE passenger_id NOT IN (SELECT user_id 
                       FROM users
                       WHERE banned = 'yes' )
AND driver_id NOT IN (SELECT user_id 
                      FROM users
                      WHERE banned = 'yes' )
GROUP BY request_date
HAVING extract(DAY FROM request_date) <= 2 AND extract(MONTH FROM request_date) = 10;

/* B */
select sum(score) as total_score, hacker_id, name
from hackers h join (select hacker_id, challenge_id, max(score) from submission group by hacker_id, challenge_id) s on h.hacker_id = s.hacker_id
group by hacker_id, challenge_id
having total_score != 0
order by total_score desc, hacker_id asc;

/* C */
with t1 AS 
	(
		SELECT *, 
			row_number() OVER (PARTITION by state ORDER BY latitude ASC) AS row_number_state, 
			count(*) OVER (PARTITION by state) AS row_count
		FROM stations 
	)
	SELECT state, avg(latitude) AS median_latitude
	FROM t1
	WHERE row_number_state >= 1.0*row_count/2 AND row_number_state <= 1.0*row_count/2 + 1
	GROUP BY state;

/* D */
with t1 AS (
		SELECT cast(extract(MONTH FROM u2.join_date) AS int) AS month,
			   u1.join_date - u2.join_date AS cycle_time
		FROM users u1 JOIN users u2 ON u1.invited_by = u2.user_id
		ORDER BY user_id 
	)
	SELECT month, avg(cycle_time) AS cycle_time_month_avg
	FROM t1
	GROUP BY user_id
	ORDER BY user_id;

/* E */
SELECT s1.month, sum(s2.salary) AS salary_3mos
FROM salaries s1 JOIN salaries s2 ON s1.month <= s2.month  AND s1.month > s2.month - 3
GROUP BY month
HAVING s1.month < 7
ORDER BY month ASC;

/* F */
with UNT as 
		(
			select user_id, count(*) as number_of_transactions
			from users
			group by user_id
			having number_of_transactions > 1
		)
		select distinct user_id,
		CASE
		    WHEN user_id in (select user_id from UNT) THEN (select min(trasnaction_date) from users U where user_id = U.user_id AND U.trasnaction_date > (select min(trasnaction_date) from users U where user_id = U.user_id) )
		    ELSE null
        END AS superuser_date
		from users
		order by superuser_date;

/* G */
SELECT T.user_id, (100 * 1.0 * T.publishes / T.starts) AS publish_rate, (100 * 1.0 * T.cancels / T.starts) AS cancel_rate
FROM (  SELECT user_id, 
		sum(CASE WHEN action = 'start' THEN 1 ELSE 0 END) AS starts,
		sum(CASE WHEN action = 'cancel' THEN 1 ELSE 0 END) AS cancels,
		sum(CASE WHEN action = 'publish' THEN 1 ELSE 0 END) AS publishes
		FROM users
		GROUP BY user_id
) as T;
