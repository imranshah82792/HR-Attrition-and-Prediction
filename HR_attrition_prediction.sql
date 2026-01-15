CREATE DATABASE HR_Attrition_Prediction;
USE HR_Attrition_Prediction;

SELECT * FROM hr_employee_attrition;

-- Question:1 What is the total number of employees and how many left the company?
SELECT 
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left
FROM hr_employee_attrition;

-- Question:2What is the overall attrition rate?
SELECT 
    ROUND(
        100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS attrition_rate_percent
FROM hr_employee_attrition;

-- Question:3 How many employees are there in each department?
SELECT 
    Department,
    COUNT(*) AS employees_count
FROM hr_employee_attrition
GROUP BY Department
ORDER BY employees_count DESC;

-- Question:5 What is the attrition rate in each department?
SELECT 
    Department,
    COUNT(*) AS total_emp,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_emp,
    ROUND(
        100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS attrition_rate_percent
FROM hr_employee_attrition
GROUP BY Department
ORDER BY attrition_rate_percent DESC;

-- Question:6 Compare average monthly income of employees who left vs stayed.
SELECT 
    Attrition,
    ROUND(AVG(MonthlyIncome), 2) AS avg_monthly_income
FROM hr_employee_attrition
GROUP BY Attrition;

-- Question:7 For each job role, what is the average distance from home for employees who left?
SELECT 
    JobRole,
    ROUND(AVG(DistanceFromHome), 2) AS avg_distance_left
FROM hr_employee_attrition
WHERE Attrition = 'Yes'
GROUP BY JobRole
ORDER BY avg_distance_left DESC;

-- Question:8 How many employees leave for each combination of OverTime and WorkLifeBalance?
SELECT 
    OverTime,
    WorkLifeBalance,
    COUNT(*) AS total_emp,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_emp
FROM hr_employee_attrition
GROUP BY OverTime, WorkLifeBalance
ORDER BY OverTime, WorkLifeBalance;

-- Question:9 For each department, rank employees by MonthlyIncome (highest first).
SELECT 
    EmployeeNumber,
    Department,
    MonthlyIncome,
    ROW_NUMBER() OVER (
        PARTITION BY Department
        ORDER BY MonthlyIncome DESC
    ) AS income_rank_in_dept
FROM hr_employee_attrition;

Subquery + join: Find employees whose MonthlyIncome is above the average income of their JobRole.

sql
SELECT 
    e.EmployeeNumber,
    e.JobRole,
    e.MonthlyIncome
FROM hr_employee_attrition e
JOIN (
    SELECT 
        JobRole,
        AVG(MonthlyIncome) AS avg_income_role
    FROM hr_employee_attrition
    GROUP BY JobRole
) r
    ON e.JobRole = r.JobRole
WHERE e.MonthlyIncome > r.avg_income_role
ORDER BY e.JobRole, e.MonthlyIncome DESC;