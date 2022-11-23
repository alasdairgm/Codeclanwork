-- MVP

-- Q1
-- (a). Find the first name, last name and team name of
--  employees who are members of teams.

SELECT e.first_name, e.last_name, t."name"  
FROM employees e
INNER JOIN teams t
ON e.team_id = t.id;

--(b). Find the first name, last name and team name of
--  employees who are members of teams and are enrolled 
-- in the pension scheme.
SELECT e.first_name, e.last_name, t."name"  
FROM employees e
INNER JOIN teams t
ON e.team_id = t.id
WHERE e.pension_enrol = true;

-- (c). Find the first name, last name and team name
-- of employees who are members of teams, where their 
-- team has a charge cost greater than 80.
SELECT e.first_name, e.last_name, t."name" AS team_name 
FROM employees e
INNER JOIN teams t
ON e.team_id = t.id
WHERE cast(t.charge_cost AS int4) > 80;


-- Q2
-- (a). Get a table of all employees details, together 
-- with their local_account_no and local_sort_code, if they
-- have them.
-- need employees, pay_details
SELECT e.first_name, e.last_name,
    pd.local_account_no, pd.local_sort_code 
FROM employees e
LEFT JOIN pay_details pd
ON e.pay_detail_id  = pd.id;

--(b). Amend your query above to also return the name of the 
-- team that each employee belongs to.
SELECT e.first_name, e.last_name,
    pd.local_account_no, pd.local_sort_code,
    t."name" AS team_name
FROM employees e
LEFT JOIN pay_details pd
ON e.pay_detail_id  = pd.id
LEFT JOIN teams t
ON e.team_id = t.id;

-- Q3
-- (a). Make a table, which has each employee id along 
-- with the team that employee belongs to.
SELECT e.id AS employee_ed,
    t."name" AS team_name
FROM employees e
LEFT JOIN teams t
ON e.team_id = t.id;



-- (b). Breakdown the number of employees in each of the teams.
SELECT
    t."name" AS team_name,
    count(e.*) AS n_employees
FROM employees e
INNER JOIN teams t
ON e.team_id = t.id
GROUP BY t."name" ;
 
-- (c). Order the table above by so that the teams with
--  the least employees come first.
SELECT
    t."name" AS team_name,
    count(e.*) AS n_employees
FROM employees e
INNER JOIN teams t
ON e.team_id = t.id
GROUP BY t."name"
ORDER BY n_employees ASC;

-- Q4
-- (a). Create a table with the team id, team name and 
-- the count of the number of employees in each team.
SELECT
    t.id AS team_id,
    t."name" AS team_name,
    count(e.*) AS n_employees
FROM employees e
INNER JOIN teams t
ON e.team_id = t.id
GROUP BY t.id;


-- (b). The total_day_charge of a team is defined as the 
-- charge_cost of the team multiplied by the number of 
-- employees in the team. Calculate the total_day_charge 
-- for each team.
SELECT
    t.id AS team_id,
    t."name" AS team_name,
    count(e.*) AS n_employees,
    CAST(t.charge_cost AS int4),
    CAST(t.charge_cost AS int4) * count(e.*) AS total_day_charge
FROM employees e
INNER JOIN teams t
ON e.team_id = t.id
GROUP BY t.id;

-- (c). How would you amend your query from above to 
-- show only those teams with a total_day_charge greater
--  than 5000?
SELECT
    t.id AS team_id,
    t."name" AS team_name,
    count(e.*) AS n_employees,
    CAST(t.charge_cost AS int4),
    CAST(t.charge_cost AS int4) * count(e.*) AS total_day_charge
FROM employees e
INNER JOIN teams t
ON e.team_id = t.id
GROUP BY t.id
HAVING CAST(t.charge_cost AS int4) * count(e.*) > 5000;


-- extension
-- Q5: How many of the employees serve on one or more 
-- committees?
SELECT count(distinct(ec.employee_id))
FROM employees_committees ec;


-- Q6: How many of the employees do not serve on a committee?
SELECT count(*)
FROM employees e
LEFT JOIN employees_committees ec 
ON e.id = ec.employee_id 
WHERE ec.committee_id IS NULL;


