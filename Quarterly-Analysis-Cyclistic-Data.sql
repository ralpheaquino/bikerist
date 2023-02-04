-- TOTAL RIDES PER QUARTER
SELECT *
FROM 2022_Q4 ;
-- REPEAT FOR 4 QUARTERS
-- Q1 = 503,421
-- Q2 = 1,775,311
-- Q3 = 2,310,759
-- Q4 = 1,078,226

-- %Casual and %Member for each QUARTER
SELECT
    total_rides_Q1,
    member_trips,
    casual_trips,
    (member_trips / total_rides_q1) * 100 as Percent_Member,
    (casual_trips / total_rides_q1) * 100 as Percent_Casual
FROM (
    SELECT
        COUNT(ride_id) AS total_rides_Q1,
        COUNT(CASE WHEN member_casual = 'member' THEN 1 END) AS member_trips,
        COUNT(CASE WHEN member_casual = 'casual' THEN 1 END) AS casual_trips
    FROM 2022_Q1
) AS q1_rides;
-- NOTES FROM QUERY ABOVE ** EVERY SUBQUERY MUST HAVE AN ALIAS (AS Q1_RIDES)



-- COPY ride_length column to another column from the same table so not to tamper with the original data
ALTER TABLE 2022_Q4 
ADD COLUMN RL2 VARCHAR(500) AFTER ride_length;

UPDATE 2022_Q4
SET RL2 = ride_length;

-- CHANGE RL2 FROM TEXT TO TIME DATA TYPE (Q1 TO Q4)
ALTER TABLE projectB.2022_Q4 MODIFY COLUMN RL2 TIME NULL;

-- USING THE RL2 WITH TIME DATA TYPE GET THE AVERAGE OF RIDE_LENGTHS PER QUARTER
SELECT 
(
	SELECT SEC_TO_TIME(AVG(TIME_TO_SEC(RL2)))
	FROM 2022_Q1
)AS AVERAGE_RIDE_LENGTH,
(
	SELECT SEC_TO_TIME(AVG(TIME_TO_SEC(RL2)))
	FROM 2022_Q1
	WHERE member_casual = 'MEMBER'
) AS AVERAGE_RIDE_LENGTH_MEMBER,
(
	SELECT SEC_TO_TIME(AVG(TIME_TO_SEC(RL2)))
	FROM 2022_Q1
	WHERE member_casual = 'CASUAL'
) AS AVERAGE_RIDE_LENGTH_CASUAL

-- MAX RIDE LENGTHS
SELECT member_casual, MAX(ride_length) AS max_ride_length
FROM 2022_Q1
GROUP BY member_casual;

-- BUSIEST DAY FOR EACH RIDE
SELECT COUNT(ride_id) AS Number_of_Rides, day_of_week 
FROM 2022_Q1
GROUP BY day_of_week
ORDER BY day_of_week ASC;


-- MOST FAVORED DAY FOR CASUAL AND MEMBERS TO RIDE A BIKE
SELECT day_of_week, COUNT(ride_id) AS Number_of_Rides, member_casual
FROM 2022_Q1
WHERE member_casual = 'member'
GROUP BY day_of_week
ORDER BY Number_of_Rides DESC
LIMIT 1;

SELECT day_of_week, COUNT(ride_id) AS Number_of_Rides, member_casual
FROM 2022_Q1
WHERE member_casual = 'casual'
GROUP BY day_of_week
ORDER BY Number_of_Rides DESC
LIMIT 1;

-- COMBINED QUERY
SELECT DISTINCT(member_casual), day_of_week
FROM 2022_Q1
GROUP BY member_casual, day_of_week
ORDER BY day_of_week DESC;

SELECT member_casual, day_of_week, COUNT(ride_id) AS number_of_rides
FROM 2022_Q1
GROUP BY day_of_week, member_casual
ORDER BY number_of_rides DESC;

-- FOR MEMBERS DAY 3 IS THE MOST FAVORED DAY BIKERS
-- FOR CASUALS DAY 1 IS THE MOST FAVORED DAY

-- TOTAL RIDES PER DAY FOR ANNUAL AND MEMBER
SELECT 
	day_of_week,
	COUNT(DISTINCT ride_id) AS total_trips,
	SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS member_trips,
	SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS member_trips
FROM 2022_Q1
GROUP BY day_of_week
ORDER BY total_trips DESC;

