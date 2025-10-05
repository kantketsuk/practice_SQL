
CREATE TABLE january_job as 
 SELECT *
 FROM job_postings_fact 
 WHERE EXTRACT (month FROM job_postings_fact.job_posted_date) = 1

CREATE TABLE fabuary_job as
 SELECT *
 FROM job_postings_fact 
 WHERE EXTRACT (month FROM job_postings_fact.job_posted_date) = 2

CREATE TABLE march_job as
 SELECT *
 FROM job_postings_fact 
 WHERE EXTRACT (month FROM job_postings_fact.job_posted_date) = 3
