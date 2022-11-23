-- missed group by and SELECT 

SELECT country,
    count(*) AS missing_first_name
FROM employees
WHERE first_name IS NULL
GROUP BY country;

SELECT 
    count(*),
    count(id),
    count(first_name)
FROM employees;

/*
HAVING

GROUP-wise filtering. FILTER FOR AFTER you've grouped

SHOW those departments IN which AT LEAST 40 employees WORK either
 0.25 OR 0.5 FTE hours
*/

SELECT count(*), department 
FROM employees 
WHERE fte_hours BETWEEN 0.25 AND 0.5
GROUP BY department
HAVING count(*) >= 40; -- FILTER GROUPS USING HAVING 

-- sidenote: column aliases/ created columns won't be
-- accessible in F, W, G, or H
SELECT count(*) AS n_employees, department 
FROM employees 
WHERE fte_hours BETWEEN 0.25 AND 0.5
GROUP BY department
HAVING n_employees >= 40; -- can't THEN use our DEFINED COLUMN
-- it's because SQL runs relect after from where, group by and HAVING
-- need to put in the calculation count(*)


/*
 * Show any countries in which the minimum salary amongst pension
 * enrolled employees in less than 21k (dollars)
 * 
 */

SELECT DISTINCT(country)
FROM employees
WHERE pension_enrol IS TRUE AND salary <21000;

-- or do this:

SELECT country, min(salary)
FROM employees
WHERE pension_enrol IS TRUE
GROUP BY country
HAVING min(salary) < 21000;


/*
 * show any departments in which the earliest start date amongst
 * grade 1 employees is prior to 1991
 */

-- without having
SELECT department, count(*)
FROM employees
WHERE extract(YEAR FROM start_date) < 1991 AND grade = 1
GROUP BY department;

-- with having
SELECT department, min(start_date) -- COLUMNS we want AT the end
FROM employees                   -- which table
WHERE grade = 1                     -- FILTER rows
GROUP BY department              -- put DATA INTO buckets
HAVING min(start_date) < '1991-01-01'; -- FILTER buckets

/*
 * Subqueries
 * 
 * Sometimes we will want to use a calculated value as part of our
 * query
 * 
 * can plug queries into other queries, as can't assign them to
 * values to use later
 * 
 */
/*
 * Find all the employees in Japan who earn over the company-wide
 * average salary
 * 
 * 1. calculate the average salary
 * 2. insert calculation into our query
 */

-- a first attempt:
SELECT *
FROM employees
WHERE country= 'Japan' AND salary > avg(salary);
-- aggregate functions not allowed in where = error

-- 1. get average salary:
-- in R we could do <- avg(salary) but not here
SELECT avg(salary)
FROM employees;

-- 2. plugs in calculation
-- take above query and stick it IN 
SELECT first_name, last_name, salary
FROM employees
WHERE country = 'Japan' AND salary > ( -- need these brackets
    SELECT avg(salary) -- needs to be one value
    FROM employees);

/* 
 * Task
 * Find all the employees in Legal who earn less than the mean salary
 * in that same department
 */
SELECT avg(salary)
FROM employees
WHERE department = 'Legal'; -- mean is 56.5k;

SELECT first_name, last_name, salary
FROM employees
WHERE department = 'Legal' AND salary < (
    SELECT avg(salary)
    FROM employees
    WHERE department = 'Legal'
    );


