-- Table t1: Customer
Create Table Customer(
    Customer_id Number Primary key,
    Customer_name VarChar2(20),
    Email VarChar2(50),
    City VarChar(20),
    Country VarChar(20)
)

INSERT INTO Customer VALUES (1, 'John Smith', 'john.smith@gmail.com', 'New York', 'USA');
INSERT INTO Customer VALUES (2, 'Priya Sharma', 'priya.sharma@gmail.com', 'Delhi', 'India');
INSERT INTO Customer VALUES (3, 'Carlos Mendez', NULL, 'Madrid', 'Spain');
INSERT INTO Customer VALUES (4, 'Aisha Khan', 'aisha.khan@gmail.com', NULL, 'UAE');
INSERT INTO Customer VALUES (5, 'Liam Brown', 'liam.brown@gmail.com', 'London', NULL);

commit;

-- Table t2: product
Create Table Product (
    Product_id Number Primary Key,
    Product_name VarChar2(50),
    Category VarChar2(30),
    Price Number,
    Customer_id Number
);

INSERT INTO Product VALUES (101, 'Laptop', 'Electronics', 850, 1);
INSERT INTO Product VALUES (102, 'Smartphone', 'Electronics', 500, 1);
INSERT INTO Product VALUES (103, 'Tablet', 'Electronics', 300, 2);
INSERT INTO Product VALUES (104, 'Headphones', 'Accessories', 100, NULL);
INSERT INTO Product VALUES (105, 'Watch', 'Accessories', 150, 3);
INSERT INTO Product VALUES (106, 'Camera', 'Electronics', 700, 2);
INSERT INTO Product VALUES (107, 'Shoes', 'Fashion', 80, 4);
INSERT INTO Product VALUES (108, 'Backpack', 'Fashion', NULL, 4);

commit;

-- select table_name from user_tables

-- Inner Join Query
Select t1.Customer_id, t1.Customer_name, t1.city, t2.Product_name, t2.Price
From Customer t1 Inner Join Product t2 on t1.Customer_id = t2.Customer_id

-- Left Join Query
select t1.customer_id, t1.customer_name,t1.country,t2.product_name,t2.Category
from customer t1 left join product t2 on t1.Customer_id = t2.Customer_id

-- Right Join Query
select t1.customer_id, t1.customer_name,t1.country,t2.product_name,t2.Category
from customer t1 right join product t2 on t1.Customer_id = t2.Customer_id;

-- Full Outer Join Query
select t1.customer_id, t1.customer_name,t1.country,t2.product_name,t2.price
from customer t1 full outer join product t2 on t1.Customer_id = t2.Customer_id

-- Left Outer Join Query
select t1.customer_id, t1.customer_name,t1.country,t2.product_name,t2.Category, t2.price
from customer t1 left outer join product t2 on t1.Customer_id = t2.Customer_id

-- Right Outer Join Query
select t1.customer_id, t1.customer_name,t1.country,t2.product_name,t2.Category, t2.price
from customer t1 right outer join product t2 on t1.Customer_id = t2.Customer_id

-- Symmetric Difference Query
Select t1.customer_id, t1.customer_name, t1.country, t2.product_name, t2.category
from customer t1 full outer join product t2 on t1.customer_id = t2.customer_id where t1.customer_id is null or t2.customer_id is null