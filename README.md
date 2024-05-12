# Introduction
📊 Dive into the data job market! Focusing on data analyst roles, this project explores 💰 top-paying jobs, 🔥 in-demand skills, and 📈 where high demand meets high salary in data analytics.

🔍 SQL queries? Check them out here:[Project_Queries](/Project_Queries/) 
# Background
Driven by a quest to navigate the data analyst job market more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining other's work to find optimal jobs.

The questions I wanted to answer through my SQL queries were:
What are the top-paying data analyst jobs?
What skills are required for these top-paying jobs?
What skills are most in demand for data analysts?
Which skills are associated with higher salaries?
What are the most optimal skills to learn?
# Tools I Used
For my deep dive into the data analyst job market, I harnessed the power of several key tools:

- **SQL**: The backbone of my analysis, allowing me to query the database and unearth critical insights.
- **PostgreSQL**: The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code**: My go-to for database management and executing SQL queries.
- **Git & GitHub**: Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here’s how I approached each question:

### 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high-paying opportunities in the field.
```  SQL 
SELECT
    job_id,
    job_location,
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

```
Here's the breakdown of the top data analyst jobs in 2023:

- **Wide Salary Range**: Top 10 paying data analyst roles span from $184,000 to $650,000, indicating significant salary potential in the field.
- **Diverse Employers**: Companies like SmartAsset, Meta, and AT&T are among those offering high salaries, showing a broad interest across different industries.
- **Job Title Variety**: There's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics.

## 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

```
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
```

Here's the breakdown of the most demanded skills for the top 10 highest-paying data analyst jobs in 2023:

- **SQL** is leading with a bold count of 8.
- **Python** follows closely with a bold count of 7.
- **Tableau** is also highly sought after, with a bold count of 6. Other skills like R, Snowflake, Pandas, and Excel show varying degrees of demand.

### 3. In-Demand Skills for Data Analysts
This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```
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
```
Here's the breakdown of the most demanded skills for data analysts in 2023

- **SQL** and **Excel** remain fundamental, emphasizing the need for strong foundational skills in data processing and spreadsheet manipulation.
- **Programming** and **Visualization** Tools like Python, Tableau, and Power BI are essential, pointing towards the increasing importance of technical skills in data storytelling and decision support.

### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```
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

```
Here's a breakdown of the results for top paying skills for Data Analysts:

- **High Demand for Big Data & ML Skills**: Top salaries are commanded by analysts skilled in big data technologies (PySpark, Couchbase), machine learning tools (DataRobot, Jupyter), and Python libraries (Pandas, NumPy), reflecting the industry's high valuation of data processing and predictive modeling capabilities.
- **Software Development & Deployment Proficiency**: Knowledge in development and deployment tools (GitLab, Kubernetes, Airflow) indicates a lucrative crossover between data analysis and engineering, with a premium on skills that facilitate automation and efficient data pipeline management.
- **Cloud Computing Expertise**: Familiarity with cloud and data engineering tools (Elasticsearch, Databricks, GCP) underscores the growing importance of cloud-based analytics environments, suggesting that cloud proficiency significantly boosts earning potential in data analytics.

### 5. Most Optimal Skills to Learn
Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```
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
```

Here's a breakdown of the most optimal skills for Data Analysts in 2023:

- **High-Demand Programming Languages**: Python and R stand out for their high demand, with demand counts of 236 and 148 respectively. Despite their high demand, their average salaries are around $101,397 for Python and $100,499 for R, indicating that proficiency in these languages is highly valued but also widely available.
- **Cloud Tools and Technologies**: Skills in specialized technologies such as Snowflake, Azure, AWS, and BigQuery show significant demand with relatively high average salaries, pointing towards the growing importance of cloud platforms and big data technologies in data analysis.
- **Business Intelligence and Visualization Tools**: Tableau and Looker, with demand counts of 230 and 49 respectively, and average salaries around $99,288 and $103,795, highlight the critical role of data visualization and business intelligence in deriving actionable insights from data.
- **Database Technologies**: The demand for skills in traditional and NoSQL databases (Oracle, SQL Server, NoSQL) with average salaries ranging from $97,786 to $104,534, reflects the enduring need for data storage, retrieval, and management expertise.


# What I learned
Throughout this adventure, I've turbocharged my SQL toolkit with some serious firepower:

🧩 Complex Query Crafting: Mastered the art of advanced SQL, merging tables like a pro and wielding WITH clauses for ninja-level temp table maneuvers.
📊 Data Aggregation: Got cozy with GROUP BY and turned aggregate functions like COUNT() and AVG() into my data-summarizing sidekicks.
💡 Analytical Wizardry: Leveled up my real-world puzzle-solving skills, turning questions into actionable, insightful SQL queries.

# Conclusions

Insights
From the analysis, several general insights emerged:

- **Top-Paying Data Analyst Jobs**: The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at $650,000!
- **Skills for Top-Paying Jobs**: High-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary.
- **Most In-Demand Skills**: SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
- **Skills with Higher Salaries**: Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise.
- **Optimal Skills for Job Market Value**: SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.

# Closing Thoughts
This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.
