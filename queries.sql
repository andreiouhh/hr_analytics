
SELECT * FROM training_and_development
SELECT * FROM employee_data
SELECT * FROM recruitment_data
SELECT * FROM employee_engagement_survey_data

Select DISTINCT employee_status FROM employee_data

-- Dataset overview
-- headcount of active and inactive employees
SELECT 
	COUNT (DISTINCT emp_id) AS total_employees,
	COUNT (DISTINCT CASE WHEN employee_status = 'Active' THEN emp_id END) AS active_employees,
	COUNT (DISTINCT CASE WHEN employee_status = 'Terminated for Cause' OR employee_status = 'Voluntarily Terminated' OR employee_status = 'Future Start' OR employee_status = 'Leave of Absence' THEN emp_id END) AS inactive_employees
	FROM employee_data

-- distribution of inactive employee status among the workforce
SELECT 
	employee_status,
	COUNT (DISTINCT emp_id) AS total_employees
	FROM employee_data
	WHERE employee_status != 'Active'
	GROUP BY employee_status
	ORDER BY total_employees DESC

-- Diversity & Inclusion: Breakdown of the workforce by GenderCode, RaceDesc, and Age
SELECT 
    gender_code,
    race_desc,
    CASE 
        WHEN EXTRACT(YEAR FROM AGE(NOW(), dob)) < 30 THEN 'Under 30'
        WHEN EXTRACT(YEAR FROM AGE(NOW(), dob)) BETWEEN 30 AND 50 THEN '30-50'
        ELSE 'Over 50'    END AS age_group,
    -- THIS IS YOUR SORT COLUMN
    CASE 
        WHEN EXTRACT(YEAR FROM AGE(NOW(), dob)) < 30 THEN 1
        WHEN EXTRACT(YEAR FROM AGE(NOW(), dob)) BETWEEN 30 AND 50 THEN 2
        ELSE 3
    END AS age_group_sort,	
    COUNT(DISTINCT emp_id) AS total_employees
FROM employee_data
WHERE employee_status = 'Active'
GROUP BY gender_code, race_desc, age_group, age_group_sort
ORDER BY age_group_sort;

-- Diversity by Department: shows gender balance within each department
SELECT
    department_type,
    COUNT(DISTINCT emp_id) AS total_employees,
    COUNT(DISTINCT CASE WHEN gender_code IN ('Male', 'M') THEN emp_id END) AS male_employees,
    COUNT(DISTINCT CASE WHEN gender_code IN ('Female', 'F') THEN emp_id END) AS female_employees,
    COUNT(DISTINCT CASE WHEN gender_code NOT IN ('Male', 'M', 'Female', 'F') OR gender_code IS NULL THEN emp_id END) AS other_or_unspecified,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN gender_code IN ('Male', 'M') THEN emp_id END) / COUNT(DISTINCT emp_id), 1) AS pct_male,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN gender_code IN ('Female', 'F') THEN emp_id END) / COUNT(DISTINCT emp_id), 1) AS pct_female,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN gender_code NOT IN ('Male', 'M', 'Female', 'F') OR gender_code IS NULL THEN emp_id END) / COUNT(DISTINCT emp_id), 1) AS pct_other_or_unspecified,
    CASE
        WHEN COUNT(DISTINCT CASE WHEN gender_code IN ('Male', 'M') THEN emp_id END) = COUNT(DISTINCT emp_id) THEN 'All Male'
        WHEN COUNT(DISTINCT CASE WHEN gender_code IN ('Female', 'F') THEN emp_id END) = COUNT(DISTINCT emp_id) THEN 'All Female'
        WHEN COUNT(DISTINCT CASE WHEN gender_code NOT IN ('Male', 'M', 'Female', 'F') OR gender_code IS NULL THEN emp_id END) = COUNT(DISTINCT emp_id) THEN 'All Other/Unknown'
        ELSE 'Mixed'
    END AS gender_balance
FROM employee_data
WHERE employee_status = 'Active'
GROUP BY department_type
ORDER BY total_employees DESC, department_type;

-- Marital Status Breakdown: standard HR metric for benefits and engagement
SELECT
    marital_desc,
    COUNT(DISTINCT emp_id) AS total_employees,
    ROUND(100.0 * COUNT(DISTINCT emp_id) / SUM(COUNT(DISTINCT emp_id)) OVER (), 1) AS pct_employees
FROM employee_data
WHERE employee_status = 'Active'
GROUP BY marital_desc
ORDER BY total_employees DESC;

-- Pay Zone vs Diversity: identify groups concentrated in lower or higher pay zones
SELECT
    pay_zone,
    gender_code,
    race_desc,
    COUNT(DISTINCT emp_id) AS employees,
    ROUND(100.0 * COUNT(DISTINCT emp_id) / SUM(COUNT(DISTINCT emp_id)) OVER (PARTITION BY pay_zone), 1) AS pct_within_pay_zone,
    ROUND(100.0 * COUNT(DISTINCT emp_id) / SUM(COUNT(DISTINCT emp_id)) OVER (), 1) AS pct_of_total_employees
FROM employee_data
WHERE employee_status = 'Active'
GROUP BY pay_zone, gender_code, race_desc
ORDER BY pay_zone, pct_within_pay_zone DESC, employees DESC;

-- Recent Hires: employees hired in the last 12 months with granular detail
SELECT
    emp_id,
    CONCAT(first_name, ' ', last_name) AS employee_name,
    start_date,
    EXTRACT(DAY FROM NOW() - start_date) AS days_employed,
    title,
    department_type,
    business_unit,
    gender_code,
    race_desc,
    pay_zone,
    current_employee_rating,
    employee_type
FROM employee_data
WHERE employee_status = 'Active' 
  AND start_date >= NOW() - INTERVAL '1 year'
ORDER BY start_date DESC;

-- Active Employees: granular workforce detail for analysis
SELECT
    emp_id,
    CONCAT(first_name, ' ', last_name) AS employee_name,
    start_date,
    EXTRACT(YEAR FROM AGE(NOW(), dob)) AS age,
    title,
    department_type,
    business_unit,
    gender_code,
    pay_zone,
    current_employee_rating,
    employee_type,
    state
FROM employee_data
WHERE employee_status = 'Active'
ORDER BY department_type, pay_zone, current_employee_rating DESC;

-- Scenario 1 – Workforce performance segmentation

SELECT 
	CONCAT (first_name, '', last_name) AS EmployeeName,
	CASE current_employee_rating 
		WHEN 5 THEN 'Elite'
		WHEN 4 THEN 'High Performer'
		WHEN 3 THEN 'Standard'
		ELSE 'At Risk'
	END AS Perfomance_Tier,
	CASE 
		WHEN start_date < '2021-01-01' THEN 'Legacy'
		ELSE 'New Era'
	END AS Hiring_Cohort
	FROM employee_data
	WHERE employee_status = 'Active'
	ORDER BY current_employee_rating DESC

--Scenario 2 – Department effectiveness and employee experience

SELECT 
	e.department_type,
	COUNT (*) as employee_count,
	AVG (e."current_employee_rating") as avg_performance,
	AVG (s."engagement_score") as avg_engagement,
	AVG (s."work_life_balance_score") as avg_worklife_balance
	FROM employee_data e
	INNER JOIN employee_engagement_survey_data s ON e.emp_id = s.employee_id
	WHERE e.employee_status = 'Active'
	GROUP BY e.department_type
	ORDER BY avg_engagement


--Scenario 3 – Training effectiveness across programs

SELECT
	e.training_program_name,
	COUNT (DISTINCT d.emp_id) AS total_participants,
	AVG (d.current_employee_rating) AS avg_performance,
	AVG (s.engagement_score) AS avg_engagement
	FROM training_and_development e 
	INNER JOIN employee_data d ON e.employee_id = d.emp_id
	INNER JOIN employee_engagement_survey_data s ON d.emp_id = s.employee_id
	WHERE d.employee_status = 'Active' AND e.training_outcome = 'Completed'
	GROUP BY e.training_program_name
	ORDER BY avg_performance DESC

--Scenario 4 – Role demand distribution

SELECT
	COUNT (DISTINCT applicant_id) AS total_applicants,
	job_title
	FROM recruitment_data
	GROUP BY job_title
	ORDER BY total_applicants DESC

--Scenario 5 – Hiring outcome distribution by role

SELECT
    job_title,
    COUNT(DISTINCT applicant_id) AS total_applicants,
    COUNT(DISTINCT CASE WHEN status = 'Hired' THEN applicant_id END) AS total_hired,
    COUNT(DISTINCT CASE WHEN status = 'Offered' THEN applicant_id END) AS total_offered,
    COUNT(DISTINCT CASE WHEN status = 'In Review' THEN applicant_id END) AS in_review,
    COUNT(DISTINCT CASE WHEN status = 'Interviewing' THEN applicant_id END) AS under_interview,
    COUNT(DISTINCT CASE WHEN status = 'Rejected' THEN applicant_id END) AS total_rejected
	FROM recruitment_data
	GROUP BY job_title
	ORDER BY total_applicants DESC
	FETCH FIRST 5 ROWS ONLY;

-- Hiring Status 
SELECT
	status,
	COUNT(DISTINCT applicant_id) AS total_applicants
	FROM recruitment_data
	GROUP BY status
	ORDER BY total_applicants DESC;


-- Scenario 6 – Department Retention Risk
SELECT
	department_type,
	COUNT (DISTINCT emp_id) AS total_employees,
	COUNT (DISTINCT CASE WHEN employee_status = 'At Risk' THEN emp_id END) AS at_risk_employees
	FROM employee_data
	WHERE employee_status IN ('Active', 'At Risk')
	GROUP BY department_type
	ORDER BY at_risk_employees DESC;
	

-- Scenario 7 – Training strategy optimization
SELECT
	training_program_name,
	COUNT (DISTINCT emp_id) AS total_participants,
	AVG (current_employee_rating) AS avg_performance,
	AVG (engagement_score) AS avg_engagement
	FROM training_and_development t
	INNER JOIN employee_data e ON t.employee_id = e.emp_id
	INNER JOIN employee_engagement_survey_data s ON e.emp_id = s.employee_id
	WHERE e.employee_status = 'Active' AND t.training_outcome = 'Completed'
	GROUP BY training_program_name
	ORDER BY avg_performance DESC;


-- Scenario 3 and 7 
SELECT 
    t.training_program_name,
	AVG(s.engagement_score) AS avg_engagement,
    AVG(e.current_employee_rating) AS avg_rating,
    COUNT(e.emp_id) AS cohort_size
FROM employee_data e
LEFT JOIN training_and_development t ON e.emp_id = t.employee_id
LEFT JOIN employee_engagement_survey_data s ON e.emp_id = s.employee_id
GROUP BY t.training_program_name;



