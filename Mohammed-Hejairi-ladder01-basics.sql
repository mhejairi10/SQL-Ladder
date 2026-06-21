-- 1) Query all the data in the `pets` table.  
SELECT *
FROM pets;

-- 2) Query only the first 5 rows of the `pets` table.
SELECT *
FROM pets
LIMIT 5;

-- 3) Query only the names and ages of the pets in the `pets` table.
SELECT name, age 
FROM pets;

-- 4) Query the pets in the `pets` table, sorted youngest to oldest.
SELECT *
FROM pets
ORDER BY age ASC;

-- 5) Query the pets in the `pets` table alphabetically.
SELECT *
FROM pets
ORDER BY name ASC;

-- 6) Query all the male pets in the `pets` table.
SELECT *
FROM pets
WHERE sex = 'M';

-- 7) Query all the cats in the `pets` table. 
SELECT *
FROM pets
where species = 'cat';
-- 8) Query all the pets in the `pets` table that are at least 5 years old.
SELECT *
FROM pets
WHERE age >= 5;
-- 9) Query all the male dogs in the `pets` table. Do not include the sex or species column, since you already know them.
SELECT name , age
FROM pets
WHERE sex = 'M';

-- 10) Get all the names of the dogs in the `pets` table that are younger than 5 years old.
SELECT name 
FROM pets
WHERE age < 5;

-- 11) Query all the pets in the `pets` table that are either male dogs or female cats.
SELECT * 
FROM pets
where (sex ='M' AND species='dog') OR (sex='F' AND species='cat'); 


-- 12) Query the five oldest pets in the `pets` table.
select *
from pets
order by age DESC
limit 5;

-- 13) Get the names and ages of all the female cats in the `pets` table sorted by age, descending.
select name, age
from pets 
where (sex ='F' AND species='cat')
order by age desc;

-- 14) Get all pets from `pets` whose names start with P.
select * 
from pets
where lower(name) like 'p%';

-- 15) Select all employees from `employees_null` where the salary is missing.
select *
from employees_null 
where salary is null;
-- 16) Select all employees from `employees_null` where the salary is below $35,000 or missing.
select * 
from employees_null 
where (salary<35000) OR salary is null; 
-- 17) Select all employees from `employees_null` where the job title is missing. What do you see?
SELECT *
from employees_null
where job is null;

-- this is what i got
-- 101	UNKNOWN	UNKNOWN		-1	

-- 18) Who is the newest employee in `employees`? The most senior?
SELECT firstname, min(startdate) 
FROM employees;
-- Mary	1990-02-16


SELECT firstname, max(startdate) 
FROM employees;
-- Roger	2019-05-24

-- 19) Select all employees from `employees` named Thomas. 
select * 
from employees
where lower(firstname) = 'thomas';

-- 20) Select all employees from `employees` named Thomas or Shannon.
SELECT * 
from employees 
where lower(firstname) = 'thomas' or lower(firstname) = 'shannon';

-- 21) Select all employees from `employees` named Robert, Lisa, or any name that begins with a J. In addition, only show employees who are _not_ in sales. This will be a little bit of a longer query.
--     * _Hint:_ There will only be 6 rows in the result.
SELECT * 
from employees
where (lower(firstname) = 'robert' or lower(firstname) = 'lisa' or lower(firstname) like 'j%') 
AND lower(job) != 'sales';


-- ## Column Operations
-- 22) Query the top 5 rows of the `employees` table to get a glimpse of these new data.
SELECT *
from employees 
LIMIT 5;


-- 23) Query the `employees` table, but convert their salaries to Euros. 
--     * _Hint:_ 1 Euro = 1.1 USD.
--     * _Hint2:_ If you think the output is ugly, try out the `ROUND()` function.

select *, round(salary/1.1)
from employees;

-- 24) Repeat the previous problem, but rename the column `salary_eu`.
select *, round(salary/1.1) as salary_eu
from employees;


-- 25) Query the `employees` table, but combine the `firstname` and `lastname` columns to be "Firstname, Lastname" format. Call this column `fullname`. For example, the first row should contain `Thompson, Christine` as `fullname`. Also, display the rounded `salary_eu` instead of `salary`.
--     * _Hint:_ The string concatenation operator is `||`
SELECT
    firstname || ', ' || lastname AS fullname,
    ROUND(salary / 1.1, 2) AS salary_eu
FROM employees;


-- 26) Query the `employees` table, but replace `startdate` with `startyear` using the `SUBSTR()` function. Also include `fullname` and `salary_eu`.
 SELECT
    lastname || ', ' || firstname AS fullname,
    ROUND(salary / 1.1, 2) AS salary_eu,
    SUBSTR(startdate, 1, 4) AS startyear
FROM employees;


-- 27) Repeat the above problem, but instead of using `SUBSTR()`, use `STRFTIME()`.
SELECT
    lastname || ', ' || firstname AS fullname,
    ROUND(salary /1.1, 2) AS salary_eu,
    STRFTIME('%Y',startdate) AS startyear
FROM employees;

-- 28) Query the `employees` table, replacing `firstname`/`lastname` with `fullname` and `startdate` with `startyear`. Print out the salary in USD again, except format it with a dollar sign, comma separators, and no decimal. For example, the first row should read `$123,696`. This column should still be named `salary`.
--     * _Hint:_ Check out SQLite's `printf` function.
--     * _Hint2:_ The format string you'll need is `$%,.2d`. You should read more about such formatting strings as they're useful in Python, too!
-- 
-- **Note:** For the next few problems, you'll probably want to use `CASE`/`WHEN` statements.
SELECT
    lastname || ', ' || firstname AS fullname,
    STRFTIME('%Y',startdate) AS startyear,
    printf('$%,.2d',salary) AS salary
FROM employees;

-- 29) Last year, only salespeople were eligible for bonuses. Create a column `bonus` that is "Yes" if you're eligible for a bonus, otherwise "No".
SELECT *,
       CASE
           WHEN lower(job) = 'sales' THEN 'Yes'
           ELSE 'No'
       END AS bonus
FROM employees;


-- 30) This year, only sales people with a salary of $100,000 or higher are eligible for bonuses. 
-- Create a `bonus` column like in the last problem for salespeople with salaries at least $100,000.
select *, case 
			when lower(job) = 'sales' and salary>=100000 then 'Yes'
			else 'No'
		end as bonus
from employees;		

-- 31) Next year, the bonus structure will be a little more complicated. 
-- You'll create a `target_comp` column which represents an employee's target total compensation after their bonus.
--  Here is the company's bonus structure:
-- 
-- * Salespeople who make more than $100,000 will be eligible for a 10% bonus.
-- * Salespeople who make less than $100,000 will be eligible for a 5% bonus.
-- * Administrators will also be eligible for a 5% bonus.
-- * Anyone who does not meet any of the above descriptions is not eligible for a bonus.
-- 
-- Create this `target_comp` column, making sure to format _both_ the `salary` and `target_comp` columns nicely 
-- (ie, with dollar signs and comma separators).

SELECT *,
    printf('$%,.2d', salary) AS salary,
    printf('$%,.2d',
        CASE
            WHEN lower(job) = 'sales' AND salary >= 100000 THEN salary * 1.10
            WHEN lower(job) = 'sales' AND salary < 100000 THEN salary * 1.05
            WHEN lower(job) = 'administrator' THEN salary * 1.05
            ELSE salary
        END
    ) AS target_comp
FROM employees;