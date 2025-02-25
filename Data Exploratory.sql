select * from layoffs_staging2;

select total_laid_off, percentage_laid_off from layoffs_staging2
where total_laid_off is not null
and percentage_laid_off is not null
order by 1 desc;

select * from layoffs_staging2
where total_laid_off is not null 
and percentage_laid_off is not null
and percentage_laid_off = 1
order by total_laid_off desc;


# Menganalisis perusahaan yang memiliki fund raised terbesar melakukan berapa banyak layid off
select company, funds_raised_millions, industry, total_laid_off, percentage_laid_off from layoffs_staging2
order by 2 desc;

select company, total_laid_off, percentage_laid_off from layoffs_staging2
where company = 'uber';

# Mencari industry yang percentage_laid_off != 1
select funds_raised_millions, industry, total_laid_off, percentage_laid_off from layoffs_staging2
where  industry not in(
select industry from layoffs_staging2
where percentage_laid_off = 1)
order by 3 desc;


# Menganalisis rata-rata persentase layoff secara time-series
select left(`date`, 7) `date1`, sum(total_laid_off), avg(percentage_laid_off)
from layoffs_staging2
group by `date1`
order by 1;
# 2020-11 - 2021-10 merupakan rentang waktu dengan persentase tertinggi pada data
# 2022-05 - 2023-03 merupakan rentang waktu yang memiliki layoff terparah walau memiliki persentase yang rendah
