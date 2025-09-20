use db;

-- Database Exploration

select *
from information_schema.columns
where table_name = 'layoffs_unraw2';

-- Dimensions Exploration

select distinct country
from layoffs_unraw2;

select count(distinct country) as 'number of countries'
from layoffs_unraw2;

select distinct company
from layoffs_unraw2;

select count(distinct company) as 'number of companies'
from layoffs_unraw2;

select distinct industry
from layoffs_unraw2;

select count(distinct industry) as 'number of industries'
from layoffs_unraw2
where industry is not null;

-- Date Exploration

select min(year(`date`)) as 'earliest year', max(year(`date`)) as 'latest year'
from layoffs_unraw2;

-- Measures Exploration

select *
from layoffs_unraw2;

-- 1. What is the total number of people laid off globally?

select sum(total_laid_off) as 'Total_laid_off'
from layoffs_unraw2
where total_laid_off is not null;

-- 2. How many individual layoff events are recorded?

select count(*) as 'Total_Events'
from layoffs_unraw2;

-- 3. What is the small size of a layoff event

select min(total_laid_off) as 'Min_laid_off'
from layoffs_unraw2;

-- 4. What is the large size of a layoff event

select max(total_laid_off) as 'Max_laid_off'
from layoffs_unraw2;

-- 5. What is the average size of a layoff event?

select round(avg(total_laid_off),2) as 'Average_laid_off'
from layoffs_unraw2
where total_laid_off is not null;

-- 6. Which companies had the top 5 largest single layoff events?

select company, total_laid_off
from layoffs_unraw2
order by total_laid_off desc
limit 5;

-- 7. Which countries have been most impacted by layoffs?

select country, sum(total_laid_off) as Total_Laid_Off
from layoffs_unraw2
where total_laid_off is not null
group by country
order by Total_Laid_Off desc
limit 10;

-- 8. Which industry sector saw the most layoffs?

select industry, sum(total_laid_off) as Total_Laid_Off
from layoffs_unraw2
where total_laid_off is not null and industry is not null
group by industry
order by Total_Laid_Off desc
limit 10;


-- Magnitude Analysis

-- 1. Find total layoff events by companies.

select company, count(total_laid_off) as 'Total_layoff'
from layoffs_unraw2
where total_laid_off is not null
group by company
order by Total_layoff desc;

-- 2. Find total layoff events by countries.

select country, count(total_laid_off) as 'Total_layoff'
from layoffs_unraw2
where total_laid_off is not null
group by country
order by Total_layoff desc;

-- 3. Find total layoff events by industries.

select industry, count(total_laid_off) as 'Total_layoff'
from layoffs_unraw2
where total_laid_off is not null
group by industry
order by Total_layoff desc;
