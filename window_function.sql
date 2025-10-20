-- 1. Assign row numbers to customers ordered by credit limit descending.
select  row_number() over(order by cust_credit_limit  desc) as row_num,
 cust_credit_limit 
from sh.customers

-- 2. Rank customers within each state by credit limit.
select cust_state_province, cust_credit_limit, 
rank() over (partition by cust_state_province order by cust_credit_limit desc) as rank_cust
 from sh.customers

-- 3. Use DENSE_RANK() to find the top 5 credit holders per country.
select * from( 
select country_id, cust_credit_limit, 
dense_rank() over (partition by country_id order by  cust_credit_limit desc) as top_ranks  from sh.customers) 
where top_ranks <= 5;

-- 4. Divide customers into 4 quartiles based on their credit limit using NTILE(4).
select cust_credit_limit,
ntile(4) over(order by cust_credit_limit desc) as quartiles from sh.customers

-- 5. Calculate a running total of credit limits ordered by customer_id.
select cust_id,cust_credit_limit, 
sum(cust_credit_limit) over(order by cust_id ) as total_credit_limit from sh.customers

-- 6. Show cumulative average credit limit by country.
select country_id, cust_id, cust_credit_limit, 
avg(cust_credit_limit) over (partition by country_id order by cust_id  rows between unbounded preceding and current row) as cumulative_average from sh.customers

-- 7. Compare each customer’s credit limit to the previous one using LAG().
select cust_id,cust_credit_limit, lag(cust_credit_limit, 1) over(order by cust_id  desc) as previous_limit from sh.customers

-- 8. Show next customer’s credit limit using LEAD().
select cust_id, cust_credit_limit, lead(cust_credit_limit, 1) over(order by cust_id ) as next_limit  from sh.customers

-- 9. Display the difference between each customer’s credit limit and the previous one.
select cust_id,cust_credit_limit, lag(cust_credit_limit, 1) over(order by cust_id ) as previous_limit, cust_credit_limit - lag(cust_credit_limit )over(order by cust_id ) as previous_difference from sh.customers

-- 10. For each country, display the first and last credit limit using FIRST_VALUE() and LAST_VALUE().
select country_id, cust_credit_limit, first_value(cust_credit_limit) over(partition by country_id order by cust_credit_limit  asc rows between unbounded preceding and unbounded following) as first_credit_limit,
last_value(cust_credit_limit) over(partition by country_id order by cust_credit_limit  asc rows between unbounded preceding and unbounded following) as last_credit_limit from sh.customers

-- 11. Compute percentage rank (PERCENT_RANK()) of customers based on credit limit.
select  cust_credit_limit, percent_rank() over ( order by cust_credit_limit desc) as precentage_credit from sh.customers 

-- 12. Show each customer’s position in percentile (CUME_DIST() function).
select cust_credit_limit, cume_dist() over (order by cust_credit_limit ) as percentile_position from sh.customers 

-- 13. Display the difference between the maximum and current credit limit for each customer.
select cust_credit_limit, max(cust_credit_limit) over() - cust_credit_limit as difference_from_maximum from sh.customers

-- 14. Rank income levels by their average credit limit.
SELECT DISTINCT cust_income_level,average_credit,RANK() OVER (ORDER BY average_credit DESC) AS rank_average
FROM (SELECT cust_income_level,AVG(cust_credit_limit) OVER (PARTITION BY cust_income_level) AS average_credit
FROM sh.customers) 
ORDER BY rank_average;

-- 15. Calculate the average credit limit over the last 10 customers (sliding window).
select cust_id, cust_credit_limit, avg(cust_credit_limit)over(order by cust_id rows between 9 preceding and current row) as avg_last_10_rows from sh.customers order by cust_id
-- 16. For each state, calculate the cumulative total of credit limits ordered by city.
select cust_state_province, cust_city, sum(cust_credit_limit) over (order by cust_city) as total_credit_limits from sh.customers

-- 17. Find customers whose credit limit equals the median credit limit (use PERCENTILE_CONT(0.5)).
select cust_credit_limit,cust_id from (select cust_credit_limit ,cust_id, percentile_cont(0.5) within group (order by cust_credit_limit) over() as median_credit_limit from sh.customers) where cust_credit_limit = median_credit_limit;

-- 18. Display the highest 3 credit holders per state using ROW_NUMBER() and PARTITION BY.
select cust_state_province,cust_credit_limit from (select cust_state_province,cust_credit_limit, row_number()over(partition by cust_state_province order by cust_credit_limit desc) as highest_credit_holders from sh.customers) where highest_credit_holders = 3

-- 19. Identify customers whose credit limit increased compared to previous row (using LAG).
select cust_credit_limit, from (select  cust_credit_limit, lag(cust_credit_limit) over (order by cust_credit_limit ) as previous_credit_limit from sh.customers) where cust_credit_limit > previous_credit_limit ;

-- 20. Calculate moving average of credit limits with a window of 3.
select cust_id, cust_credit_limit, avg(cust_credit_limit)over( order by cust_id rows between 2 preceding and current row) as moving_average_credit from sh.customers

-- 21. Show cumulative percentage of total credit limit per country.
select country_id, cust_credit_limit, sum(cust_credit_limit)over (partition by country_id order by cust_credit_limit desc rows between unbounded preceding and current row) / sum(cust_credit_limit)over (partition by country_id) * 100 as cumulative_percentage from sh.customers order by country_id, cumulative_percentage;

-- 22. Rank customers by age (derived from CUST_YEAR_OF_BIRTH).
select cust_year_of_birth, rank() over(order by cust_year_of_birth asc) as rank_customer_by_age from sh.customers

-- 23. Calculate difference in age between current and previous customer in the same state.
select cust_year_of_birth, cust_state_province , cust_year_of_birth - lag(cust_year_of_birth) over (partition by cust_state_province order by cust_year_of_birth ) as age_difference from sh.customers

-- 24. Use RANK() and DENSE_RANK() to show how ties are treated differently.
select cust_id, cust_credit_limit, rank() over (order by cust_credit_limit desc) as rank_value, dense_rank() over (order by cust_credit_limit desc) as dense_rank_value from sh.customers;

-- 25. Compare each state’s average credit limit with country average using window partition.
select country_id, cust_state_province, avg(cust_credit_limit) over (partition by cust_state_province) as state_avg_credit_limit, avg(cust_credit_limit) over (partition by country_id) as country_avg_credit_limit, 
avg(cust_credit_limit) over (partition by cust_state_province) - avg(cust_credit_limit) over (partition by country_id) as difference_from_country_avg
from sh.customers order by country_id, cust_state_province;

-- 26. Show total credit per state and also its rank within each country.
select cust_state_province, country_id,total_credit_limit, rank() over (partition by country_id order by total_credit_limit desc) as country_rank
from ( select cust_state_province, country_id,sum(cust_credit_limit) as total_credit_limit from sh.customers group by country_id, cust_state_province) order by country_id, country_rank;

-- 27. Find customers whose credit limit is above the 90th percentile of their income level.
select cust_income_level,cust_credit_limit,credit_90th_percentile from (select cust_income_level,cust_credit_limit, percentile_cont(0.9) within group (order by cust_credit_limit) over (partition by cust_income_level) as credit_90th_percentile from sh.customers) sub where cust_credit_limit > credit_90th_percentile;

-- 28. Display top 3 and bottom 3 customers per country by credit limit.
with ranked_customers as (select cust_id,country_id,cust_credit_limit, row_number() over (partition by country_id order by cust_credit_limit desc) as rn_top,row_number() over (partition by country_id order by cust_credit_limit asc) as rn_bottom
from sh.customers)select * from ranked_customers where rn_top <= 3 or rn_bottom <= 3 order by country_id, rn_top, rn_bottom;