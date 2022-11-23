/*
 * Spend 5 minutes familiarising yourself with the zoo database
 * 
 * - how many tables are there?
 * -- 6
 * - how are they related?
 * -- tours to animals_tours
 * -- animals_tours to animals
 * -- animals to diets, care_schedule and animals_tours
 * -- care_schedule to animals and keepers
 * - what are the PKs and FKs?
 * -- id is PJ in each one
 * -- tour_id in animals_tours is id in tours
 * -- diet_id in animals is id in diets
 * -- animal_id in care_schedule is id in animals
 * -- keeper_id in care schedule is id in keepers
 * -- manager_id in keepers also relates back to itse
 *lf as id in the same table
 * - have a look at some of the values in the tables too
 */

-- going to be working mostly with animals table, 
-- and the diets table
-- diets: animals = 1:many
-- so many aniamsl may have the same diet


-- get me a list of all the animals that have diet plans
-- together with the diet plans that they are on

/*
 * Type of Join
 * Inner returns rows with a match in both tables
 * Left/right join returns rows in the left/right table along
 *   with info in the opposing table that match (i.e. no info dropped)
 * Full join returns all rows in both tables whether they
 *   match or not (nulls used to fill in gaps)
 * 
 */


-- join type:
-- tables: animals and diets
SELECT *
FROM animals INNER JOIN diets ON animals.diet_id = diets.id;
-- will not include rows of animals without diet_id
-- can see those rows lost with:
SELECT *
FROM animals;

/*
 * table_name.column syntax for referencing cols
 */
-- e.g.
SELECT animals.id, animals.name, diets.diet_type -- can do a.*
FROM animals INNER JOIN diets
ON animals.diet_id = diets.id; 

-- table aliased
-- same query as above but with aliases
SELECT a.name, d.diet_type
FROM animals AS a -- alias animals AS a OR whatever we want
INNER JOIN diets AS d -- alias diets AS d OR whatever we want
ON a.diet_id = d.id;

/*
 * Find any known diet types for animals over 4 yrs old
 * with a listed diet type
 */

-- tables to join: animals, diets
-- type of join: inner
SELECT *
FROM animals a
INNER JOIN diets d 
ON a.diet_id = d.id
WHERE a.age > 4;

/* 
 * Get me a breakdown of the number of animals in the zoo 
 * by their diet types
 * */

-- tables to join: animals, diets
-- type of join: inner

SELECT d.diet_type, count(*)
FROM animals a
INNER JOIN diets d ON a.diet_id = d.id
GROUP BY d.diet_type;


/*
 * get the details of all herbivores in the zoo
 */

SELECT a.*
FROM animals a 
INNER JOIN diets d ON a.diet_id = d.id 
WHERE d.diet_type ilike 'herbivore';

/* PLAN:
 * inner join - done
 * left and right joins
 * full join
 * many-to-many joins (2 joins)
 * self-joins
 * SQL's Binding equivalent
 * SQL's anti_join equivalent
 */


/*
 * LEFT JOIN
 * 
 */
-- get me a list of all the animals together with any
-- diet plans that they are on, if they have one

SELECT *
FROM animals a
LEFT JOIN diets d 
ON a.diet_id = d.id;

-- same as before but now we have the animals WITHOUT
-- a diet plan as well

/*
* RETURN how many animals follow EACH diet TYPE, INCLUDING
ANY diets which NO aniamls follow
*/

SELECT d.diet_type, count(a.*) AS num_animals
FROM diets d -- could DO RIGHT JOIN WITH animals ON left
LEFT JOIN animals a
ON  d.id = a.diet_id 
GROUP BY d.diet_type;

/*
 count(column) will count the number OF non-NULL VALUES IN COLUMN
 -  count(*) NOT the one
*/

/*
* FULL JOIN

* combines the results OF BOTH TABLES AND RETURNS ALL ROWS
* FROM the TABLES ON BOTH sides OF the JOIN
*  */



-- get me a table with all the information on animals and diets,
-- regardless of if they match up between TABLES 
SELECT *
FROM animals a
FULL JOIN diets d 
ON a.diet_id = d.id;
-- gives everything from animals table (including those without
-- diets, and everything from diets (including those without
-- animals)

/*
 * Joins in many:many relationships
 * 
 * two hops:
 * one hop to join table A with bridge table
 * one hop to join A-bridge joined table to table B
 */

/*
 * Get a rota for the keepers and the animals they
 * look after, ordered by animal name, then ordered
 * by day
 */


-- first hop, tables to join: animals, care_schedule
-- second hop, tables to join: animals + care_schedule, keepers k 

SELECT a."name" AS animal_name,
    cs."day",
    k."name" 
FROM animals a
INNER JOIN care_schedule cs -- INNER TO retain matches only
ON a.id = cs.animal_id
-- similar to piping, we just keep going
INNER JOIN keepers AS k
ON cs.keeper_id = k.id
ORDER BY animal_name, cs."day"; -- DAY OF week IS a particularly
-- ordered type of its own, according to DDL , so isn't ordered
-- alphabetically

/*
 * How would we change the above query to show only the schedule
 * for keepers looking after Ernest the snake?
 */
SELECT a."name" AS animal_name,
    cs."day",
    k."name" 
FROM animals a
INNER JOIN care_schedule cs -- INNER TO retain matches only
ON a.id = cs.animal_id
-- similar to piping, we just keep going
INNER JOIN keepers AS k
ON cs.keeper_id = k.id
WHERE a."name" ILIKE 'ernest' AND a.species ILIKE 'snake'
ORDER BY animal_name, cs."day";

/*
 * Task - 10 mins

Various animals feature on various tours around the zoo
(this is another example of a many-to-many relationship).

Identify the join table linking the animals and tours table 
and reacquaint yourself with its contents.
Obtain a table showing animal name and species, the tour
name on which they feature(d), along with the start date 
and end date (if stored) of their involvement.
Order the table by tour name, and then by animal name.
 */

-- Many to many between animals and tours
-- Many to one between animals and animals_tours
-- many to one betwene tours and animals_tours
-- animals - animals_tours - tours
-- primary keys are animals.id, animals_tours.id, tours.id
-- foreign keys are a.id = at.animal_id, at.tour_id = tours.id 

SELECT a.name AS animal_name,
    a.species, t."name" AS tour_name,
    at2.start_date, at2.end_date 
FROM animals a
RIGHT JOIN animals_tours at2 -- could use INNER BOTH AND THEN ORDER
-- of joins doesn't matter
ON a.id = at2.animal_id
INNER JOIN tours t
ON at2.tour_id = t.id
ORDER BY t."name", a."name";

/* UP NEXT:
 * Self join
 * Union - like bind_rows
 * Finding entries that don't match in a join (anti-join)
 */

-- can see that manager_id is referencing keeper_id in same table
SELECT *
FROM keepers;

/*
 * self join:
 * e.g. get a table showing the name of each keeper,
 * together with the name of their manager (if they have one)
 */

SELECT 
    k."name" AS keeper_name,
    m."name" AS manager_name
FROM keepers k
LEFT JOIN keepers AS m -- TREAT the same TABLE AS IF it were another 
ON k.manager_id = m.id;

/*
* UNION - bind ROWS
* UNION ALL - doesn't remove duplicate entries AFTER bind
*/

SELECT *
FROM animals
WHERE name = 'Ernest'
UNION
SELECT *
FROM animals;
-- here we've combined animals with name ernest to animals table
-- as a whole, but not duplicated

SELECT *
FROM animals
WHERE name = 'Ernest'
UNION ALL 
SELECT *
FROM animals;
-- this keeps duplicates (i.e. 4 ernests now)

/*
 * anti-join
 * 1. left join
 * 2. filter for where the primary key in table B is null
 */


/*
 * find the animals missing a diet_id
 */

SELECT *
FROM animals a
LEFT JOIN diets d
ON a.diet_id = d.id 
WHERE d.id IS NULL; -- FILTER effectively turns it INTO an anti join



