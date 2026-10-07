-- 1. Busiest Stops in the Network
-- Identifies the highest-volume transit hubs across the entire system by counting total scheduled arrival events.
SELECT s.stop_name, COUNT(st.trip_id) AS total_trips 
FROM stop_times st JOIN stops s ON st.stop_id = s.stop_id 
GROUP BY s.stop_id, s.stop_name ORDER BY total_trips DESC LIMIT 10;

-- 2. Routes with the Longest Average Trip Duration
-- Calculates end-to-end travel times to pinpoint which routes take the longest to complete a full run.
SELECT r.route_short_name, r.route_long_name, 
       AVG(TIMEDIFF(st_end.arrival_time, st_start.departure_time)) AS avg_duration 
FROM trips t 
JOIN routes r ON t.route_id = r.route_id 
JOIN stop_times st_start ON t.trip_id = st_start.trip_id AND st_start.stop_sequence = 1 
JOIN stop_times st_end ON t.trip_id = st_end.trip_id 
  AND st_end.stop_sequence = (SELECT MAX(stop_sequence) FROM stop_times WHERE trip_id = t.trip_id) 
GROUP BY r.route_id, r.route_short_name, r.route_long_name ORDER BY avg_duration DESC LIMIT 10;

-- 3. Routes with the Highest Stop Density
-- Ranks transit lines by how many distinct physical stops they serve, highlighting complex or coverage-heavy lines.
SELECT r.route_short_name, r.route_long_name, COUNT(DISTINCT st.stop_id) AS unique_stops 
FROM routes r 
JOIN trips t ON r.route_id = t.route_id 
JOIN stop_times st ON t.trip_id = st.trip_id 
GROUP BY r.route_id, r.route_short_name, r.route_long_name ORDER BY unique_stops DESC LIMIT 10;

-- 4. Earliest First Departure per Route
-- Determines which lines wake up the earliest in the morning by finding the absolute first scheduled departure time.
SELECT r.route_short_name, MIN(st.departure_time) AS first_service_time 
FROM routes r 
JOIN trips t ON r.route_id = t.route_id 
JOIN stop_times st ON t.trip_id = st.trip_id AND st.stop_sequence = 1 
GROUP BY r.route_id, r.route_short_name ORDER BY first_service_time ASC;

-- 5. Late-Night & Overnight Service Availability
-- Measures late-night coverage by isolating trips running past midnight or during early pre-dawn hours.
SELECT r.route_short_name, COUNT(DISTINCT t.trip_id) AS night_trips 
FROM trips t 
JOIN routes r ON t.route_id = r.route_id 
JOIN stop_times st ON t.trip_id = st.trip_id 
WHERE st.departure_time >= '24:00:00' OR st.departure_time < '04:00:00' 
GROUP BY r.route_id, r.route_short_name ORDER BY night_trips DESC;

-- 6. Major Transfer Point Detection
-- Finds critical system interchanges where the highest number of distinct transit routes intersect.
SELECT s.stop_name, COUNT(DISTINCT t.route_id) AS routes_served 
FROM stops s 
JOIN stop_times st ON s.stop_id = st.stop_id 
JOIN trips t ON st.trip_id = t.trip_id 
GROUP BY s.stop_id, s.stop_name HAVING routes_served > 1 
ORDER BY routes_served DESC LIMIT 10;

-- 7. Trip Count Distribution Across Service Categories
-- Reveals operational volume differences across distinct scheduling calendars (such as weekdays vs. weekends vs. holidays).
SELECT service_id, COUNT(trip_id) AS total_trips 
FROM trips 
GROUP BY service_id ORDER BY total_trips DESC;

-- 8. Average Number of Stops per Trip by Route
-- Differentiates local, frequent-stop routes from express or direct service lines.
SELECT r.route_short_name, AVG(stop_count) AS avg_stops_per_trip 
FROM routes r 
JOIN trips t ON r.route_id = t.route_id 
JOIN (
    SELECT trip_id, COUNT(stop_id) AS stop_count 
    FROM stop_times GROUP BY trip_id
) counts ON t.trip_id = counts.trip_id 
GROUP BY r.route_id, r.route_short_name ORDER BY avg_stops_per_trip DESC LIMIT 10;

-- 9. Peak Morning Service Concentration (7 AM – 9 AM)
-- Identifies which routes deploy the most vehicles during peak morning commute hours.
SELECT r.route_short_name, COUNT(DISTINCT t.trip_id) AS morning_rush_trips 
FROM trips t 
JOIN routes r ON t.route_id = r.route_id 
JOIN stop_times st ON t.trip_id = st.trip_id 
WHERE st.stop_sequence = 1 AND st.departure_time BETWEEN '07:00:00' AND '09:00:00' 
GROUP BY r.route_id, r.route_short_name ORDER BY morning_rush_trips DESC LIMIT 10;

-- 10. Geographic Network Coverage Extents
-- Extracts the extreme geographic boundaries of the entire transit network to set up spatial mapping boundaries.
SELECT 
    MIN(stop_lat) AS southernmost_lat, MAX(stop_lat) AS northernmost_lat,
    MIN(stop_lon) AS westernmost_lon, MAX(stop_lon) AS easternmost_lon 
FROM stops;