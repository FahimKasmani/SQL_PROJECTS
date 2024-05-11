/*
2. What skills are required for the top paying data analyst Role??
    - will use CTE for this one

*/

With top_pay_jobs As (
    SELECT
    job_id,
    job_title,
    c.name as company_name,
    salary_year_avg
From 
    job_postings_fact as j 
INNER JOIN company_dim as c ON 
j.company_id = c.company_id
Where 
    salary_year_avg is Not NULL AND 
    job_work_from_home =TRUE AND
    job_title_short = 'Data Analyst'
ORDER BY
    salary_year_avg DESC
LIMIT 10 
)
SELECT top_pay_jobs.*, sk.skills
From top_pay_jobs
INNER JOIN skills_job_dim as sj ON
top_pay_jobs.job_id = sj.job_id
INNER JOIN skills_dim as sk ON
sj.skill_id = sk.skill_id

ORDER BY 
    salary_year_avg DESC