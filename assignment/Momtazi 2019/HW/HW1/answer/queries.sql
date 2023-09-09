>> 1:
	SELECT * 
	FROM drivers 
	WHERE first_name = 'parham'

>> 2:
	first solution: 
		SELECT *
		FROM drivers 
		WHERE (SELECT COUNT(*) 
			   FROM rides
			   WHERE rides.driver = drivers.id) > 20

    second solution:
		SELECT *
		FROM drivers, rides
		WHERE rides.driver = drivers.id
		GROUP BY rides.driver
		HAVING COUNT(*) > 20
	
		   
>> 3:
	SELECT *
	FROM drivers 
	WHERE (SELECT COUNT(*) 
		   FROM rides
		   WHERE (rides.driver = drivers.id)) AND (rides.passenger = 1) > 1
		   
>> 4:
	first solution:		
		SELECT *
		FROM passengers 
		WHERE (SELECT COUNT(*) 
			   FROM rides
			   WHERE (rides.driver = 2) AND (rides.passenger = passengers.id)) > 1
		   
	second solution:
		SELECT passengers.id, passengers.first_name, passengers.last_name, passengers.phone
		FROM passengers, rides
		WHERE rides.passenger = passengers.id
		GROUP BY rides.passenger, rides.driver
		HAVING COUNT(*) > 1 AND rides.driver = 2

>> 5:
	DELETE FROM discounts                      
	WHERE discounts.availables = 0

>> 6:
	SELECT AVG(score) 
	FROM rides                      
	WHERE rides.driver = 1
	
>> 7:
	SELECT A.driver
	FROM (SELECT driver, AVG(score) AS ave
		  FROM rides
		  GROUP BY driver) AS A
	WHERE A.ave >= ALL (SELECT A.ave
						FROM (SELECT AVG(score) AS ave
							  FROM rides
							  GROUP by driver) 
						AS A)

>> 8: 
	SELECT *
	FROM rides
	WHERE rides.discount = "zo-403"
	
>> 9:
	SELECT *
	FROM rides
	WHERE rides.source_lat = 123 AND rides.source_lng = 145
	
>> 10:
	SELECT *
	FROM rides
	WHERE rides.start_time = "2017-10-21 22:00:00"
	
>> 11:
	SELECT *
	FROM rides
	WHERE rides.fini_time = "2017-10-21 22:00:00"
	
>> 12:
	UPDATE discounts                
	SET discounts.availables = discounts.availables - 1
	WHERE discounts.passenger = 1 AND discounts.code = "ce-222"
	
>> 13:
	SELECT * 
	FROM rides 
	WHERE (rides.start_time BETWEEN "2019-10-23 00:00:00" AND "2019-10-23 23:59:59")
		AND rides.final_price > ALL (SELECT AVG(A.final_price)                                               
									FROM (SELECT final_price 
										  FROM rides 
										  WHERE (rides.start_time BETWEEN "2019-10-23 00:00:00" AND "2019-10-23 23:59:59")) 
									AS A)

>> 14:
	SELECT *
	FROM drivers 
	WHERE drivers.id IN (SELECT R.driver 
						 FROM (SELECT driver, AVG(score) AS ave
							   FROM rides
							   WHERE (rides.start_time BETWEEN "2019-10-23 00:00:00" AND "2019-10-23 23:59:59")
							   GROUP BY driver
							   HAVING ave > 4) 
						 AS R)




##################### Emtiazi #####################

>> 2:
	SELECT TIMEDIFF(rides.finish_time, rides.start_time) 
	FROM rides
	WHERE rides.start_time BETWEEN "2019-10-23 00:00:00" AND "2019-10-23 23:59:59"
	
	
>> 3:
	SELECT DISTINCT(driver)
	FROM rides AS A
	WHERE driver in (SELECT driver
					 From rides AS B
					 WHERE A.driver = B.driver AND A.passenger = B.passenger AND A.id != B.id)
  
>> 4:
	SELECT DISTINCT(passenger)
	FROM rides AS A
	WHERE passenger in (SELECT passenger
						From rides AS B
						WHERE A.driver = B.driver AND A.passenger = B.passenger AND A.id != B.id)

