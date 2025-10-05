# Introduce
 this project explores top-paying jobs,
 in-demand skills,and where high demand meets high salary in data analytics.

Check my sql queries out here: [project1_sql folder](/project1_sql/)
### The question I wanted to answer through my SQL queries were:
1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I Used

- **SQL**
- **PostgreSQL**
- **Visual Studio Code**
- **Git & Github**
# The Analysis
here is how I approached each question:

### 1.Top Paying Data Analyst Jobs
Data Analyst positions by average yearly salary, focused on remote jobs, showing the top 10 highest-paying roles with company name, job type, posting date, and location.

```sql
SELECT 
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date::Date,
    name as company_name
FROM job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg is not null  
ORDER BY salary_year_avg DESC
LIMIT 10
```
![top paying roles](assets/1.top%20paying%20jobs%20chart.png)
*ChatGPT generated this graph from my SQL query results.
 
 ### 2.Skills For Top Paying Jobs
 Top 10 Highest-Paying Data Analyst Positions, Focused on Remote Roles, providing Skills Required for High-Compensation Jobs.
 
 ```sql
 WITH top_paying_jobs as (
    SELECT 
        job_id,
        job_title,
        salary_year_avg,
        name as company_name
    FROM job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE 
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg is not null  
    ORDER BY salary_year_avg DESC
    LIMIT 10
    )
SELECT 
    top_paying_jobs.*,
    skills as skills_name
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC
LIMIT 10
```
Most demanded skills for the top 10 highest paying data analyst jobs in 2023 are SQL, Python, and Tableau, followed by R, Snowflake, Pandas, and Excel.

### 3.In-Demand Skills for Data Analysts
This SQL query identifies the top 5 most in-demand skills for remote Data Analyst positions by counting how many job postings require each skill.

```sql
SELECT
    skills,
    count(skills_job_dim.job_id) as demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id=skills_job_dim.job_id
INNER JOIN skills_dim ON   skills_dim.skill_id = skills_job_dim.skill_id
WHERE job_title_short = 'Data Analyst' AND
    job_work_from_home = true
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5
```
The top 5 most in-demand skills for remote Data Analyst roles are SQL, Excel, Python, Tableau, and Power BI, ranked by the number of job postings requiring each skill. SQL leads the demand, reflecting its essential role in data analysis, followed by Excel and Python.

| Skill   | Demand Count |
|---------|-------------|
| SQL     | 7291        |
| Excel   | 4611        |
| Python  | 4330        |
| Tableau | 3745        |
| Power BI| 2609        |
 *Table of the demand for the top 5 skills in data analyst job postings

### 4.Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
SELECT
    skills,
    round(avg(salary_year_avg),0) as avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim 
ON job_postings_fact.job_id=skills_job_dim.job_id
INNER JOIN skills_dim 
ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND
    salary_year_avg is not NULL AND
    job_work_from_home = true
GROUP BY 
    skills
ORDER BY 
    avg_salary DESC
LIMIT 25
```
The table highlights the top 10 skills linked to the highest-paying remote Data Analyst roles. PySpark tops the list with an average salary of $208,172, followed by Bitbucket and Couchbase/Watson. These results show that specialized technical skills, particularly in big data, version control, and AI/ML tools, are strongly associated with higher compensation in remote positions.

| Skill          | Average Salary ($) |
|----------------|-----------------|
| PySpark        | 208,172         |
| Bitbucket      | 189,155         |
| Couchbase      | 160,515         |
| Watson         | 160,515         |
| DataRobot      | 155,486         |
| GitLab         | 154,500         |
| Swift          | 153,750         |
| Jupyter        | 152,777         |
| Pandas         | 151,821         |
| Elasticsearch  | 145,000         |
*Table of top 10 Highest-Paying Skills for Remote Data Analyst Positions

### 5.Most Optimal Skills to Learn
This query aims to identify skills that are both in high demand and have high salaries,providing a strategic focus for skill development.
```sql
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
```

| Skill ID | Skill       | Demand Count | Average Salary ($) |
|----------|------------|--------------|------------------|
| 8        | Go         | 27           | 115,320          |
| 234      | Confluence | 11           | 114,210          |
| 97       | Hadoop     | 22           | 113,193          |
| 80       | Snowflake  | 37           | 112,948          |
| 74       | Azure      | 34           | 111,225          |
| 77       | BigQuery   | 13           | 109,654          |
| 76       | AWS        | 32           | 108,317          |
| 4        | Java       | 17           | 106,906          |
| 194      | SSIS       | 12           | 106,683          |
| 233      | Jira       | 20           | 104,918          |

*Top 10 Skills for Remote Data Analyst Rolesby Salary and Demand

- Highest-paying skills: Go, Confluence, Hadoop
- High-demand & competitive salary skills: Snowflake, Azure, AWS

# What i learned
1. **Coding and SQL Analysis Skills**

Practiced writing SQL queries, including basic data retrieval, joining multiple tables, filtering data (WHERE/HAVING), ranking (ORDER BY/LIMIT), and aggregation (COUNT, AVG).

Learned to translate business questions into SQL queries that provide actionable insights from data.

2. **Understanding Data Analytics and Job Market**

Analyzed salaries, skill demand, and the relationship between skills and compensation.

Gained insight into which skills are most valuable, which provide higher pay, and how to strategically plan skill development.

3. **Communication and Reporting with Markdown/Visualization**

Learned to summarize results in README.md using tables, bullet points, and charts for clear and professional presentation.

Practiced communicating technical information in a way that is understandable for non-technical audiences.

# Conclusions
This project provided a comprehensive analysis of remote Data Analyst roles, focusing on top-paying jobs, in-demand skills, and the intersection of high demand and high salary. Key takeaways include:

- **Top-paying roles** reveal which positions and companies offer the highest compensation, helping guide career planning.  
- **In-demand skills** like SQL, Python, and Tableau are essential for securing competitive positions, while specialized tools such as PySpark, Snowflake, and DataRobot can significantly increase earning potential.  
- **Strategic skill development** can be informed by combining both demand and salary data, allowing aspiring Data Analysts to prioritize learning skills that maximize both employability and compensation.  

Overall, this analysis highlights the importance of **data-driven decision making** in career development and provides actionable insights for anyone looking to succeed in remote Data Analyst roles.