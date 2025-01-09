# US Household Income Data Cleaning

-- Table 1 (income table)
SELECT * 
FROM us_project.us_household_income;

-- Table 2 (stats table)
SELECT * 
FROM us_project.us_household_income_statistics;


-- Renaming ID column in stats table for better usability and readability
ALTER TABLE us_project.us_household_income_statistics RENAME COLUMN `ï»¿id`TO `id`
;

-- Count of rows for our tables do not match
-- us_household_income_statistics table contains more rows
SELECT COUNT(id)
FROM us_household_income;

SELECT COUNT(id)
FROM us_household_income_statistics;

-- Identifying duplicates in income table
SELECT id, COUNT(id)
FROM us_household_income
GROUP BY id
HAVING COUNT(id) > 1;

SELECT *
FROM (
SELECT row_id, 
id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
FROM us_household_income
 ) AS duplicates
 WHERE row_num > 1
;

-- Deleting duplicates in income table
DELETE FROM us_household_income
WHERE row_id IN (
	SELECT row_id
	FROM (
		SELECT row_id, 
		id,
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
	FROM us_household_income
 ) AS duplicates
 WHERE row_num > 1
 )
;

-- No duplicates found in stats table
SELECT id, COUNT(id)
FROM us_household_income_statistics
GROUP BY id
HAVING COUNT(id) > 1;

-- Identifying duplicates in State_Name column
SELECT DISTINCT State_Name
FROM us_household_income
ORDER BY State_Name
;

-- Updating 'Georgia' for State_Name column
UPDATE us_household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia'
;

-- Updating capitalization on 'Alabama' for State_Name column
UPDATE us_household_income
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama'
;


-- Missing value found in Place column
SELECT *
FROM us_household_income
WHERE Place = ''
;

SELECT *
FROM us_household_income
WHERE County = 'Autauga County'
;

-- Updating place to 'Autaugaville' to match existing place value from related rows
UPDATE us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont'
;

-- Identifying duplicate values in Type column
SELECT Type, COUNT(Type)
FROM us_household_income
GROUP BY (Type)
;

-- Updating and removing 'Borough' duplicates
UPDATE us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs'
;


-- No missing data for Awater column found
SELECT DISTINCT AWater
FROM us_household_income
WHERE (AWater = 0) OR (AWater = '') OR (AWater = NULL)
;

-- No values found where ALand and AWater are both zero
SELECT ALand, AWater
FROM us_household_income
WHERE (AWater = 0 OR AWater = '' OR AWater IS NULL)
AND (ALand = 0 OR ALand = '' OR ALand IS NULL)
;

