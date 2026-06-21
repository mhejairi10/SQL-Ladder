-- # Summarizing Data with SQL
-- 
-- ## Summary Statistics
-- 32) How many rows are in the `pets` table? 13
select count(*)
from pets;

-- 33) How many female pets are in the `pets` table? 7
select count(*)
from pets
where sex ='F';

-- 34) How many female cats are in the `pets` table? 4 
select count(*)
from pets
where sex='F' and species='cat';

-- 35) What's the mean age of pets in the `pets` table? 5.23
SELECT avg(age)
from pets;
-- 36) What's the mean age of dogs in the `pets` table? 6.5
SELECT avg(age)
from pets
WHERE species = 'dog';
-- 37) What's the mean age of male dogs in the `pets` table? 8.33
SELECT avg(age)
from pets
where sex ='M' and species ='dog';

-- 38) What's the count, mean, minimum, and maximum of pet ages in the `pets` table? 13	5.23	1	10
--     * _NOTE:_ SQLite doesn't have built-in formulas for standard deviation or median!
select count(*), avg(age), min(age),max(age)
from pets;

-- 39) Repeat the previous problem with the following stipulations:
--     * Round the average to one decimal place.
--     * Give each column a human-readable column name (for example, "Average Age")
select count(*) as total_num_pets, round(avg(age),1) as average_age, min(age) as minimum_age ,max(age) as maximum_age
from pets;
-- 13	5.2	1	10

-- 40) How many rows in `employees_null` have missing salaries? 10
select count(*)
from employees_null
where salary is null;

-- 41) How many salespeople in `employees_null` having _nonmissing_ salaries? 8
select count(*)
from employees_null
where salary is not null and lower(job) ='sales';

-- 42) What's the mean salary of employees who joined the company after 2010? Go back to the usual `employees` table for this one.
--     * _Hint:_ You may need to use the `CAST()` function for this. To cast a string as a float, you can do `CAST(x AS REAL)`
SELECT AVG(salary)
FROM employees
WHERE startdate > '2010-12-31';

-- 43) What's the mean salary of employees in Swiss Francs?
--     * _Hint:_ Swiss Francs are abbreviated "CHF" and 1 USD = 0.97 CHF.
SELECT AVG(salary * 0.97) AS mean_salary_chf
FROM employees;

-- 44) Create a query that computes the mean salary in USD as well as CHF. Give the columns human-readable names
--  (for example "Mean Salary in USD"). 
-- Also, format them with comma delimiters and currency symbols.
--     * _NOTE:_ Comma-delimiting numbers is only available for integers in SQLite, so rounding 
-- (down) to the nearest dollar or franc will be done for us.
--     * _NOTE2:_ The symbols for francs is simply `Fr.` or `fr.`. So an example output will look like `100,000 Fr.`.

SELECT
     AVG(salary) AS "Mean Salary in USD",
     AVG(salary * 0.97) AS "Mean Salary in CHF"
FROM employees;

-- ## Aggregating Statistics with GROUP BY
-- 45) What is the average age of `pets` by species?
SELECT
    species,
    ROUND(AVG(age), 1) AS average_age
FROM pets
GROUP BY species;

-- 46) Repeat the previous problem but make sure the species label is also displayed! 
-- Assume this behavior is always being asked of you any time you use `GROUP BY`.
SELECT
    species,
    ROUND(AVG(age), 1) AS average_age
FROM pets
GROUP BY species;



-- 47) What is the count, mean, minimum, and maximum age by species in `pets`?
SELECT
    species,
    COUNT(*) AS count_pets,
    ROUND(AVG(age), 1) AS mean_age,
    MIN(age) AS minimum_age,
    MAX(age) AS maximum_age
FROM pets
GROUP BY species;

-- 48) Show the mean salaries of each job title in `employees`.
SELECT
    job,
    ROUND(AVG(salary), 2) AS mean_salary
FROM employees
GROUP BY job; 
-- 49) Show the mean salaries in New Zealand dollars of each job title in `employees`.
--     * _NOTE:_ 1 USD = 1.65 NZD.
SELECT
    job,
    ROUND(AVG(salary * 1.65), 2) AS mean_salary_nzd
FROM employees
GROUP BY job;
-- 50) Show the mean, min, and max salaries of each job title in `employees`, as well as the numbers of employees in each category.
SELECT
    job,
    COUNT(*) AS number_of_employees,
    ROUND(AVG(salary), 2) AS mean_salary,
    MIN(salary) AS minimum_salary,
    MAX(salary) AS maximum_salary
FROM employees
GROUP BY job;


-- 51) Show the mean salaries of each job title in `employees` sorted descending by salary.


select job,
	round(avg(salary),1) as average_salary
from employees
group by job
order by salary desc;	

-- 52) What are the top 5 most common first names among `employees`?
SELECT firstname, count(*) as total_number
from employees
group by firstname
order by total_number desc
limit 5;
-- 53) Show all first names which have exactly 2 occurrences in `employees`.
SELECT firstname, count(*) as total_number
from employees
group by firstname
having total_number= 2;
-- 54) Take a look at the `transactions` table to get a idea of what it contains. 
-- Note that a transaction may span multiple rows if different items are purchased as part of the same order.
--  The employee who made the order is also given by their ID.
select *
from transactions
limit 3;
-- 55) Show the top 5 largest orders (and their respective customer) in terms of the numbers of items purchased in that order.
SELECT *, SUM(quantity) AS total_items
FROM transactions
GROUP BY order_id,customer
ORDER BY total_items DESC
LIMIT 5;
-- 56) Show the total cost of each transaction.
--     * _Hint:_ The `unit_price` column is the price of _one_ item. The customer may have purchased multiple.
--     * _Hint2:_ Note that transactions here span multiple rows if different items are purchased.
select *, sum(unit_price*quantity) as total_cost1
from transactions
group by order_id;
-- 57) Show the top 5 transactions in terms of total cost.
select *, sum(unit_price*quantity) as total_cost1
from transactions
group by order_id
order by total_cost1 DESC
limit 5;
-- 58) Show the top 5 customers in terms of total revenue (ie, which customers have we done the most business with in terms of money?)
select customer,
    SUM(unit_price * quantity) AS total_revenue
FROM transactions
GROUP BY customer
ORDER BY total_revenue DESC
LIMIT 5;
-- 59) Show the top 5 employees in terms of revenue generated (ie, which employees made the most in sales?)
SELECT
    employee_id,
    SUM(unit_price * quantity) AS total_revenue
FROM transactions
GROUP BY employee_id
ORDER BY total_revenue DESC
LIMIT 5;
-- 60) Which customer worked with the largest number of employees?
--     * _Hint:_ This is a tough one! Check out the `DISTINCT` keyword.
SELECT
    customer,
    COUNT(DISTINCT employee_id) AS number_of_employees
FROM transactions
GROUP BY customer
ORDER BY number_of_employees DESC
LIMIT 1;
-- 61) Show all customers who've done more than $80,000 worth of business with us.
SELECT customer, sum(unit_price * quantity) as total_cost1 
from transactions
group by customer
HAVING total_cost1 > 80000;