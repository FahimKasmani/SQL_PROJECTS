/*
1. What are the top Paying jobs for Data Analyst
    - Identify the top 10 highest-paying Data Analyst role that are available remotely.
*/

SELECT
    job_id,
    job_location,
    job_title_short,
    salary_year_avg
From 
    job_postings_fact
Where 
    salary_year_avg is Not NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10 