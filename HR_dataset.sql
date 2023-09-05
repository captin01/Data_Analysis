/*Changing first column to emp_id */
ALTER TABLE HR CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;

/*Modifying birthdate column */
SET sql_safe_updates = 0;
UPDATE HR 
SET birthdate = CASE 
	WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
	WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
	ELSE NULL
END;

/*Confirming changes*/
SELECT * FROM HR;

/*Changing data type of birthdate column*/
ALTER TABLE HR 
MODIFY COLUMN birthdate DATE; 

/*Confirming change of data type*/
DESCRIBE HR; 

/*Modifying hire_date column*/
UPDATE HR 
SET hire_date = CASE 
	WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
	WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
	ELSE NULL
END;

/*Changing hire_date into DATE type*/
ALTER TABLE HR
MODIFY COLUMN hire_date DATE;

/* Removing the timestamp form the termdate */ 
UPDATE HR
SET termdate = date(str_to_date(termdate, '%Y-%m-%d%H:%i:%s UTC'))
WHERE termdate IS NOT NULL AND termdate != ' ';

/*Changing termdate into DATE type*/
ALTER TABLE HR
MODIFY COLUMN termdate DATE;

/*Adding new column 'age' */
ALTER TABLE HR ADD COLUMN age INT;

/*Filling the age column with respective values*/ 
UPDATE HR
SET age = timestampdiff(YEAR,birthdate,CURDATE());

/*Confirming changes*/
SELECT birthdate , age 
FROM  HR;

/*Finding the youngest and oldest age */
SELECT 
	min(age) AS youngest,
    max(age) AS oldest
FROM HR;

/* checking number of employees below 18yrs */
SELECT count(*) FROM HR WHERE age < 18;

-- QUESTIONS 

-- 1.What is the gender breakdown of employees in the company?

SELECT gender,count(*) AS count
FROM HR 
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY gender;

-- 2.What is the race/ethnicity breakdown of employees in the company?

SELECT race,count(*) AS count
FROM HR 
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY race
ORDER BY count DESC;

-- 3.What is the age distribution of employees in the company?

SELECT
	CASE
    WHEN age >= 18 AND age<= 24 THEN '18-24'
    WHEN age >= 25 AND age<= 34 THEN '25-34'
    WHEN age >= 35 AND age<= 44 THEN '35-44'
    WHEN age >= 45 AND age<= 54 THEN '45-54'
    WHEN age >= 55 AND age<= 64 THEN '55-64'
    ELSE '65+'
    END AS age_group,
    count(*) AS count
FROM HR
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY age_group
ORDER BY age_group;

-- 3b.Gender distribution in age_group. 

SELECT
	CASE
    WHEN age >= 18 AND age<= 24 THEN '18-24'
    WHEN age >= 25 AND age<= 34 THEN '25-34'
    WHEN age >= 35 AND age<= 44 THEN '35-44'
    WHEN age >= 45 AND age<= 54 THEN '45-54'
    WHEN age >= 55 AND age<= 64 THEN '55-64'
    ELSE '65+'
    END AS age_group,
    gender,
    count(*) AS count
FROM HR
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- 4.How many employees work at the headquaters vs remote locations?

SELECT location, count(*) AS count
FROM HR 
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY  location;

-- 5.Average length of employment for employees who have been terminated?

SELECT 
round(AVG(datediff(termdate, hire_date))/365, 0) AS Avg_length
FROM HR
WHERE termdate <= curdate() AND termdate <> '0000-00-00' AND age >= 18;

-- 6.How does the gender distribution vary across departments and job titles? 

SELECT department, gender,count(*) AS count
FROM HR
WHERE age>= 18 AND termdate = '0000-00-00'
GROUP BY department, gender
ORDER BY department;

-- 7.What is the distribution of jobs titles across the company? 

SELECT jobtitle, count(*) AS count
FROM HR 
WHERE age>= 18 AND termdate = '0000-00-00'
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- 8.Which department has the highest turnover rate?

SELECT department , total_count, terminated_count, terminated_count/total_count AS termination_rate
FROM (
	SELECT department,
    count(*) AS total_count,
	sum(CASE WHEN termdate <> '0000-00-00' AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminated_count
    FROM HR
    WHERE age >+ 18
    GROUP BY department 
    )AS subquery
ORDER BY termination_rate DESC;

-- 9.What is the distribution of employees across location by city and state? 

SELECT location_state, count(*) AS count
FROM  HR
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY location_state
ORDER BY count DESC;

-- 10.How has the company's employee count changes over time based on hire and term dates?

SELECT 
	year, 
    hires,
    terminations,
    hires - terminations AS net_change,
    round((hires - terminations)/hires * 100) AS net_change_percent
FROM(
	SELECT 
		year(hire_date) AS year,
        count(*) AS hires,
        sum(CASE WHEN termdate <> '0000-00-00' AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminations
        FROM HR
        WHERE age>= 18 
        GROUP BY year(hire_date)
	) AS subquery
ORDER BY year ASC;

-- 11.What is the tenure distribution for each department?

SELECT 
	department, 
    round(avg(datediff(termdate, hire_date)/365),0)AS avg_tenure
FROM HR
WHERE termdate <= curdate() AND termdate <> '0000-00-00' AND age >= 18
GROUP BY department;
