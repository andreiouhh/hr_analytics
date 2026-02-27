--Scenario 1 – Workforce performance segmentation

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

SELECT * FROM training_and_development
SELECT * FROM employee_data
SELECT * FROM recruitment_data
SELECT * FROM employee_engagement_survey_data

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
	ORDER BY total_hired DESC;
