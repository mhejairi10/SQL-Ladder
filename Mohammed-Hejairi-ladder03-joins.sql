-- 62) Which employee made which sale? 
-- Join the `employees` table onto the `transactions` table by `employee_id`. 
-- You only need to include the employee's first/last name from `employees`.
select employees.firstname,employees.lastname 
from employees
join transactions on employees.ID = transactions.employee_id;

-- 63) What is the name of the employee who made the most in sales? 
-- Find this answer by doing a join as in the previous problem.
--  Your resulting query will be difficult for someone else to read.

select employees.firstname,employees.lastname, sum(quantity*unit_price) as total_revenue
from employees
join transactions on employees.ID = transactions.employee_id
order by total_revenue
limit 1;
-- 64) Solve the previous problem by joining `employees` onto the `trans_by_employee` view.

select employees.firstname,employees.lastname, total_cost
from employees
join trans_by_employee on employees.ID = trans_by_employee.employee_id
order by total_cost
limit 1;
-- 65) Next, the company will try to give bonuses based on performance. 
-- Show all employees who've made more in sales than 1.5 times their salary.
select employees.firstname,employees.lastname, salary, total_cost
from employees
JOIN trans_by_employee on employees.id = trans_by_employee.employee_id
GROUP by employees.id
HAVING total_cost>1.5*salary;

-- 66) Do we have potentially erroneous rows? Find all transactions
--  which occurred _before_ the employee was even hired!
--  (Make sure each transaction only occupies one row).
select *
from employees
join transactions on transactions.employee_id = employees.ID
GROUP by order_id
having employees.startdate > transactions.orderdate;

-- 67) Among all transactions that occurred from 2015 to 2019, create a table that is the monthly revenue
--  of our company versus the total trading volume of Yum! in that month. Format the columns nicely. 
--  (Hint: look at the views) That is, a sample row of your result might look like this:
-- 
-- ```
-- | year | month | company_revenue | yum_trade_volu*me |
-- |------|-------|-----------------|------------------|
-- | 2017 |    03 |        $100,000 |      125,000,000 |
-- ```
-- 
-- * _Hint:_ You don't need any `WHERE` statements here.
--  You can get the right answer simply by changing what kind of join you do!
select trans_by_month.year , trans_by_month.month , trans_by_month.total_cost, yum_by_month.tot_volume
from trans_by_month
inner join yum_by_month on trans_by_month.year = yum_by_month.year and trans_by_month.month = yum_by_month.month;

