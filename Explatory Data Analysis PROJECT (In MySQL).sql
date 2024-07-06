SELECT * FROM layoffs_staging2;

SELECT MAX(total_laid_off),MIN(total_laid_off)
FROM layoffs_staging2;


SELECT MAX(percentage_laid_off),MIN(percentage_laid_off)
FROM layoffs_staging2;


SELECT * FROM layoffs_staging2 ORDER BY funds_raised_millions DESC ;


SELECT MAX(`date`) AS ending_date ,MIN(`date`) AS starting_date
FROM layoffs_staging2;

SELECT company, SUM(total_laid_off) FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


SELECT industry, SUM(total_laid_off) FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off) FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;


SELECT country, AVG(total_laid_off) FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;


SELECT `date`, SUM(total_laid_off) FROM layoffs_staging2
GROUP BY `date`
ORDER BY 1 DESC;


SELECT YEAR(`date`), SUM(total_laid_off) FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 2 DESC;


SELECT MONTH(`date`) AS `month`, SUM(total_laid_off) FROM layoffs_staging2
GROUP BY MONTH(`date`)
ORDER BY 2 DESC;


WITH Rolling_total AS 
(
	SELECT SUBSTR(`date`,1,7) AS `month`,SUM(total_laid_off) AS total_off FROM layoffs_staging2
	GROUP BY SUBSTR(`date`,1,7)
	ORDER BY SUBSTR(`date`,1,7)
)
SELECT *, SUM(total_off) OVER(ORDER BY `month`) AS rolling_sum FROM Rolling_total;


WITH company_year(company,years,total_laid_off) AS
(
SELECT company,year(`date`), SUM(total_laid_off) FROM layoffs_staging2
GROUP BY company,year(`date`)
)
SELECT *, 
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS ranking 
FROM company_year
WHERE total_laid_off IS NOT NULL
ORDER BY ranking ASC;
