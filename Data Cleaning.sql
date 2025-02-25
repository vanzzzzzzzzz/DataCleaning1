-- Data Cleaning --

create database world_layoffs;
-- 1. Remove Duplictaes
-- 2. Standardize  Data
-- 3. NULL and Blank Values
-- 4. Remove any Columns


-- Remove Duplicates
create table layoffs_staging like layoffs;
insert into layoffs_staging
select * from layoffs;

select * from layoffs_staging;


with duplicate_staging as(
select *, row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging)
select * from duplicate_staging
where row_num >1;

select * from layoffs_staging
where company = 'casper';

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
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert layoffs_staging2
select *, row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging;

select * from layoffs_staging2;

delete from layoffs_staging2 where row_num>1;




-- Standardize Data
update layoffs_staging2
set company = trim(company);

select distinct(industry) from layoffs_staging2 order by 1;

update layoffs_staging2
set industry = 'Crypto Currency'
where industry like 'Crypto%';

update layoffs_staging2
set country = 'United States'
where country like 'United States%';

# OR
# update layoffs_staging2 set country = trim(trailing "." from country)
# "TRIM(TRAILING ".") means we trim "." from the back of column "country"

alter table layoffs_staging
modify column `date` date;
# Got an error because incorrect date value format, so we must chance to the correct format

select `date`, str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2;

update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

alter table layoffs_staging2
modify column `date` date;




-- NULL and Blank Values
select * from layoffs_staging2;

select * from layoffs_staging2
where (total_laid_off is NULL or '')
and (percentage_laid_off is null or '');

select * from layoffs_staging2
where industry is null
or industry = '';

select * from layoffs_staging2 where company = 'Airbnb';

select t1.industry, t2.industry from layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company=t2.company
and t1.location=t2.location
where (t1.industry is null or t1.industry ='')
and t2.industry is not null and t2.industry != '';

update layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company = t2.company
set t1.industry = t2.industry
where (t1.industry is null or t1.industry = '')
and t2.industry is not null and t2.industry != '';




-- Remove any Columns
select * from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

delete from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

alter table layoffs_staging2
drop column row_num;

select*from layoffs_staging2;
