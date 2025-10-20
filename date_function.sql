-- 1. Convert CUST_YEAR_OF_BIRTH to age as of today.
select cust_year_of_birth, extract(year from sysdate ) - cust_year_of_birth as age_as_of_today from sh.customers 

-- 2. Display all customers born between 1980 and 1990.
select cust_year_of_birth from sh.customers where cust_year_of_birth between 1980 and 1990

-- 3. Format date of birth into “Month YYYY” using TO_CHAR.
select cust_year_of_birth ,to_char(to_date(cust_year_of_birth, 'yyyy'), 'fmmonth yyyy') as formatted_dob
from sh.customers

-- 4. Convert income level text (like 'A: Below 30,000') to numeric lower limit.
select cust_income_level, to_number(replace(regexp_substr(cust_income_level, '\d+,\d+'),',','')) as lower_limit from sh.customers

-- 5. Display customer birth decades (e.g., 1960s, 1970s).
select cust_year_of_birth, to_char(floor(cust_year_of_birth/10)*10|| 's') as birth_decades from sh.customers 

-- 6. Show customers grouped by age bracket (10-year intervals).
select cust_year_of_birth, floor((extract(year from sysdate)- cust_year_of_birth)/10)*10||'-'||((floor(extract(year from sysdate)- cust_year_of_birth)/10)*10+9) as age_bracket, count(*) as total_customer
from sh.customers group by floor((extract(year from sysdate)- cust_year_of_birth)/10)*10 order by age_bracket

-- 7. Convert country_id to uppercase and state name to lowercase.
select upper(country_id) as country_id, lower(cust_state_province) as state_id from sh.customers

-- 8. Show customers where credit limit > average of their birth decade.
select cust_credit_limit, cust_year_of_birth, floor(cust_year_of_birth/10)*10 || 's' as birth_decade from sh.customers c where c.cust_credit_limit   
select avg(c2.cust_credit_limit) from sh.customers c2 where floor(c2.cust_year_of_birth/10) = floor(c.cust_year_of_birth/10)

-- 9. Convert all numeric credit limits to currency format $999,999.00.
select cust_credit_limit,to_char(cust_credit_limit, '$999,999.00') as formatted_credit_limit from sh.customers

-- 10. Find customers whose credit limit was NULL and replace with average (using NVL).
select nvl(cust_credit_limit,(select avg(cust_credit_limit) from sh.customers)) as credit_limit_filled from sh.customers