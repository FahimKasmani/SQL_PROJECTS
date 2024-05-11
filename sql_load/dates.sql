SELECT 
    Count(job_id) job_count,
        EXTRACT(Month From job_posted_date) as Month
From 
    job_postings_fact
where EXTRACT(Month From job_posted_date) = 6
GROUP BY
    Month 
Order by  Month
LIMIT 100     

--Practice Problem 6
Create table january_job as 
    SELECT * 
    From job_postings_fact
    where EXTRACT(Month From job_posted_date) = 1;
Create table february_job as 
    SELECT * 
    From job_postings_fact
    where EXTRACT(Month From job_posted_date) = 2;
Create table march_job as 
    SELECT * 
    From job_postings_fact
    where EXTRACT(Month From job_posted_date) = 3;
/*
--Case  Statements
-- Label new column as follows
'Anywhere' jobs as Remote
'New York, NY' jobs as Local
Otherwise 'Onsite'

*/

SELECT
    Count(job_id) as no_of_jobs,
    
Case    
        When job_location = 'Anywhere' Then 'Remote'
        When job_location = 'New York, NY' Then 'Local'
        Else 'Onsite'
    END As location_category
From job_postings_fact
where
    job_title_short = 'Data Analyst'
GROUP BY
    location_category

--Practice Problem of Case
SELECT
    Count(job_id) as no_of_jobs,
Case 
    When salary_year_avg < 50000 Then 'Low Salary'
    When salary_year_avg Between 50000 AND 100000 Then 'Standard'
    When salary_year_avg >100000 Then 'High Salary'
    Else 'NA'
END As salary_group
From
    job_postings_fact
Where 
    job_title_short = 'Data Analyst'
GROUP BY
    salary_group
LIMIT 200

/*Subqueries 


*/
SELECT *
From (
    SELECT *
    From job_postings_fact
    Where EXTRACT(Month From job_posted_date)=1
) As january_job

/*
Get a List of companies that are offering jobs that dont have any requirement for degree
*/
-- By Subquries
Select 
    company_id,
    name as company_name 
From company_dim
Where company_id IN (
    Select 
    company_id
From
    job_postings_fact
Where 
    job_no_degree_mention = true
ORDER BY
    company_id
)

--By using Joins

SELECT DISTINCT(c.name) AS company_name, j.company_id 
FROM job_postings_fact AS j 
LEFT JOIN company_dim AS c ON j.company_id = c.company_id
WHERE job_no_degree_mention = true
ORDER BY company_id;

/*
Prac Problem Subqueries
*/


Select
    sk.skills,
    sj.skill_id,
    Count(sj.*)
From 
    (
    Select
        skill_id,
        count(*)
        
    From    
        skills_job_dim
    GROUP BY
        skill_id
    Order BY
        Count(*) DESC
    Limit 5
    ) As sj
Join skills_dim as sk on 
sj.skill_id = sk.skill_id
GROUP BY
    skills, sj.skill_id

Select 
    sk.skills,
    sc.skill_id
From (
    Select
        skill_id, Count(*)
    From 
        skills_job_dim
    GROUP BY
        skill_id
    order BY Count(*) DESC
    LIMIT 5
    ) As sc
Join skills_dim sk On
sc.skill_id = sk.skill_id


Select
    c.company_id,
    Count(*) As total_jobs,
    CASE 
        WHEN COUNT(*) < 10 THEN 'Small'
        WHEN COUNT(*) BETWEEN 10 AND 50 THEN 'Medium'
        WHEN COUNT(*) > 50 THEN 'Big'
        ELSE 'No Job'
    END AS company_size
From
    (
    Select
        Count(*),
        company_id
    From
        job_postings_fact
    GROUP BY
        company_id
    )As t 
join job_postings_fact as c On
t.company_id = c.company_id
GROUP BY
c.company_id
--Order BY Count(*) DESC


/* 
CTE Starts here
*/

With january_jobs As(
    Select *
    From job_postings_fact
    where EXTRACT(Month From job_posted_date)=1
)
Select *
From job_postings_fact

/*
Find the companies with most job openings
1. Get the total number of job posting per company id
2. return the total number of jobs with the company name
*/

With company_job_count AS (
    Select Count(*) as total_jobs, company_id
    From job_postings_fact
    GROUP BY
        company_id
 )
 SELECT c.name, j.total_jobs
 From company_dim as c
 Right Join company_job_count as j On
 c.company_id = j.company_id



With company_job_count As (
    Select
    Count(*) As total_jobs, company_id
From 
    job_postings_fact 
GROUP BY
    company_id
)                                          
Select c.name, j.total_jobs
From company_dim c
Left Join company_job_count j On
j.company_id = c.company_id
--Where j.job_title_short IN ('Data Analyst', 'Business Analyst')
Order BY j.total_jobs Desc

/* Practice Problem 7
Find the count of the number of remote job postings per skill
    -Dsiplay the top 5 skill by their demand in remote jobs
    -Include skill_id, name and count of job posting requiring the skill
*/

With remote_job_skills As
    (Select
        skill_id,
        Count(*) As skill_count
    From skills_job_dim as sj
    Join job_postings_fact j On
    sj.job_id = j.job_id
    Where 
        j.Job_work_from_home = True AND
        j.job_title_short = 'Data Analyst'
    GROUP BY
        sj.skill_id)
Select 
    sk.skills,
    r.skill_id,
    r.skill_count
From remote_job_skills as r
join skills_dim as sk On
r.skill_id = sk.skill_id
ORDER BY skill_count DESC
Limit 5




--Get jobs from january
Select
    job_title_short,
    company_id,
    job_location
From    
    january_job

UNION All

Select
    job_title_short,
    company_id,
    job_location
From    
    february_job

UNION All

Select
    job_title_short,
    company_id,
    job_location
From    
    march_job

/*
Practice Problem 8 Union
Find job postings from the first quarter that have a salary greater than 70k
    -Combine job postings tables from the first quarter of2023 (jan-mar)
    -Gets job posting with an average yearly salary>70k

*/
Select
    q1.job_title_short,
    q1.job_location,
    q1.job_via,
    q1.salary_year_avg,
    q1.job_posted_date::date
From
    (Select * 
    From january_job
    Union All
    Select * 
    From february_job
    Union All
    Select * 
    From march_job) As q1
Where 
    q1.salary_year_avg > 70000 AND
    q1.job_title_short = 'Data Analyst'
Order By q1.salary_year_avg DESC

/* Get the corresponding skill and skill type for each job posting in quarter 1
   Include those without any skills too
   why?Look at the skils and the type for each job in the first query that has a salay > 70k
*/
Select 
    sk.skills,
    COUNT(sk.skill_id),
    sk.type
From
    (Select jan.job_id, sj.skill_id, jan.salary_year_avg
    From january_job as jan 
    Join skills_job_dim sj on 
    jan.job_id = sj.job_id
    Union All
    Select feb.job_id, sj.skill_id,  feb.salary_year_avg
    From february_job as feb 
    Right Join skills_job_dim sj on 
    feb.job_id = sj.job_id
    Union All
    Select mar.job_id, sj.skill_id,  mar.salary_year_avg
    From march_job as mar
    Right Join skills_job_dim sj on 
    mar.job_id = sj.job_id
    ) As q1
Join skills_dim sk On
q1.skill_id = sk.skill_id
WHere q1.salary_year_avg > 70000
GROUP BY
    sk.skills,
    sk.type


