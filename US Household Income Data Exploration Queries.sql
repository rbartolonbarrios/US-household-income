# US Household Income Exploratory Data Analysis Queries

-- Table 1 (income table)
SELECT *
FROM us_household_income;

-- Table 2 (stats table)
SELECT *
FROM us_household_income_statistics;

-- No findings from land and water columns
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_household_income
GROUP BY State_Name
ORDER BY 3 DESC
LIMIT 10
;

-- Joining income and stats table
SELECT *
FROM us_household_income uhi
JOIN us_household_income_statistics uhis
	ON uhi.id = uhis.id
;

-- It would be sensible to perform left join on income table since stats table contains more rows
-- Discrepancy is due to some rows from income table not importing correctly
SELECT *
FROM us_household_income uhi
LEFT JOIN us_household_income_statistics uhis
	ON uhi.id = uhis.id
;

-- Performing a right join and filtering for blanks to determine where missing values are present
SELECT *
FROM us_household_income uhi
RIGHT JOIN us_household_income_statistics uhis
	ON uhi.id = uhis.id
WHERE uhi.County IS NULL
;
#

-- 240 records from income table are null. We can either amend missing values on Excel or consider deleting these rows 
-- Opting to proceed using an inner join instead
SELECT *
FROM us_household_income uhi
INNER JOIN us_household_income_statistics uhis
	ON uhi.id = uhis.id
;

-- Some zero values rows observed in Mean, Median, Stdev columns
-- Opting to exclude these rows
SELECT *
FROM us_household_income uhi
INNER JOIN us_household_income_statistics uhis
	ON uhi.id = uhis.id
WHERE Mean <> 0
;

SELECT uhi.State_Name, County, Type, `Primary`, Mean, Median
FROM us_household_income uhi
INNER JOIN us_household_income_statistics uhis
	ON uhi.id = uhis.id
WHERE Mean <> 0
;

-- Top 10 states with the highest median income
-- Average income column added for comparison
SELECT uhi.State_Name, ROUND(AVG(Mean), 1) AS avg_income, ROUND(AVG(Median), 1) AS med_income
FROM us_household_income uhi
INNER JOIN us_household_income_statistics uhis
	ON uhi.id = uhis.id
WHERE Mean <> 0
GROUP BY uhi.State_Name
ORDER BY 3 DESC
LIMIT 10
;

-- Does Type tells us anything in relation to average and median income?
SELECT `Type`, COUNT(`Type`), ROUND(AVG(Mean), 1) AS avg_income, ROUND(AVG(Median), 1) AS med_income
FROM us_household_income uhi
INNER JOIN us_household_income_statistics uhis
	ON uhi.id = uhis.id
WHERE Mean <> 0
GROUP BY `Type`
ORDER BY 4 DESC
;

-- 'County', 'Urban', and 'Community' Types have the lowest median incomes
-- Which states have these Type?
SELECT *
FROM us_household_income
WHERE Type IN ('County', 'Urban', 'Community')
;
-- Only two values for 'County' type. All 'Community' and 'Urban' type are in Puerto Rico

-- Opting to remove Types that have a low count since these are outliers
SELECT `Type`, COUNT(`Type`), ROUND(AVG(Mean), 1) AS avg_income, ROUND(AVG(Median), 1) AS med_income
FROM us_household_income uhi
INNER JOIN us_household_income_statistics uhis
	ON uhi.id = uhis.id
WHERE Mean <> 0
GROUP BY `Type`
HAVING COUNT(`Type`) > 100
ORDER BY 4 DESC
;

-- Average and median income at the city level
SELECT uhi.State_Name, City, ROUND(AVG(Mean), 1) AS avg_income, ROUND(AVG(Median), 1) AS med_income
FROM us_household_income uhi
INNER JOIN us_household_income_statistics uhis
	ON uhi.id = uhis.id
GROUP BY uhi.State_Name, City
ORDER BY 3 DESC
LIMIT 10
;
