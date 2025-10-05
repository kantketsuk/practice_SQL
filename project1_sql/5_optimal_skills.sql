/* 
identify skills in hight demand and associate with hight avg salary for data analyst jobs
*/

WITH skills_demand as (
    SELECT
        skills_dim.skill_id,
        skills,
        count(skills_job_dim.job_id) as demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id=skills_job_dim.job_id
    INNER JOIN skills_dim ON   skills_dim.skill_id = skills_job_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst' AND
        salary_year_avg is not NULL AND
        job_work_from_home = true
    GROUP BY 
        skills_dim.skill_id
),average_salary as (
    SELECT
        skills_dim.skill_id,
        skills,
        round(avg(salary_year_avg),0) as avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id=skills_job_dim.job_id
    INNER JOIN skills_dim ON   skills_dim.skill_id = skills_job_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst' AND
        salary_year_avg is not NULL AND
        job_work_from_home = true
    GROUP BY 
        skills_dim.skill_id
)

SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM skills_demand
INNER JOIN average_salary 
ON average_salary.skill_id = skills_demand.skill_id  
WHERE
    demand_count > 10
ORDER BY 
    avg_salary DESC,
    demand_count DESC


-- rewrite this same quary more concisely
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    count(skills_job_dim.job_id) as demand_count,
    round(avg(salary_year_avg),0) as avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim 
    ON job_postings_fact.job_id=skills_job_dim.job_id
INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg is not NULL AND
    job_work_from_home = true
GROUP BY
    skills_dim.skill_id
HAVING 
    count(skills_job_dim.job_id) > 10
ORDER BY 
    avg_salary DESC,
    demand_count DESC
LIMIT 10