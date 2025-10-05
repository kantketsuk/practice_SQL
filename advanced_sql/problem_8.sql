SELECT 
    salary_year_avg,
    job_via,
    job_posted_date::Date 
FROM(
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL 
    SELECT *
    FROM march_jobs
) as quarter_job
WHERE salary_year_avg > 70000 AND
    job_title_short = 'Data Analyst' AND
    job_country = 'Thailand'
ORDER BY salary_year_avg DESC
LIMIT 10
;