-- Learning Objectives

/* 
    - Be able to use additional comparison operators, AND and OR combinations
    - write queries using BETWEEN, NOT and IN
    - Understand and be able to use inexact comparisons with LIKE and wildcards
    - Understand IS NULL

*/

SELECT *
FROM employees; -- try to remember semi-colons
-- select all columns from employees table

SELECT *
FROM employees
WHERE id = 3; -- note single EQUALS NOT double 

SELECT *
FROM employees
WHERE fte_hours >= 0.5;

-- Find all employees not based in Brazil
SELECT *
FROM employees
WHERE country != 'Brazil'; -- single quotes needed

-- Find all employees in China who started working
-- for OmniCorp in 2019
SELECT *
FROM employees
WHERE country = 'China' AND start_date >= '2019-01-01'
AND start_date <= '2019-12-31';

-- Of all the employees based in China, find those
-- who either started working from 2019 onwards
-- or who are enrolled in the pension scheme

SELECT *
FROM employees
WHERE country  = 'China' AND (start_date >= '2019-01-01' OR pension_enrol first_name IS TRUE); 
-- AND comes before OR so we need brackets

-- Find all employees who work between 0.25
-- and 0.5 full-time equivalent hours inclusive
SELECT *
FROM employees
WHERE fte_hours BETWEEN 0.25 AND 0.5; -- BETWEEN IS handy FOR SIMPLE code

-- Start date is outside of 2017
SELECT *
FROM employees
WHERE start_date NOT BETWEEN '2017-01-01' AND '2017-12-31';

-- Find all employees who started work in 2016
-- who work 0.5 fte hours or greater
SELECT *
FROM employees
WHERE start_date BETWEEN '2016-01-01' AND '2016-12-31'
AND fte_hours >= 0.5; -- can use brackets if you want

-- Find all employees based in Spain, South Africa, Ireland or Germany
SELECT *
FROM employees
WHERE country IN ('Spain', 'South Africa', 'Ireland', 'Germany');
-- IN is a fast way so we dont have to write lots of OR conditions
-- NOT IN also handy


-- LIKE, wildcards, and regex
-- "Colleague from Greece, I think his last name began with 
-- Mc or something, can you find them?"



-- wildcards
-- %
-- _
SELECT *
FROM employees
WHERE country = 'Greece' AND last_name LIKE 'Mc%';
-- % is a wildcard, i.e. anything after 'Mc'


-- Find all employees with last names containing the phrase 'ere' anywehre
SELECT *
FROM employees
WHERE last_name LIKE '%ere%';

-- Find all employees in the legal department with a last name
-- beginning with 'D'
SELECT *
FROM employees
WHERE department = 'Legal' AND last_name LIKE 'D%'; -- is case sensitive so watch OUT

-- Write a query using LIKE and wildcards to answer
-- Find all employees having 'a' as the 2nd letter of their first names 
SELECT *
FROM employees
WHERE first_name LIKE '_a%'; -- bit like hangman

SELECT *
FROM employees
WHERE first_name iLIKE '_A%'; -- IS CASE SENSITIVE so use ILIKE

/*
 * ~ Case sensitive match
 * ~* Case insensitive match
 * !~ Case sensitive non-match
 * !~* Case insensitive non-match
 */


-- Find all employees for whom the 2nd letter of their
-- last name is 'r' or 's' and the 3rd letter IS
-- 'a' or 'o'

-- case sensitive match
SELECT *
FROM employees
WHERE last_name ~ '^.[rs][ao]' -- tilda means we're about TO use regex


-- case insensitive match
SELECT *
FROM employees
WHERE last_name ~* '^.[rs][ao]' -- tilda star means CASE INSENSITIVE

SELECT *
FROM employees
WHERE department = 'Legal' AND last_name ~* '^D';

-- case sensitive non match
SELECT *
FROM employees
WHERE last_name !~ '^.[rs][ao]';

-- case insensitive non match
SELECT *
FROM employees
WHERE last_name !~* '^.[rs][ao]';

-- IS NULL
SELECT *
FROM employees
WHERE email IS NULL;

SELECT *
FROM employees
WHERE email IS NOT NULL;


--- Can we get a list of all employees with their first and last names 
-- combined together into one field called 'full_name'?

SELECT id, first_name, last_name,
    CONCAT(first_name, ' ', last_name) AS full_name
FROM employees;

SELECT id, first_name, last_name,
    CONCAT(first_name, ' ', last_name) AS full_name
FROM employees
WHERE first_name NOTNULL AND last_name NOTNULL;

-- Our database may be out of date! After the recent restructuring,
-- we should now have 6 departments in the corporation.
-- How many departments do employees belong to at present in the db?

SELECT DISTINCT(department)
FROM employees; -- 12 departments!

-- How many employees started work for the corporation in 2001?

SELECT count(*)
FROM employees
WHERE start_date BETWEEN '2001-01-01' AND '2001-12-31';
-- 36 employees!

/*
Design queries using aggregate functions and what you have learned so far to answer the following questions:
1. “What are the maximum and minimum salaries of all employees?”
2. “What is the average salary of employees in the Human Resources department?”
3. “How much does the corporation spend on the salaries of employees hired in 2018?”
*/

SELECT MIN(salary), max(salary)
FROM employees;

SELECT avg(salary)
FROM employees
WHERE department = 'Human Resources';

SELECT sum(salary) AS total_sals_2018
FROM employees
WHERE start_date BETWEEN '2018-01-01' AND '2018-12-31';

-- Sorting by columns 

SELECT first_name, last_name, salary
FROM employees
WHERE salary NOTNULL -- filtering OUT nills
ORDER BY salary DESC
LIMIT 10; -- can LIMIT OUTPUT 

-- inlude nulls but stick them at the end or beginning
SELECT first_name, last_name, salary
FROM employees ORDER BY salary ASC NULLS LAST; -- puts NULLS last

/*
 * Task - 5 mins

Write queries to answer the following questions using the operators introduced in this section.

1. "Get the details of the longest-serving employee of the corporation."

2. "Get the details of the highest paid employee of the corporation in Libya."
*/


SELECT *
FROM employees
ORDER BY start_date ASC
LIMIT 1;

SELECT *
FROM employees
WHERE country = 'Libya'
ORDER BY salary DESC
LIMIT 1;

