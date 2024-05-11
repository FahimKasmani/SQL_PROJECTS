/*
4. What are the top skills based on salary?
    - Look at the average salary associated with each  skill for Data Analyst roles
    - Focuses on roles with the specified salaries, regardless of location
    - why? It reveals how different skills impact salry levels of Data Analyst role and helps identify
        the most financially rewarding skills to acquire or improve.
*/

SELECT 
    sk.skills,
    ROUND (AVG(salary_year_avg), 2) as Avg_salary
From job_postings_fact as j
INNER JOIN skills_job_dim as sj ON
j.job_id = sj.job_id
INNER JOIN skills_dim as sk ON
sj.skill_id = sk.skill_id
Where 
    job_title_short = 'Data Analyst'
    And salary_year_avg is NOT NULL
    AND job_work_from_home = TRUE
GROUP BY
    sk.skills
ORDER BY
    Avg_salary DESC
LIMIT 25 