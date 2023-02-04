-- USING UNION FOR COMBINING DATASETS

-- QUARTER 1
CREATE TABLE 2022_Q1(
SELECT *
FROM 202201_divvy_tripdata dt 
)
UNION DISTINCT(
SELECT *
FROM 202202_divvy_tripdata dt2
)
UNION DISTINCT(
SELECT *
FROM 202203_divvy_tripdata dt3
);
-- QUARTER 2
CREATE TABLE 2022_Q2(
SELECT *
FROM 202204_divvy_tripdata dt4 
)
UNION DISTINCT(
SELECT *
FROM 202205_divvy_tripdata dt5
)
UNION DISTINCT(
SELECT *
FROM 202206_divvy_tripdata dt6
);
-- QUARTER 3
CREATE TABLE 2022_Q3(
SELECT *
FROM 202207_divvy_tripdata dt7 
)
UNION DISTINCT(
SELECT *
FROM 202208_divvy_tripdata dt8
)
UNION DISTINCT(
SELECT *
FROM 202209_divvy_publictripdata dp 
);
-- QUARTER 4
CREATE TABLE 2022_Q4(
SELECT *
FROM 202210_divvy_tripdata dt10 
)
UNION DISTINCT(
SELECT *
FROM 202211_divvy_tripdata dt11
)
UNION DISTINCT(
SELECT *
FROM 202212_divvy_tripdata dt12
)

-- DATA CLEANING
UPDATE
  	projectB.2022_Q4
SET
  	ride_length = '0:00:00'
WHERE
  	ride_length = '###############################################################################################################################################################################################################################################################'






