-- 1. Categorize customers into income tiers: Platinum, Gold, Silver, Bronze.
select cust_id, cust_income_level,case
when substr(cust_income_level, 1, 1) in ('J','K','L') then 'Platinum'
when substr(cust_income_level, 1, 1) in ('G','H','I') then 'Gold'
when substr(cust_income_level, 1, 1) in ('D','E','F') then 'Silver'
when substr(cust_income_level, 1, 1) in ('A','B','C') then 'Bronze'
else 'Unknown'
end as income_tiers
from sh.customers
order by income_tiers;

-- 2. Display “High”, “Medium”, or “Low” income categories based on credit limit.
select cust_credit_limit, case 
when cust_credit_limit between 10000 and 15000 then 'High Income'
when cust_credit_limit between 5000 and 9900 then 'Medium Income'
else 'Low Income'
end as income_category
from sh.customers 

-- 3. Replace NULL income levels with "Unknown" using NVL
select nvl(cust_income_level, 'Unknown') as cust_income_level from sh.customers order by cust_income_level desc;

-- 4. Show customer details and mark whether they have above-average credit limit or not.
select  cust_credit_limit, case 
when cust_credit_limit > avg(cust_credit_limit) over() then 'above-average'
else 'below or equal average'
end as credit_limit
from sh.customers order by cust_credit_limit desc ;

-- 5. Use DECODE to convert marital status codes (S/M/D) into full text.
select cust_marital_status, decode(cust_marital_status, 'single','SINGLE','married','MARRIED','divorced','DIVORCED', 'unknown') as marital_status_full_text from sh.customers order by cust_marital_status

-- 6. Use CASE to show age group (≤30, 31–50, >50) from CUST_YEAR_OF_BIRTH.
select cust_year_of_birth ,  (extract(year from sysdate) - cust_year_of_birth) as age, case 
when (extract(year from sysdate) - cust_year_of_birth)<= 30 then 'age <= 30'
when (extract(year from sysdate) - cust_year_of_birth) between 31 and 50 then 'age 31-50'
when (extract(year from sysdate) - cust_year_of_birth)> 50 then 'age > 50'
else 'unknown'
end as age_group
from sh.customers order by age_group;

-- 7. Label customers as “Old Credit Holder” or “New Credit Holder” based on year of birth < 1980.
select cust_year_of_birth, case 
when cust_year_of_birth < 1980 then 'old credit holder'
else 'new credit holder'
end as customers_label from sh.customers order by  customers_label;

-- 8. Create a loyalty tag — “Premium” if credit limit > 50,000 and income_level = ‘E’.
select cust_credit_limit , cust_income_level, case 
when cust_credit_limit > 50000 and cust_income_level = 'E' then 'premium'
else 'regular'
end as loyalty_tag from sh.customers order by loyalty_tag asc;

-- 9. Assign grades (A–F) based on credit limit range using CASE.
select cust_credit_limit, Case
when cust_credit_limit >= 15000 then 'A'
when cust_credit_limit between 10000 and 11000 then 'B'
when cust_credit_limit between 9000 and 9999 then 'C'
when cust_credit_limit between 7000 and 8999 then 'D'
when cust_credit_limit between 5000 and 6999 then 'E'
else 'F'
end as credit_grade from sh.customers order by credit_grade;

-- 10. Show country, state, and number of premium customers using conditional aggregation
select 
    country_id,
    cust_state_province as state,
    count(
        case
            when cust_credit_limit > 50000 and cust_income_level = 'e' then 1
        end
    ) as premium_customers
from sh.customers
group by country_id, cust_state_province
order by premium_customers desc;