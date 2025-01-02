------- CLASS 01 -------
------- WORKING ON BIKESTORES DATABASE -------

-- 1. Creating Database
create database BikeStores;

-- 2. Using Database
use BikeStores;

-- 3. Create Schemas
create schema sales;

-- 4. Create Store Table

CREATE TABLE sales.stores (
	store_id INT IDENTITY (1, 1) PRIMARY KEY,
	store_name VARCHAR (255) NOT NULL,
	phone VARCHAR (25),
	email VARCHAR (255),
	street VARCHAR (255),
	city VARCHAR (255),
	state VARCHAR (10),
	zip_code VARCHAR (5)
);

select * from sales.stores;

-- 4. Create Staff Table

CREATE TABLE sales.staffs (
	staff_id INT IDENTITY (1, 1) PRIMARY KEY,
	first_name VARCHAR (50) NOT NULL,
	last_name VARCHAR (50) NOT NULL,
	email VARCHAR (255) NOT NULL UNIQUE,
	phone VARCHAR (25),
	active tinyint NOT NULL,
	store_id INT NOT NULL,
	manager_id INT,
	FOREIGN KEY (store_id) 
        REFERENCES sales.stores (store_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (manager_id) 
        REFERENCES sales.staffs (staff_id) 
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- 4.a. Create Production Schema

create schema production;

-- 4.b. Create Categories Table

CREATE TABLE production.categories (
	category_id INT IDENTITY (1, 1) PRIMARY KEY,
	category_name VARCHAR (255) NOT NULL
);

-- 5. Create Brands Table 

CREATE TABLE production.brands (
	brand_id INT IDENTITY (1, 1) PRIMARY KEY,
	brand_name VARCHAR (255) NOT NULL
);

-- 5. Create Products Table 

CREATE TABLE production.products (
	product_id INT IDENTITY (1, 1) PRIMARY KEY,
	product_name VARCHAR (255) NOT NULL,
	brand_id INT NOT NULL,
	category_id INT NOT NULL,
	model_year SMALLINT NOT NULL,
	list_price DECIMAL (10, 2) NOT NULL,
	FOREIGN KEY (category_id) 
        REFERENCES production.categories (category_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (brand_id) 
        REFERENCES production.brands (brand_id) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 6. Create Customers Table 

CREATE TABLE sales.customers (
	customer_id INT IDENTITY (1, 1) PRIMARY KEY,
	first_name VARCHAR (255) NOT NULL,
	last_name VARCHAR (255) NOT NULL,
	phone VARCHAR (25),
	email VARCHAR (255) NOT NULL,
	street VARCHAR (255),
	city VARCHAR (50),
	state VARCHAR (25),
	zip_code VARCHAR (5)
);


-- 7. Create Orders Table

CREATE TABLE sales.orders (
	order_id INT IDENTITY (1, 1) PRIMARY KEY,
	customer_id INT,
	order_status tinyint NOT NULL,
	-- Order status: 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed
	order_date DATE NOT NULL,
	required_date DATE NOT NULL,
	shipped_date DATE,
	store_id INT NOT NULL,
	staff_id INT NOT NULL,
	FOREIGN KEY (customer_id) 
        REFERENCES sales.customers (customer_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (store_id) 
        REFERENCES sales.stores (store_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (staff_id) 
        REFERENCES sales.staffs (staff_id) 
        ON DELETE NO ACTION ON UPDATE NO ACTION
);


-- 8. Create Order_Items Table

CREATE TABLE sales.order_items(
	order_id INT,
	item_id INT,
	product_id INT NOT NULL,
	quantity INT NOT NULL,
	list_price DECIMAL (10, 2) NOT NULL,
	discount DECIMAL (4, 2) NOT NULL DEFAULT 0,
	PRIMARY KEY (order_id, item_id),
	FOREIGN KEY (order_id) 
        REFERENCES sales.orders (order_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (product_id) 
        REFERENCES production.products (product_id) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 8. Create Stocks Table

CREATE TABLE production.stocks (
	store_id INT,
	product_id INT,
	quantity INT,
	PRIMARY KEY (store_id, product_id),
	FOREIGN KEY (store_id) 
        REFERENCES sales.stores (store_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (product_id) 
        REFERENCES production.products (product_id) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- * means all the columns
-- "sales" is the schema in the BikeStores database
-- "customer" is the table in the sales schema

select * from sales.customers;

-- A. Specifying columns according to our requirement

select customer_id, email, city, zip_code from sales.customers;

-- B. Filtering Rows on specific condition

select first_name, last_name, street, city from sales.customers
where city = 'Houston';

-- C. Sorting Data using "Order By" on customer_id
--	"Order By", by default sort in ascending order.

select customer_id, first_name, last_name, city from sales.customers
where city = 'Houston'
order by customer_id;

-- D. Sorting Data using "Order By" on customer_id
--	"Order By", by default sort in ascending order.
-- In order to sort in descending we specify "Desc"

select customer_id, first_name, last_name, city from sales.customers
where city = 'Houston'
order by customer_id desc 


-- E. Getting number of rows a/c to our requirement.
--	using "TOP" command.

select top 7 customer_id, first_name, last_name, city from sales.customers
where city = 'Houston'
order by customer_id desc 

-- F. ORDER OF EXECUTION

-- 1. FROM
-- 2. JOIN
-- 3. WHERE
-- 4. GROUP BY
-- 5. HAVING
-- 6. SELECT
-- 7. DISTINCT
-- 8. ORDER BY
-- 9. LIMIT

-- G. Group By

select city, count(*)
from sales.customers
where state = 'CA'
group by city
order by city;

-- H. Having Clause
--	1. Filtering groups we use "Having" Clause.
--	2. NOTE; "where"clause filter rows while "Having" clause filter groups.

select city, count(*)
from sales.customers
where state = 'CA'
group by city
having count(*) > 10
order by city;


-- I. Order By with LEN(.....) Function

SELECT
    first_name,
    last_name
FROM
    sales.customers
ORDER BY
    LEN(first_name) DESC;

-- J. TOP and TIES command 

SELECT TOP 3 WITH TIES
    product_name, 
    list_price
FROM
    production.products
ORDER BY 
    list_price DESC;

-- k. SELECT DISTINCT 
--	1. It removes duplicate values from the column in the result set.
--  2. When you apply the DISTINCT clause to a column that contains NULLs, 
--     it will keep only one NULL and eliminate the others. In other words, the DISTINCT clause treats all NULLs as the same value.
-- ********* NOTE *********
--	1.1. Both DISTINCT and GROUP BY clause reduces the number of returned rows in the result set by removing the duplicates.
--	1.2. However, you should use the GROUP BY clause when you want to apply an aggregate function to one or more columns.

select distinct city, state
from sales.customers

-- L.1 WHERE CLAUSE
SELECT
    product_id,
    product_name,
    model_year,
    list_price
FROM
    production.products
WHERE
	model_year > 2018
ORDER BY
    list_price DESC;

-- L.2 WHERE CLAUSE & AND operator
SELECT
    product_id,
    product_name,
    model_year,
    list_price
FROM
    production.products
WHERE
	model_year > 2017 and product_id = 320
ORDER BY
    list_price DESC;

-- L.3 WHERE CLAUSE & OR operator
-- The OR operator with a WHERE clause returns result on basis of true result from any one condition.

SELECT
    product_id,
    product_name,
    category_id,
    model_year,
    list_price
FROM
    production.products
WHERE
    list_price > 6000 OR model_year = 2018
ORDER BY
    list_price DESC;

-- L.3 WHERE CLAUSE with BETWEEN operator

SELECT
    product_id,
    product_name,
    model_year,
    list_price
FROM
    production.products
WHERE
    list_price BETWEEN 1899.00 AND 1999.99
ORDER BY
    list_price DESC;

-- L.4 WHERE CLAUSE with IN operator
--	1. IN operator return only those values specified in the IN Oeprator.
SELECT
    product_id,
    product_name,
    category_id,
    model_year,
    list_price
FROM
    production.products
WHERE
    list_price IN (299.99, 369.99, 489.99)
ORDER BY
    list_price DESC;


-- M.  ----- WILDCARD CHARACTERS ------
----	1. %cruiser% will return all the words that contain "cruiser".

SELECT
	product_id,
	product_name,
	category_id,
	model_year,
	list_price
from
	production.products

where product_name like '%cruiser%'

order by list_price;


----	2. Starts with letter "z". 

SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers
WHERE
    last_name LIKE 'z%'
ORDER BY
    first_name;

----	3. Ending with letter "er". 

SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers
WHERE
    last_name LIKE '%er'
ORDER BY
    first_name;


----	4. Starts with letter "t" and ends with "s". 

SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers
WHERE
    last_name LIKE 't%s'
ORDER BY
    first_name;


----	5. Starts with any letter but second letter should be after " _ " .

SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers
WHERE
    last_name LIKE '_u%'
ORDER BY
    first_name; 

----	6. First character in the last name is either "Y" or "z".

SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers
WHERE
    last_name LIKE '[YZ]%'
ORDER BY
    last_name;













