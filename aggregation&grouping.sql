-- 1. Find the total, average, minimum, and maximum credit limit of all customers.
select  sum( cust_credit_limit) as total,
        avg( cust_credit_limit) as average,
        max( cust_credit_limit) as maximum,
        min( cust_credit_limit) as minimum 
from sh.customers; 

-- 2. Count the number of customers in each income level.
select  cust_income_level, 
count(*) as number_of_customers 
from sh.customers 
group by cust_income_level;

-- 3. Show total credit limit by state and country.
select cust_state_province, country_id,
sum( cust_credit_limit) as total_credit_limit
from sh.customers 
group by cust_state_province,country_id;

-- 4. Display average credit limit for each marital status and gender combination.
select cust_marital_status, cust_gender,
avg( cust_credit_limit) as average_credit_limit
from sh.customers 
group  by cust_marital_status, cust_gender;

-- 5. Find the top 3 states with the highest average credit limit.
select cust_state_province,
avg( cust_credit_limit) as average_credit_limit
from sh.customers 
group by cust_state_province 
order by cust_state_province desc  fetch first 3 rows only;

-- 6. Find the country with the maximum total customer credit limit.
select  country_id,
 max( cust_credit_limit) as maximum_credit_limit
from sh.customers 
group by country_id;

-- 7. Show the number of customers whose credit limit exceeds their state average.
SELECT cust_state_province,COUNT(*) AS num_customers_above_state_avg
FROM sh.customers WHERE cust_credit_limit > (SELECT AVG(cust_credit_limit)
FROM sh.customers) GROUP BY cust_state_province ORDER BY num_customers_above_state_avg DESC;

-- 8. Calculate total and average credit limit for customers born after 1980.
select cust_year_of_birth, count(*),sum( cust_credit_limit) as total_credit_limit, avg( cust_credit_limit) as average_credit_limit
from sh.customers group by cust_year_of_birth  having cust_year_of_birth >1980 order by cust_year_of_birth

-- 9. Find states having more than 50 customers.
select cust_state_province, count(*) as number_of_customers
 from sh.customers group by cust_state_province having count(*) > 50 order by number_of_customers

-- 10. List countries where the average credit limit is higher than the global average.
select country_id, avg( cust_credit_limit) as average_credit_limit 
from sh.customers group by country_id having average_credit_limit > 
(select avg( cust_credit_limit) from sh.customers ) order by average_credit_limit desc

-- 11. Calculate the variance and standard deviation of customer credit limits by country.
select country_id , var_samp(cust_credit_limit) as variance_credit_limit, 
stddev_samp(cust_credit_limit) as standard_credit_limit 
from sh.customers group by country_id order by country_id desc

-- 12. Find the state with the smallest range (max–min) in credit limits.
select * from
(select cust_state_province, max(cust_credit_limit)- min(cust_credit_limit) as smallest_credit_limit
from sh.customers group by cust_state_province order by smallest_credit_limit asc)
where rownum = 1

-- 13. Show the total number of customers per income level and the percentage contribution of each.
select cust_income_level, count(*) as num_customers,
round(count(*) * 100 / (select count(*) from sh.customers), 2) as percentage_contribution
from sh.customers 
group by cust_income_level 
order by num_customers desc;

-- 14. For each income level, find how many customers have NULL credit limits.
select cust_income_level,count(*) as num_customers_with_null
from sh.customers  where cust_credit_limit is null 
group by cust_income_level;

-- 15. Display countries where the sum of credit limits exceeds 10 million.
select country_id, sum(cust_credit_limit) as total_credit_limit
from sh.customers 
group by country_id 
having total_credit_limit > 1000000 
order by total_credit_limit desc;