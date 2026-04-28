HR Strategic Insights Dashboard
A Data-Driven Approach to Workforce Management and Training ROI

Project Background
This is a personal project developed during my Information Technology internship to demonstrate the application of data analytics in a Human Resources context. Utilizing an HR dataset from Kaggle, I built an end-to-end analytical system to address organizational challenges including turnover, pay equity, and the effectiveness of training programs.
Technical Stack
Database Management: PostgreSQL was used for data storage, cleaning, and creating a relational structure.

Data Visualization: Microsoft Power BI was employed to design the interactive dashboard and user interface.

Business Logic: Custom DAX measures were developed to calculate key metrics such as turnover, tenure, and training investment.

Dashboard Structure
Page 1: Workforce Overview and Retention
This page focuses on the operational "pulse" of the company and current headcount stability.

Operational KPIs: Monitors total headcount (3,000), active employees (2,458), and inactive employees (542).

Stability Metrics: Tracks a company-wide Turnover Rate of 18.07% and an Average Tenure of 3.33 years.

Workforce Composition: Visualizes gender balance across departments and provides a breakdown of employment status and marital status distributions.

Performance Distribution: Segments employees by performance tiers, ranging from "Standard" to "Elite".

Page 2: Growth, Equity and Training ROI
This page focuses on the long-term development of talent and the financial fairness of the organization.

Investment Metrics: Displays a Total Training Spend of $1.68M alongside an Average Engagement score of 2.94.

Pay Equity Analysis: Examines pay distribution by gender across multiple pay zones (A, B, and C) to identify potential compensation gaps.

Hiring Cohorts: Compares performance tiers between "Legacy" and "New Era" hiring periods to analyze talent longevity.

Program Effectiveness: Correlates training program participation with performance ratings and engagement outcomes through scatter plot and bar chart analysis.

Core Analytical Objectives
Retention Analysis: Identifying organizational turnover trends to inform stability strategies.

Compensation Fairness: Ensuring equitable pay distribution across different demographics and business units.

Training ROI: Measuring the relationship between financial investment in learning and actual employee performance outcomes.

Experience Benchmarking: Comparing departmental effectiveness by plotting performance against well-being and engagement scores.

Files in this Repository
hr_dashboard.pbix: The source Power BI file containing all data models, visuals, and DAX measures.

schema.sql: The SQL script defining the database structure, tables, and relational constraints.

queries.sql: The PostgreSQL scripts used for data cleaning, transformation, and investigation.

hr_dashboard.pdf: A static PDF export of the two-page dashboard for quick reference.