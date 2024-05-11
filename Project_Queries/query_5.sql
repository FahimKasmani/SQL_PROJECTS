/*
5. What are the most optimal skills (aka its in high demand and high paying skills) for Data Analyst Role?
    - Identify skills in high demand and associated with high average salaries for Data Analyst Role
    - Concentrates on remote postions with speciified salaries 
    - Why? Targets skills offer job security(high demand) and financial benefits (high salaries),
      offereing strategic insights for career developmentin data analysis
*/

With Skills_demand As ( 
    SELECT 
    sk.skills,
    sk.skill_id,
    COUNT(sj.job_id) as demand_count
From job_postings_fact as j 
INNER JOIN skills_job_dim as sj ON
j.job_id = sj.job_id 
INNER JOIN skills_dim as sk ON
sj.skill_id = sk.skill_id
where 
    job_title_short = 'Data Analyst'
    And salary_year_avg is NOT NULL
    AND job_work_from_home = TRUE
GROUP BY
    sk.skill_id, sk.skills
) ,
Average_salary As (
    
SELECT 
    sk.skills,
    sk.skill_id,
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
    sk.skill_id, sk.skills
)

Select
    Skills_demand.skill_id,
    Skills_demand.skills,
    demand_count,
    Avg_salary
From Skills_demand 
inner JOIN Average_salary On
Skills_demand.skill_id = Average_salary.skill_id
WHere demand_count > 10
ORDER BY  Avg_salary DESC, demand_count DESC


/*
2 nd way of doing it
*/
-- In select statement we will select the desired column as output using Inner Join
Select
    sk.skill_id,
    sk.skills,
    Count(j.job_id) as demand_count,
    ROUND(Avg(salary_year_avg)) as Avg_salary
From job_postings_fact as j 
inner Join skills_job_dim as sj on 
j.job_id = sj.job_id
inner Join skills_dim as sk On
sj.skill_id = sk.skill_id

-- In the Where clause we will add a conditions to be followed

Where 
    job_work_from_home = True AND 
    salary_year_avg is Not Null AND 
    job_title_short = 'Data Analyst'
GROUP By 
    sk.skill_id,
    sk.skills
Having
    Count(j.job_id) > 10
Order By
    Avg_salary DESC,
    demand_count DESC
LIMIT 25;