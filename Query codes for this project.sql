CREATE DATABASE IF NOT EXISTS mbta_db;
USE mbta_db;

-- 1. Create tables
CREATE TABLE IF NOT EXISTS routes (
    route_id VARCHAR(50) PRIMARY KEY,
    agency_id VARCHAR(50),
    route_short_name VARCHAR(50),
    route_long_name VARCHAR(255),
    route_type INT
);

CREATE TABLE IF NOT EXISTS trips (
    route_id VARCHAR(50),
    service_id VARCHAR(50),
    trip_id VARCHAR(100) PRIMARY KEY,
    trip_headsign VARCHAR(255),
    direction_id INT,
    shape_id VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS stops (
    stop_id VARCHAR(50) PRIMARY KEY,
    stop_code VARCHAR(50),
    stop_name VARCHAR(255),
    stop_lat DECIMAL(10, 8),
    stop_lon DECIMAL(11, 8)
);

CREATE TABLE IF NOT EXISTS stop_times (
    trip_id VARCHAR(100),
    arrival_time VARCHAR(20),
    departure_time VARCHAR(20),
    stop_id VARCHAR(50),
    stop_sequence INT
);

-- 2. Load data
LOAD DATA LOCAL INFILE 'C:/Transit-Network-Mapping/mdb-437-202610030001/routes.txt'
INTO TABLE routes
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Transit-Network-Mapping/mdb-437-202610030001/trips.txt'
INTO TABLE trips
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Transit-Network-Mapping/mdb-437-202610030001/stops.txt'
INTO TABLE stops
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Transit-Network-Mapping/mdb-437-202610030001/stop_times.txt'
INTO TABLE stop_times
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;