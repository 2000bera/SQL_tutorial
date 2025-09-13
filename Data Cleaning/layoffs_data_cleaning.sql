-- DATA CLEANING

create database db;

use db;

-- RAW DATA
select *
from layoffs;

-- 1. REMOVING DUPLICATES
-- 2. STANDARDIZE THE DATA
-- 3. NULL VALUES/EMPTY COLUMNS/NO VALUES
-- 4. REMOVING COLUMNS

-- GENERATING NEW DATABASE TO KEEP RAW DATABASE

create table layoffs_unraw1
like layoffs;

-- EMPTY DATA
select *
from layoffs_unraw1;

-- INSERT TO NEW DATABASE
insert into layoffs_unraw1
select *
from layoffs;

select *
from layoffs_unraw1;

-- 1 REMOVING DUPLICATES
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_unraw1;

with duplicate_db as
(
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_unraw1
)
select *
from duplicate_db
where row_num > 1;

select *
from layoffs_unraw1
where company = 'Casper';

CREATE TABLE `layoffs_unraw2` (
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

select *
from layoffs_unraw2;

insert into layoffs_unraw2
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_unraw1;

select *
from layoffs_unraw2
where row_num > 1;

delete 
from layoffs_unraw2
where row_num > 1;

-- 2. STANDARDIZE THE DATA
select *
from layoffs_unraw2;

select company, trim(company)
from layoffs_unraw2;

update layoffs_unraw2
set company = trim(company);

select distinct industry
from layoffs_unraw2
order by 1;

select *
from layoffs_unraw2
where industry like 'Crypto%';

update layoffs_unraw2
set industry = 'Crypto'
where industry like 'Crypto%';

select distinct location
from layoffs_unraw2
order by 1;

select distinct country
from layoffs_unraw2
order by 1;

select *
from layoffs_unraw2
where country like 'United States.%';

update layoffs_unraw2
set country = 'United States'
where country like 'United States.%';

select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_unraw2;

update layoffs_unraw2
set `date` = str_to_date(`date`, '%m/%d/%Y');

alter table layoffs_unraw2
modify column `date` date;

-- 3. NULL VALUES/NO VALUES/EMPTY DATA
select *
from layoffs_unraw2
where total_laid_off is null
and percentage_laid_off is null;

update layoffs_unraw2
set industry = null
where industry = '';

select *
from layoffs_unraw2
where industry is null
or industry = '';

select *
from layoffs_unraw2
where company like 'Bally%';

select table1.industry, table2.industry
from layoffs_unraw2 table1
join layoffs_unraw2 table2
	on table1.company = table2.company
where (table1.industry is null or table1.industry = '')
and table2.industry is not null;

update layoffs_unraw2 table1
join layoffs_unraw2 table2
	on table1.company = table2.company
set table1.industry = table2.industry
where table1.industry is null
and table2.industry is not null;

delete
from layoffs_unraw2
where total_laid_off is null
and percentage_laid_off is null;

select *
from layoffs_unraw2
order by 1;

-- 4. REMOVING COLUMNS
alter table layoffs_unraw2
drop column row_num;

select *
from layoffs_unraw2;





