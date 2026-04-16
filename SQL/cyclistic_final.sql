-- Remove Duplicates ride ids
CREATE TABLE cyclistic_cleaned AS
SELECT *
FROM(
 SELECT *,
 ROW_NUMBER () OVER (PARTITION BY ride_id ORDER BY started_at) AS rn
 FROM cyclistic_2025
) temp
WHERE rn=1

-- Count no. of rides
SELECT COUNT(*)
FROM cyclistic_cleaned

--- remove helper column 

ALTER TABLE cyclistic_cleaned
DROP COLUMN rn

--- TRIM WHITESPACE

CREATE TABLE cyclistic_trimmed AS
SELECT 
TRIM(ride_id) AS ride_id,
TRIM(rideable_type) AS rideable_type,
started_at,
ended_at,
TRIM(start_station_name) AS start_station_name,
TRIM(start_station_id) AS start_station_id,
TRIM(end_station_name) AS end_station_name,
TRIM(end_station_id) AS end_station_id,
start_lat,
start_lng,
end_lat,
end_lng,
TRIM(member_casual) AS membership
FROM cyclistic_cleaned;

--- Assigning NULL and BLANK Values with 'Unkown'

CREATE TABLE cyclistic_null_values AS
SELECT ride_id,
rideable_type,
started_at,
ended_at,
CASE
        WHEN start_station_name IS NULL OR start_station_name = '' THEN 'Unknown'
        ELSE start_station_name
    END AS start_station_name,

    CASE
        WHEN start_station_id IS NULL OR start_station_id = '' THEN 'Unknown'
        ELSE start_station_id
    END AS start_station_id,

    CASE
        WHEN end_station_name IS NULL OR end_station_name = '' THEN 'Unknown'
        ELSE end_station_name
    END AS end_station_name,

    CASE
        WHEN end_station_id IS NULL OR end_station_id = '' THEN 'Unknown'
        ELSE end_station_id
    END AS end_station_id,

    start_lat,
    start_lng,
    end_lat,
    end_lng,
    membership
FROM cyclistic_trimmed;

---- Add Columns

CREATE TABLE cyclistic_add_cols AS
SELECT 
    ride_id,
    rideable_type,
    started_at,
    ended_at,
    start_station_name,
    start_station_id,
    end_station_name,
    end_station_id,
    start_lat,
    start_lng,
    end_lat,
    end_lng,
    membership,
	ROUND(EXTRACT(EPOCH FROM (ended_at-started_at))/60,2) AS ride_time,
	TO_CHAR(started_at,'FMDay')AS start_day,
	TO_CHAR(started_at, 'FMMM, YYYY') AS ride_month
FROM cyclistic_null_values;

--- Remove outliers

CREATE TABLE cyclistic_no_outliers AS
SELECT *
FROM cyclistic_add_cols
WHERE ride_time BETWEEN 2 AND 300

--- Create final clean table

CREATE TABLE cyclistic_final AS
SELECT
    ride_id,
    rideable_type,
    started_at,
    ended_at,
    start_station_name,
    end_station_name,
    membership,
    ride_time,
    start_day,
    ride_month
FROM cyclistic_no_outliers;


---
SELECT *
FROM cyclistic_final
LIMIT 10