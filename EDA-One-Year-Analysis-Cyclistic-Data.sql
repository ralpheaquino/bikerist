-- SINCE WE KNOW THAT THE TABLES HAVE SIMILAR COLUMNS AND SIMILAR DATATYPES WE CAN COMBINE THE 4 QUARTERS

-- INTO 1 SINGLE TABLE
CREATE TABLE 2022_trips(
SELECT *
FROM projectB.2022_Q1 q 
)
UNION DISTINCT(
SELECT *
FROM projectB.2022_Q2 q2 
)
UNION DISTINCT(
SELECT *
FROM projectB.2022_Q3 q3 
)
UNION DISTINCT(
SELECT *
FROM projectB.2022_Q4 q4 
);

-- EXPLORATORY DATA ANALYSIS

-- OVERALL TOTAL, ANNUAL AND MEMBER TRIPS
-- USE CTE TO SIMPLIFY QUERY 

WITH trip_counts AS (
SELECT
	COUNT(*) AS Total_Trips,
    COUNT(CASE WHEN member_casual = 'member' THEN 1 END) AS member_trips,
    COUNT(CASE WHEN member_casual = 'casual' THEN 1 END) AS casual_trips
  FROM 2022_trips t
)
SELECT
Total_Trips,
member_trips,
casual_trips,
(member_trips / Total_Trips) * 100 AS percent_member,
  (casual_trips / Total_Trips) * 100 AS percent_casual
 FROM trip_counts;


-- OVERALL, MEMBER, AND CASUAL AVERAGE RIDE LENGTHS
SELECT 
	sec_to_time(AVG(time_to_sec(RL2))) AS overall_avg_ride_length,
	sec_to_time(AVG(CASE WHEN member_casual = 'member' THEN time_to_sec(RL2) END)) AS member_avg_ride_length,
	sec_to_time(AVG(CASE WHEN member_casual = 'casual' THEN time_to_sec(RL2) END)) AS casual_avg_ride_length
FROM 2022_trips;

-- OR
SELECT 
	sec_to_time(AVG(time_to_sec(RL2))) AS overall_avg_ride_length,
	(SELECT SEC_TO_TIME(AVG(TIME_TO_SEC(RL2)))
	FROM 2022_trips t 
	WHERE member_casual = 'member'
	) AS member_avg_ride_length,
	(SELECT SEC_TO_TIME(AVG(TIME_TO_SEC(RL2)))
	FROM 2022_trips t 
	WHERE member_casual = 'casual'
	) AS casual_avg_ride_length
FROM 2022_trips t2;
	

-- MAX ride length for each category
SELECT 
MAX(RL2) AS max_overall_ride_length,
(SELECT  MAX(RL2)
FROM 2022_trips t 
WHERE member_casual = 'member'
) AS max_member_ride_length,
(SELECT  MAX(RL2)
FROM 2022_trips t 
WHERE member_casual = 'casual'
) AS max_casual_ride_length
FROM 2022_trips t ;

-- BUSIEST DAY OF THE YEAR FOR RIDERS MEMBER AND CASUAL
SELECT
member_casual,
day_of_week,
COUNT(DISTINCT ride_id) AS number_of_rides
FROM 2022_trips
GROUP BY member_casual, day_of_week
ORDER BY number_of_rides DESC;

-- OVERALL RIDES PER DAY
SELECT
day_of_week,
COUNT(DISTINCT ride_id) AS number_of_rides
FROM 2022_trips
GROUP BY day_of_week
ORDER BY day_of_week ASC;

-- MOST FAVORED BIKE TYPE OVERALL
SELECT rideable_type, COUNT(rideable_type) AS number_of_bikes_rented
FROM 2022_trips
GROUP BY rideable_type;

-- MEMBER BIKE TYPE
SELECT rideable_type, COUNT(rideable_type) AS bike_type
FROM 2022_trips t 
WHERE member_casual = 'member'
GROUP BY rideable_type;

-- MOST POPULAR BIKE TYPES FOR CASUAL RIDERS
SELECT rideable_type, COUNT(rideable_type) AS bike_type
FROM 2022_trips t 
WHERE member_casual = 'casual'
GROUP BY rideable_type;

-- 
SELECT rideable_type,
SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS member_bikes,
SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS casual_bikes,
COUNT(rideable_type) AS number_of_bikes_rented
FROM 2022_trips
GROUP BY rideable_type;
