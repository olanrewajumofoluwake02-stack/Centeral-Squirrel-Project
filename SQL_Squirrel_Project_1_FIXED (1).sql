CREATE DATABASE IF NOT EXISTS Central_Park_Squirrel_Census;
USE Central_Park_Squirrel_Census;

-- ===================================================
-- CLEANING
-- ===================================================

-- SET SQL_SAFE_UPDATES = 0;

-- -- Convert Date from text (MMDDYYYY) to a real DATE type
-- UPDATE `2018__squirrel_data`
-- SET Date = STR_TO_DATE(Date, '%m%d%Y');

-- ALTER TABLE `2018__squirrel_data`
-- MODIFY COLUMN Date DATE;

-- -- Convert 'true'/'false' text columns to 1/0
-- UPDATE `2018__squirrel_data`
-- SET Running = CASE WHEN Running = 'true' THEN 1 ELSE 0 END,
--     Chasing = CASE WHEN Chasing = 'true' THEN 1 ELSE 0 END,
--     Climbing = CASE WHEN Climbing = 'true' THEN 1 ELSE 0 END,
--     Eating = CASE WHEN Eating = 'true' THEN 1 ELSE 0 END,
--     Foraging = CASE WHEN Foraging = 'true' THEN 1 ELSE 0 END,
--     Kuks = CASE WHEN Kuks = 'true' THEN 1 ELSE 0 END,
--     Quaas = CASE WHEN Quaas = 'true' THEN 1 ELSE 0 END,
--     Moans = CASE WHEN Moans = 'true' THEN 1 ELSE 0 END,
--     `Tail flags` = CASE WHEN `Tail flags` = 'true' THEN 1 ELSE 0 END,
--     `Tail twitches` = CASE WHEN `Tail twitches` = 'true' THEN 1 ELSE 0 END,
--     Approaches = CASE WHEN Approaches = 'true' THEN 1 ELSE 0 END,
--     Indifferent = CASE WHEN Indifferent = 'true' THEN 1 ELSE 0 END,
--     `Runs from` = CASE WHEN `Runs from` = 'true' THEN 1 ELSE 0 END;

-- ALTER TABLE `2018__squirrel_data`
--     MODIFY COLUMN Running TINYINT(1),
--     MODIFY COLUMN Chasing TINYINT(1),
--     MODIFY COLUMN Climbing TINYINT(1),
--     MODIFY COLUMN Eating TINYINT(1),
--     MODIFY COLUMN Foraging TINYINT(1),
--     MODIFY COLUMN Kuks TINYINT(1),
--     MODIFY COLUMN Quaas TINYINT(1),
--     MODIFY COLUMN Moans TINYINT(1),
--     MODIFY COLUMN `Tail flags` TINYINT(1),
--     MODIFY COLUMN `Tail twitches` TINYINT(1),
--     MODIFY COLUMN Approaches TINYINT(1),
--     MODIFY COLUMN Indifferent TINYINT(1),
--     MODIFY COLUMN `Runs from` TINYINT(1);

-- -- Drop redundant column (we already have X and Y separately)
-- ALTER TABLE `2018__squirrel_data`
-- DROP COLUMN `Lat/Long`;

-- ALTER TABLE `2018__squirrel_data`
--     MODIFY COLUMN X DECIMAL(10, 7),
--     MODIFY COLUMN Y DECIMAL(10, 7);

-- -- Clean up blank / placeholder values into proper NULLs
-- UPDATE `2018__squirrel_data`
-- SET Age = NULL WHERE Age = '' OR Age = '?';

-- UPDATE `2018__squirrel_data`
-- SET `Primary Fur Color` = NULL WHERE `Primary Fur Color` = '';

-- UPDATE `2018__squirrel_data`
-- SET Location = NULL WHERE Location = '';

-- -- Replace 'FALSE'/'false'/blank/'Ground Plane' with NULL, then convert to INT
-- UPDATE `2018__squirrel_data`
-- SET `Above Ground Sighter Measurement` = NULL
-- WHERE `Above Ground Sighter Measurement` IN ('FALSE', 'false', '', 'Ground Plane');

-- ALTER TABLE `2018__squirrel_data`
-- MODIFY COLUMN `Above Ground Sighter Measurement` INT;

-- UPDATE `2018__squirrel_data`
-- SET
--     `Highlight Fur Color` = NULLIF(`Highlight Fur Color`, ''),
--     `Color notes` = NULLIF(`Color notes`, ''),
--     `Specific Location` = NULLIF(`Specific Location`, ''),
--     `Other Activities` = NULLIF(`Other Activities`, ''),
--     `Other Interactions` = NULLIF(`Other Interactions`, ''); 
    


-- ===================================================
-- ANALYSIS
-- ===================================================

-- Total squirrel sightings
SELECT COUNT(*) AS total_sightings
FROM `2018__squirrel_data`;

-- Sightings per hectare, most active hectares first
SELECT hectare, COUNT(*) AS sighting_count
FROM `2018__squirrel_data`
GROUP BY hectare
ORDER BY sighting_count DESC;

-- Behavior summary: how many squirrels were seen doing each behavior
-- (columns are now 1/0, so we SUM them directly instead of comparing to 'TRUE')
SELECT
    SUM(Running) AS Running,
    SUM(Chasing) AS Chasing,
    SUM(Climbing) AS Climbing,
    SUM(Eating) AS Eating,
    SUM(Foraging) AS Foraging,
    SUM(Kuks) AS Kuks,
    SUM(Quaas) AS Quaas,
    SUM(Moans) AS Moans,
    SUM(Approaches) AS Approaches,
    SUM(Indifferent) AS Indifferent
FROM `2018__squirrel_data`;

-- Total sightings by shift (AM/PM)
SELECT shift, COUNT(*) AS total
FROM `2018__squirrel_data`
GROUP BY shift;

-- Running behavior by shift
SELECT shift, COUNT(*) AS running_count
FROM `2018__squirrel_data`
WHERE Running = 1
GROUP BY shift;

-- Foraging behavior by shift
SELECT shift, COUNT(*) AS foraging_count
FROM `2018__squirrel_data`
WHERE Foraging = 1
GROUP BY shift;

-- Locations (Ground Plane / Above Ground) where running was observed
SELECT Location, COUNT(*) AS running_count
FROM `2018__squirrel_data`
WHERE Running = 1
GROUP BY Location
ORDER BY running_count DESC;

-- Running behavior by age group
SELECT Age,
    SUM(Running) AS running_count
FROM `2018__squirrel_data`
GROUP BY Age;

-- Running behavior by primary fur color
SELECT `Primary Fur Color`,
    SUM(Running) AS running_count
FROM `2018__squirrel_data`
GROUP BY `Primary Fur Color`;

-- Sighting count by primary fur color (excluding unknowns)
SELECT `Primary Fur Color`, COUNT(*) AS Count
FROM `2018__squirrel_data`
WHERE `Primary Fur Color` IS NOT NULL
GROUP BY `Primary Fur Color`
ORDER BY Count DESC;

DESCRIBE `2018__squirrel_data`;