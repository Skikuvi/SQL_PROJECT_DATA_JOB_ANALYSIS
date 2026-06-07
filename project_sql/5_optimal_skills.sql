/*
Questins: What are the most optimal skills to learn i.e it's in high demand and high-paying
-identify skills in high demand and associated with high average salaries for Data Analyst role
-Focus on remote positions with specified salaries
-Why? Targets skills that offer job security(high demand) and financial benefits(high salaries),
-Offer strategic insight for career development in data analysis
*/

--CTE
WITH skills_demand AS(
    SELECT
            skills_dim.skills,
            COUNT(*) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL AND
        job_work_from_home = True

    GROUP BY skills
), average_salary AS(
    SELECT
            
            skills_dim.skills,
            ROUND(AVG(salary_year_avg), 0) AS avg_salary
    FROM      
                job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE      
            job_title_short = 'Data Analyst' AND
            salary_year_avg IS NOT NULL AND
            job_work_from_home = True
    GROUP BY 
            skills
)
SELECT
        skills_demand.skills,
        skills_demand.demand_count,
        average_salary.avg_salary
FROM    skills_demand
INNER JOIN average_salary ON skills_demand.skills = average_salary.skills
WHERE demand_count > 10

ORDER BY avg_salary DESC,
         demand_count DESC
         
LIMIT 20;

--rewriting the code

SELECT
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS skills_demand,
        ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary

FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

WHERE salary_year_avg IS NOT NULL
      AND job_work_from_home = TRUE
      AND job_title_short = 'Data Analyst'
GROUP BY skills_dim.skill_id
HAVING COUNT(skills_job_dim.job_id) > 10
ORDER BY avg_salary DESC,
         skills_demand DESC  
LIMIT 20;

