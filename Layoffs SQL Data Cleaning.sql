-- Data Cleaning

-- 1. Create copy of table to preserve raw data 
-- 2. Remove Duplicates
-- 3. Standarized the Data
-- 4. Clean null Values or blank values
-- 5. Remove Any Columns


-- Familiarize with data
SELECT *
FROM world_layoffs.layoffs;

SELECT COUNT(*)
FROM world_layoffs.layoffs;

-- 1. Table copy & confirm changes
CREATE TABLE world_layoffs.layoffs_v2
LIKE world_layoffs.layoffs;

INSERT INTO world_layoffs.layoffs_v2
SELECT *
FROM world_layoffs.layoffs;

SELECT *
FROM world_layoffs.layoffs_v2;

-- 2. Finding duplicate rows
-- Any row_num with "2" or more is considered a duplicate
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, 
total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM world_layoffs.layoffs_v2;

-- Creating a cte to identify duplicate rows
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, 
total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM world_layoffs.layoffs_v2
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- Investigating a duplicate company
SELECT *
FROM world_layoffs.layoffs_v2
WHERE company = 'Casper';

-- Creating v3 table with new "row_num" column for counting duplicates
USE world_layoffs;

CREATE TABLE `layoffs_v3` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Confirming v3 creation & inserting data
SELECT *
FROM world_layoffs.layoffs_v3;

INSERT INTO world_layoffs.layoffs_v3
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, 
total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM world_layoffs.layoffs_v2;

-- Removing duplicates and confirming change

DELETE
FROM world_layoffs.layoffs_v3
WHERE row_num > 1;

SELECT *
FROM world_layoffs.layoffs_v3
WHERE row_num > 1;

-- 3. Checking columns for errors and standardizing data
SELECT company, TRIM(company)
FROM world_layoffs.layoffs_v3;

-- Trimming out leading and trailing spaces
UPDATE world_layoffs.layoffs_v3
SET company = TRIM(company);

SELECT DISTINCT(industry)
FROM world_layoffs.layoffs_v3
ORDER BY 1;

SELECT *
FROM world_layoffs.layoffs_v3
WHERE industry LIKE 'Crypto%';

-- Discover from previous query that "crypto" is typed inconsistently
UPDATE world_layoffs.layoffs_v3
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT location
FROM world_layoffs.layoffs_v3
ORDER BY 1;

SELECT DISTINCT country
FROM world_layoffs.layoffs_v3
ORDER BY 1;

SELECT DISTINCT country
FROM world_layoffs.layoffs_v3
WHERE country LIKE 'United States%';

-- Discovered from previous query that "United States" is typed inconsistently
UPDATE world_layoffs.layoffs_v3
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Converting dates from text to correct format
SELECT `date`, STR_TO_DATE(`date`, '%m/%d/%Y')
FROM world_layoffs.layoffs_v3;

UPDATE world_layoffs.layoffs_v3
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE world_layoffs.layoffs_v3
MODIFY COLUMN `date` DATE;

SELECT `date`
FROM world_layoffs.layoffs_v3;

-- 4. Find null or blank values and filling them appropriately 
SELECT *
FROM world_layoffs.layoffs_v3
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM world_layoffs.layoffs_v3
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM world_layoffs.layoffs_v3
WHERE company = 'Airbnb';

-- Find companies with missing industry values by matching them to rows 
-- of the same company where industry is not null
SELECT t1.industry, t2.industry
FROM world_layoffs.layoffs_v3 t1
JOIN world_layoffs.layoffs_v3 t2
  ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
  AND t2.industry IS NOT NULL;

-- Replacing blank values with null values so we can fill data
UPDATE world_layoffs.layoffs_v3
SET industry = NULL
WHERE industry = '';

-- Update missing industry values by copying the industry from another row 
-- of the same company where it is available.
UPDATE world_layoffs.layoffs_v3 t1
JOIN world_layoffs.layoffs_v3 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- 5. Column and row removal
DELETE 
FROM world_layoffs.layoffs_v3
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM world_layoffs.layoffs_v3;

ALTER TABLE world_layoffs.layoffs_v3
DROP COLUMN row_num;


-- The layoffs_v3 table is now cleaned and ready for analysis.
-- Steps completed:
--   - Removed duplicate rows
--   - Standardized company, country, and industry values
--   - Converted dates into proper DATE format
--   - Filled missing and blank values where possible
--   - Dropped helper columns used for cleaning
-- Note: Some null values remain where accurate data could not be confirmed.





