CREATE TABLE employee_data (
    emp_id INTEGER,
    first_name TEXT,
    last_name TEXT,
    start_date DATE,
    exit_date DATE,
    title TEXT,
    supervisor TEXT,
    ad_email TEXT,
    business_unit TEXT,
    employee_status TEXT,
    employee_type TEXT,
    pay_zone TEXT,
    employee_classification_type TEXT,
    termination_type TEXT,
    termination_description TEXT,
    department_type TEXT,
    division TEXT,
    dob DATE,
    state TEXT,
    job_function_description TEXT,
    gender_code TEXT,
    location_code TEXT,
    race_desc TEXT,
    marital_desc TEXT,
    performance_score TEXT,
    current_employee_rating INTEGER
);

CREATE TABLE employee_engagement_survey_data (
    employee_id INTEGER,
    survey_date DATE,
    engagement_score INTEGER,
    satisfaction_score INTEGER,
    work_life_balance_score INTEGER
);


CREATE TABLE recruitment_data (
    applicant_id INTEGER,
    application_date DATE,
    first_name TEXT,
    last_name TEXT,
    gender TEXT,
    date_of_birth DATE,
    phone_number TEXT,
    email TEXT,
    address TEXT,
    city TEXT,
    state TEXT,
    zip_code TEXT,
    country TEXT,
    education_level TEXT,
    years_of_experience INTEGER,
    desired_salary NUMERIC,
    job_title TEXT,
    status TEXT
);

CREATE TABLE training_and_development (
    employee_id INT,
    training_date DATE,
    training_program_name VARCHAR(100),
    training_type VARCHAR(50),
    training_outcome VARCHAR(50),
    location VARCHAR(100),
    trainer VARCHAR(100),
    training_duration_days INT,
    training_cost DECIMAL(10, 2)
);
