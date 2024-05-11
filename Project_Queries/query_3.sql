/*
3. What are the most in-demand skill for Data Analyst Role?
    -Retrieve only 5 in demand skill

*/

SELECT
    sk.skills,
    Count(j.job_id) As demand_count
From job_postings_fact as j
INNER JOIN skills_job_dim as sj On 
j.job_id = sj.job_id
INNER JOIN skills_dim as sk On 
sj.skill_id = sk.skill_id

Where job_title_short = 'Data Analyst'

GROUP BY
    sk.skills
ORDER BY 
    demand_count DESC

LIMIT 5