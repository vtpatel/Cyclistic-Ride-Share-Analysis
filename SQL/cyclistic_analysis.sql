--- Cyclistic Bike Analysis

--Review Dataset

SELECT *
FROM cyclistic_final
LIMIT 10

-- Total num of rides

SELECT 
 COUNT(*) AS total_number_rides
 FROM cyclistic_final

--- Total number of rides by membership

SELECT
membership,
COUNT(*) AS total_number_rides
FROM cyclistic_final
GROUP BY membership
ORDER BY total_number_rides

--- Total number of rides by months

SELECT ride_month,
COUNT(*) AS total_number_rides
FROM cyclistic_final
GROUP BY ride_month
ORDER BY total_number_rides DESC

--- Seasonal Trends for casual members

SELECT 
CASE 
WHEN ride_month IN ('3, 2025', '4, 2025', '5, 2025') THEN 'SPRING'
WHEN ride_month IN ('6, 2025', '7, 2025', '8, 2025') THEN 'SUMMER'
WHEN ride_month IN ('9, 2025', '10, 2025', '11, 2025') THEN 'AUTUMN'
WHEN ride_month IN ('12, 2025', '1, 2025', '2, 2025') THEN 'WINTER'
ELSE 'UNKNOWN'
END AS Season,
COUNT(*) AS total_number_rides
FROM cyclistic_final
WHERE membership='casual'
GROUP BY Season
ORDER BY total_number_rides DESC

---- Seasonal Trends for members

SELECT 
CASE 
WHEN ride_month IN ('3, 2025', '4, 2025', '5, 2025') THEN 'SPRING'
WHEN ride_month IN ('6, 2025', '7, 2025', '8, 2025') THEN 'SUMMER'
WHEN ride_month IN ('9, 2025', '10, 2025', '11, 2025') THEN 'AUTUMN'
WHEN ride_month IN ('12, 2025', '1, 2025', '2, 2025') THEN 'WINTER'
ELSE 'UNKNOWN'
END AS Season,
COUNT(*) AS total_number_rides
FROM cyclistic_final
WHERE membership='member'
GROUP BY Season
ORDER BY total_number_rides DESC

--- Monthly Trends of members

SELECT ride_month,
membership,
COUNT(*) AS total_number_rides
FROM cyclistic_final
GROUP BY ride_month,membership
ORDER BY total_number_rides

-----
SELECT EXTRACT(YEAR FROM started_at) AS year_ride,
COUNT(*)
FROM cyclistic_final
GROUP BY year_ride
ORDER BY year_ride

--- After running monthly trend queries i found that i also have 51 rows for year 2024 
--though my focus is on analysis of year 2025 so i am filtering out

DELETE FROM cyclistic_final
WHERE EXTRACT(YEAR FROM started_at) = 2024;

--- Number of rides by day of week and membership

SELECT
membership,
  start_day,
  COUNT(*) AS total_number_rides
FROM
  cyclistic_final
GROUP BY 
  start_day,membership

--- Number of rides by hour of day and membership

SELECT 
membership,
start_day,
EXTRACT(HOUR FROM started_at) AS hour_day,
COUNT(*) AS total_number_rides
FROM cyclistic_final
GROUP BY membership,start_day,hour_day
ORDER BY total_number_rides DESC

--- Top 10 peak hours and day for casual members

SELECT 
membership,
start_day,
EXTRACT(HOUR FROM started_at) AS hour_day,
COUNT(*) AS total_number_rides
FROM cyclistic_final
WHERE membership='casual'
GROUP BY membership,start_day,hour_day
ORDER BY total_number_rides DESC
LIMIT 10

---- TOP 10 peak hours and day for members

SELECT 
membership,
start_day,
EXTRACT(HOUR FROM started_at) AS hour_day,
COUNT(*) AS total_number_rides
FROM cyclistic_final
WHERE membership= 'member'
GROUP BY membership,start_day,hour_day
ORDER BY total_number_rides DESC
LIMIT 10

---- BIKE TYPE PREFERENCE

--- Types of bikes available

SELECT rideable_type,
COUNT(*) AS Frequency
FROM cyclistic_final
GROUP BY rideable_type

--- Top bike used by membership type

SELECT rideable_type,
membership,
COUNT(*) AS Frequency
FROM cyclistic_final
GROUP BY rideable_type,membership
ORDER BY Frequency DESC

--- Ride Duration by members

SELECT 
  membership,
  MIN(ride_time) AS Min_ride_duration,
  MAX(ride_time) AS Max_ride_duration,
  ROUND(AVG(ride_time), 2) AS Avg_ride_duration
FROM
  cyclistic_final
GROUP BY
  membership

---Avg ride duration by weekdays and members

SELECT membership,
start_day,
ROUND(AVG(ride_time), 2) AS Avg_ride_duration
FROM cyclistic_final
GROUP BY membership,start_day
ORDER BY Avg_ride_duration DESC

--- Avg ride duration by Hour of day for casual members

SELECT
  EXTRACT(HOUR FROM started_at) AS Hour_of_day,
  ROUND(AVG(ride_time), 2) AS Avg_ride_duration
FROM
  cyclistic_final
WHERE
  membership = 'casual'
GROUP BY 
  Hour_of_day
ORDER BY 
  Avg_ride_duration DESC

--- Avg ride duration by hour of day for members

SELECT
  EXTRACT(HOUR FROM started_at) AS Hour_of_day,
  ROUND(AVG(ride_time), 2) AS Avg_ride_duration
FROM
  cyclistic_final
WHERE
  membership = 'member'
GROUP BY 
  Hour_of_day
ORDER BY 
  Avg_ride_duration DESC

--- TOP START AND END STATION NAME AND LOCATION

--- Top 10 start station name for casual members

SELECT start_station_name,
COUNT(*) AS frequency 
FROM cyclistic_final
WHERE membership='casual'
AND start_station_name != 'Unknown'
GROUP BY start_station_name
ORDER BY frequency DESC
LIMIT 10 

--- Top 10 start station name for member

SELECT start_station_name,
COUNT(*) AS frequency 
FROM cyclistic_final
WHERE membership='member'
AND start_station_name != 'Unknown'
GROUP BY start_station_name
ORDER BY frequency DESC
LIMIT 10 

--- Top 10 route for casual members

SELECT
  start_station_name,
  end_station_name,
  COUNT(*) AS frequency
FROM
  cyclistic_final
WHERE
  membership = 'casual'
  AND start_station_name != 'Unknown'
  AND end_station_name != 'Unknown'
GROUP BY 
  start_station_name,
  end_station_name
ORDER BY 
  frequency DESC
LIMIT 10;

--- Top 10 route for membership members

SELECT
  start_station_name,
  end_station_name,
  COUNT(*) AS frequency
FROM
  cyclistic_final
WHERE
  membership = 'member'
  AND start_station_name != 'Unknown'
  AND end_station_name != 'Unknown'
GROUP BY 
  start_station_name,
  end_station_name
ORDER BY 
  frequency DESC
LIMIT 10;

--- Top 10 route per day of week for casual members 

SELECT
  start_day,
  start_station_name,
  end_station_name,
  COUNT(*) AS frequency
FROM
 cyclistic_final
WHERE
  membership = 'casual'
  AND start_station_name != 'Unknown'
  AND end_station_name != 'Unknown'
GROUP BY
  start_day,
  start_station_name,
  end_station_name
ORDER BY 
  frequency DESC
LIMIT 10;

--- Top 10 route per day of week for members 

SELECT
  start_day,
  start_station_name,
  end_station_name,
  COUNT(*) AS frequency
FROM
cyclistic_final
WHERE
  membership = 'member'
  AND start_station_name != 'Unknown'
  AND end_station_name != 'Unknown'
GROUP BY
  start_day,
  start_station_name,
  end_station_name
ORDER BY 
  frequency DESC
LIMIT 10;