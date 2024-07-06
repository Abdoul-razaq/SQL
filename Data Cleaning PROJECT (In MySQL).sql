SELECT * FROM layoffs; 

-- STEPS OF DATA CLEANING 
	-- 0) CREATE A REFERENCE TABLE FOR AVOIDING ISSUES
	-- 1) REMOVE DUPLICATES IF ANY
	-- 2) STANDARDIZE DATA BY SOLVING PROBLEM IN IT LIKE SPELLING
	-- 3) REMOVE NULL OR ANY BLANK VALUES
	-- 4) REMOVES ANY COLUMN IF is possible


-- 0) CREATE A REFERENCE TABLE FOR AVOIDING ISSUES
CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT INTO layoffs_staging
SELECT * FROM layoffs;

SELECT * FROM layoffs_staging;


-- 1) REMOVE DUPLICATES IF ANY
WITH duplicates_removal AS (
	SELECT *, ROW_NUMBER () OVER(PARTITION BY company,location,industry,total_laid_off, percentage_laid_off, `date`, stage, country,funds_raised_millions) row_num
    FROM layoffs_staging 
    ) select * FROM duplicates_removal WHERE row_num > 1;

SELECT *,ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off, percentage_laid_off, `date`, stage, country,funds_raised_millions)AS row_num
FROM layoffs_staging WHERE row_num >1;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_staging2
SELECT *,ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off, percentage_laid_off, `date`, stage, country,funds_raised_millions)AS row_num
FROM layoffs_staging;

SELECT * FROM layoffs_staging2;
DELETE FROM layoffs_staging2 WHERE row_num > 1;

SELECT * FROM layoffs_staging2 WHERE row_num > 1;


-- 2) STANDARDIZING DATA 
SELECT * FROM layoffs_staging2;
SELECT DISTINCT company FROM layoffs_staging2 
;

UPDATE layoffs_staging2 SET company= TRIM(company);
SELECT * FROM layoffs_staging2;

SELECT DISTINCT industry FROM layoffs_staging2 ORDER BY 1 ;
SELECT * FROM layoffs_staging2 WHERE industry LIKE 'CRYPTO%';

UPDATE layoffs_staging2 SET industry = 'Crypto' WHERE industry LIKE 'crypto%';
SELECT * FROM layoffs_staging2 WHERE industry LIKE 'crypto%';

SELECT DISTINCT country FROM layoffs_staging2 ORDER BY 1 ;
UPDATE layoffs_staging2 SET country = 'United States' WHERE country LIKE 'United State%';

SELECT DISTINCT `DATE`, STR_TO_DATE(`DATE`,'%m/%d/%Y') FROM layoffs_staging2 ORDER BY 1 ;
UPDATE layoffs_staging2 SET `DATE` = STR_TO_DATE(`DATE`,'%m/%d/%Y');
SELECT * FROM layoffs_staging2;

ALTER TABLE layoffs_staging2 
MODIFY COLUMN `DATE` DATE;


-- 3) REMOVE NULL OR ANY BLANK VALUES
SELECT * FROM layoffs_staging2 WHERE ( total_laid_off IS NULL OR total_laid_off ='') AND ( percentage_laid_off IS NULL OR percentage_laid_off ='')
AND ( funds_raised_millions IS NULL OR funds_raised_millions ='') ;

SELECT * FROM layoffs_staging2 WHERE industry IS NULL OR industry ='';
SELECT * FROM layoffs_staging2 WHERE company= 'Airbnb';
UPDATE layoffs_staging2 SET industry='Travel' where company= 'Airbnb'AND location= 'SF Bay Area';

SELECT * FROM layoffs_staging2 WHERE company = 'Carvana';
UPDATE layoffs_staging2 SET industry='Transportation' where company= 'Carvana'AND location= 'Phoenix';

SELECT * FROM layoffs_staging2 WHERE company = 'Juul';
UPDATE layoffs_staging2 SET industry='Consumer' where company= 'Juul' AND location= 'SF Bay Area';


SELECT * FROM layoffs_staging2 WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;
DELETE FROM layoffs_staging2 WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

SELECT * FROM layoffs_staging2;

-- 4) REMOVES ANY COLUMN IF is possible
ALTER TABLE layoffs_staging2 
DROP COLUMN row_num;

SELECT * FROM layoffs_staging2;

