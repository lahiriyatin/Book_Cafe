/*

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS menu_food;
DROP TABLE IF EXISTS menu_books;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    gender VARCHAR(10) CHECK (gender IN ('Male', 'Female')),
    age INT CHECK (age > 0),
    city VARCHAR(100),
    join_date DATE NOT NULL,
    membership_tier VARCHAR(10) CHECK (membership_tier IN ('Silver', 'Gold', 'Platinum', 'Bronze'))
);

CREATE TABLE menu_books (
    book_id INT PRIMARY KEY,
    book_title VARCHAR(100) NOT NULL,
    author VARCHAR(100),
    genre VARCHAR(100),
    price NUMERIC(10,2) CHECK (price >= 0),
    availability_status VARCHAR(20) CHECK (availability_status IN ('Available', 'Not Available'))
);

CREATE TABLE menu_food (
    food_id INT PRIMARY KEY,
    food_name VARCHAR(100) NOT NULL,
    category VARCHAR(100),
    price NUMERIC(10,2) CHECK (price >= 0),
    availability_status VARCHAR(20) CHECK (availability_status IN ('Available', 'Not Available'))
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id) ON DELETE CASCADE,
    order_date DATE NOT NULL,
    payment_mode VARCHAR(20) CHECK (payment_mode IN ('Cash', 'UPI', 'Card')),
    branch VARCHAR(100)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT REFERENCES orders(order_id) ON DELETE CASCADE,
    item_type VARCHAR(10) CHECK (item_type IN ('food', 'book')),
    item_id INT NOT NULL,
    quantity INT DEFAULT 1 CHECK (quantity > 0)
);




COPY customers
FROM 'D:\User\lahir\Desktop\data_analytics\sql\book_cafe_dataset\customers.csv'
DELIMITER ','
CSV HEADER;

COPY menu_books
FROM 'D:\User\lahir\Desktop\data_analytics\sql\book_cafe_dataset\menu_books.csv'
DELIMITER ','
CSV HEADER;

COPY menu_food
FROM 'D:\User\lahir\Desktop\data_analytics\sql\book_cafe_dataset\menu_food.csv'
DELIMITER ','
CSV HEADER;

COPY orders
FROM 'D:\User\lahir\Desktop\data_analytics\sql\book_cafe_dataset\orders.csv'
DELIMITER ','
CSV HEADER;

COPY order_items
FROM 'D:\User\lahir\Desktop\data_analytics\sql\book_cafe_dataset\order_items.csv'
DELIMITER ','
CSV HEADER;

*/


SELECT * FROM customers;
SELECT * FROM menu_books;
SELECT * FROM menu_food;
SELECT * FROM orders;
SELECT * FROM order_items;



SELECT item_type, quantity, name, payment_mode, gender, branch, age, city, membership_tier FROM order_items 
JOIN orders ON orders.order_id=order_items.order_id
JOIN customers ON customers.customer_id=orders.customer_id;


--Book price updated

DROP TABLE IF EXISTS temp_book;

CREATE TEMP TABLE temp_book (
  book_id INT,
  book_title TEXT,
  author TEXT,
  genre TEXT,
  price NUMERIC(10,2),
  availability_status TEXT
);


COPY temp_book
FROM 'D:\User\lahir\Desktop\data_analytics\sql\book_cafe_dataset\menu_books.csv'
DELIMITER ','
CSV HEADER;


UPDATE menu_books mb
SET price = tb.price
FROM temp_book tb
WHERE mb.book_id = tb.book_id;

SELECT mb.book_id, mb.book_title, mb.price
FROM menu_books mb
ORDER BY mb.book_id;




--SIMPLE QUESTION--

--List all books priced above ₹500.

SELECT * FROM menu_books
WHERE price > 500
ORDER BY price;


--Find the total number of orders placed in January 2025.

SELECT * FROM orders
WHERE order_date BETWEEN '2025-01-01' AND '2025-01-31';


--Display all food items that are beverages.

SELECT * FROM menu_food
WHERE category = 'Beverage';


--Get all books written by “John Contreras”.

SELECT * FROM menu_books
WHERE author = 'John Contreras';


--Show all orders made on weekends.

SELECT *, TO_CHAR(order_date, 'Day') AS day_name FROM orders
WHERE EXTRACT(DOW FROM order_date) IN (0,6);



--Count how many distinct books have been sold so far.

SELECT COUNT(DISTINCT book_title) as distinct_book_count
FROM menu_books
JOIN order_items
ON menu_books.book_id=order_items.item_id
WHERE item_type='book'


--Find the total quantity of each food item sold.

SELECT food_name, SUM(quantity) AS total_quantity_ordered
FROM order_items
JOIN menu_food
ON order_items.item_id=menu_food.food_id
WHERE item_type='food'
GROUP BY food_name
ORDER BY total_quantity_ordered ASC;

--List all orders where the total amount is greater than $100.

SELECT c.customer_id, c.name, o.order_id, oi.item_type, oi.quantity*b.price AS Total_Amount
FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id
JOIN customers c
ON o.customer_id=c.customer_id
JOIN menu_books b
ON oi.item_id=b.book_id
WHERE item_type='book' AND (oi.quantity*b.price)>100

UNION ALL

SELECT c.customer_id, c.name, o.order_id,oi.item_type, oi.quantity*f.price AS Total_Amount
FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id
JOIN customers c
ON o.customer_id=c.customer_id
JOIN menu_food f
ON oi.item_id=f.food_id
WHERE item_type='food' AND (oi.quantity*f.price)>=100

ORDER BY Total_Amount DESC;





--Show the top 5 most expensive food items.

SELECT food_name, category, price FROM menu_food
ORDER BY price DESC
LIMIT 5;



--Advanced Question--

--List each customer with their total spend on books and food separately.

SELECT c.name, oi.item_type, SUM(COALESCE(b.price,f.price)*oi.quantity) AS Total_Spend
FROM order_items oi
JOIN orders o
ON o.order_id=oi.order_id
JOIN customers c
ON c.customer_id=o.customer_id
LEFT JOIN menu_food f
ON f.food_id=oi.item_id
AND oi.item_type='food'
LEFT JOIN menu_books b
ON b.book_id=oi.item_id
AND oi.item_type='book'
GROUP BY c.customer_id, c.name, oi.item_type
ORDER BY c.name, oi.item_type;



--Find the top 5 customers who spent the most overall (books + food combined).

SELECT c.name
FROM order_items oi
JOIN orders o
ON o.order_id=oi.order_id
JOIN customers c
ON c.customer_id=o.customer_id
LEFT JOIN menu_food f
ON f.food_id=oi.item_id
AND oi.item_type='food'
LEFT JOIN menu_books b
ON b.book_id=oi.item_id
AND oi.item_type='book'
GROUP BY c.customer_id
ORDER BY SUM(COALESCE(b.price,f.price)*oi.quantity) DESC
LIMIT 5;




--Show the most frequently ordered book and how many times it was ordered.

SELECT  b.book_title, COUNT(*) AS no_of_orders
FROM menu_books b
JOIN order_items oi
ON b.book_id=oi.item_id
WHERE item_type='book'
GROUP BY b.book_title
ORDER BY no_OF_orders DESC
LIMIT 1;



--Show the book with most copies sold and no. of copies sold.

SELECT  b.book_title, SUM(oi.quantity) AS copies_sold
FROM menu_books b
JOIN order_items oi
ON b.book_id=oi.item_id
WHERE item_type='book'
GROUP BY b.book_title
ORDER BY copies_sold DESC
LIMIT 1;

--Display all orders that include both a book and a beverage.

SELECT oi.order_id
FROM order_items oi
LEFT JOIN menu_books b 
  ON oi.item_id = b.book_id 
  AND oi.item_type = 'book'
LEFT JOIN menu_food f
  ON oi.item_id = f.food_id 
  AND oi.item_type = 'food'
GROUP BY oi.order_id
HAVING 
    COUNT(CASE WHEN oi.item_type = 'book' THEN 1 END) > 0
    AND COUNT(CASE WHEN f.category = 'Beverage' THEN 1 END) > 0;



--For each day, show the total sales and number of unique customers.

SELECT o.order_date, SUM(COALESCE(b.price,f.price)*oi.quantity) AS Total_Sale, COUNT(DISTINCT(c.customer_id)) AS no_of_unique_customers
FROM orders o
JOIN customers c
  ON o.customer_id=c.customer_id
JOIN order_items oi
  ON o.order_id=oi.order_id
LEFT JOIN menu_books b 
  ON oi.item_id = b.book_id 
  AND oi.item_type = 'book'
LEFT JOIN menu_food f
  ON oi.item_id = f.food_id 
  AND oi.item_type = 'food'
GROUP BY o.order_date
ORDER BY o.order_date


--Find the average order value for each payment method.

SELECT o.payment_mode, AVG(COALESCE(b.price,f.price)*oi.quantity) AS Total_Spent
FROM orders o
JOIN order_items oi
  ON o.order_id=oi.order_id
LEFT JOIN menu_books b 
  ON oi.item_id = b.book_id 
  AND oi.item_type = 'book'
LEFT JOIN menu_food f
  ON oi.item_id = f.food_id 
  AND oi.item_type = 'food'
GROUP BY o.payment_mode



--List customers who bought more than 3 different books but never ordered food.

SELECT c.name
FROM customers c
JOIN orders o
  ON o.customer_id=c.customer_id
JOIN order_items oi
  ON o.order_id=oi.order_id
LEFT JOIN menu_books b 
  ON oi.item_id = b.book_id 
  AND oi.item_type = 'book'
LEFT JOIN menu_food f
  ON oi.item_id = f.food_id 
  AND oi.item_type = 'food'
GROUP BY c.name
HAVING 
    COUNT(DISTINCT CASE WHEN oi.item_type = 'book' THEN oi.item_id END) > 3
    AND COUNT(DISTINCT CASE WHEN oi.item_type = 'food' THEN oi.item_id END) = 0




--Find the most popular author by total books sold.

SELECT  b.author, SUM(oi.quantity) AS copies_sold
FROM menu_books b
JOIN order_items oi
ON b.book_id=oi.item_id
WHERE item_type='book'
GROUP BY b.author
ORDER BY copies_sold DESC
LIMIT 1;



--Show all customers who ordered both fiction and non-fiction books.

SELECT c.name,
		COUNT(CASE WHEN b.genre = 'Non-Fiction' THEN oi.item_id END) AS no_of_non_fiction_books_ordered,
		COUNT(CASE WHEN b.genre = 'Fiction' THEN oi.item_id END) AS no_of_fiction_books_ordered
FROM customers c
JOIN orders o
  ON o.customer_id=c.customer_id
JOIN order_items oi
  ON o.order_id=oi.order_id
LEFT JOIN menu_books b 
  ON oi.item_id = b.book_id 
  AND oi.item_type = 'book'
GROUP BY c.name
HAVING 
    COUNT(CASE WHEN b.genre = 'Fiction' THEN oi.item_id END) > 0
    AND COUNT(CASE WHEN b.genre = 'Non-Fiction' THEN oi.item_id END) > 0





--Bonus Questions--

--Using a window function, rank customers by their total spend, and show the top 10 with their ranks.

SELECT 
    c.customer_id,
    c.name,
    SUM(COALESCE(b.price, f.price) * oi.quantity) AS total_sales,
    DENSE_RANK() OVER (ORDER BY SUM(COALESCE(b.price, f.price) * oi.quantity) DESC) AS sales_rank
FROM customers c
JOIN orders o
  ON o.customer_id = c.customer_id
JOIN order_items oi
  ON o.order_id = oi.order_id
LEFT JOIN menu_books b
  ON oi.item_id = b.book_id AND oi.item_type = 'book'
LEFT JOIN menu_food f
  ON oi.item_id = f.food_id AND oi.item_type = 'food'
GROUP BY c.customer_id, c.name
ORDER BY total_sales DESC
LIMIT 10;



--Write a query to find daily sales growth rate (percentage change from the previous day).

SELECT 
    o.order_date,
    SUM(COALESCE(b.price, f.price) * oi.quantity) AS total_sales,
    ROUND(
        (
            (SUM(COALESCE(b.price, f.price) * oi.quantity) - 
             LAG(SUM(COALESCE(b.price, f.price) * oi.quantity)) OVER (ORDER BY o.order_date))
            / NULLIF(LAG(SUM(COALESCE(b.price, f.price) * oi.quantity)) OVER (ORDER BY o.order_date), 0)
        ) * 100, 
    2) AS daily_growth_percent
FROM orders o
JOIN order_items oi 
    ON o.order_id = oi.order_id
LEFT JOIN menu_books b 
    ON oi.item_id = b.book_id AND oi.item_type = 'book'
LEFT JOIN menu_food f 
    ON oi.item_id = f.food_id AND oi.item_type = 'food'
GROUP BY o.order_date
ORDER BY o.order_date;



--Create a CTE to find customers whose average book order value is above the café’s average book order value.

WITH customer_avg AS (
	SELECT c.customer_id, c.name, ROUND(AVG(b.price * quantity), 2) AS customer_avg_book_order
	FROM customers c
	 JOIN orders o 
        ON o.customer_id = c.customer_id
    JOIN order_items oi 
        ON o.order_id = oi.order_id
    JOIN menu_books b 
        ON oi.item_id = b.book_id 
       AND oi.item_type = 'book'
	GROUP BY c.customer_id, c.name
),
cafe_avg AS(
	SELECT 
        ROUND(AVG(b.price * oi.quantity), 2) AS cafe_avg_book_order_value
    FROM orders o
    JOIN order_items oi 
        ON o.order_id = oi.order_id
    JOIN menu_books b 
        ON oi.item_id = b.book_id 
       AND oi.item_type = 'book'
)

SELECT ca.name, ca.customer_avg_book_order, cv.cafe_avg_book_order_value
FROM customer_avg ca
CROSS JOIN cafe_avg cv
WHERE ca.customer_avg_book_order > cv.cafe_avg_book_order_value;

--OR USINg WINDOW FUNCTION--

SELECT name, ROUND(customer_avg,2) AS customer_avg, ROUND(cafe_avg,2) AS cafe_avg
FROM (
  SELECT
    c.customer_id,
    c.name,
    AVG(b.price * oi.quantity) AS customer_avg,
    AVG(AVG(b.price * oi.quantity)) OVER () AS cafe_avg
  FROM customers c
  JOIN orders o ON o.customer_id = c.customer_id
  JOIN order_items oi ON o.order_id = oi.order_id
  JOIN menu_books b ON oi.item_id = b.book_id AND oi.item_type = 'book'
  GROUP BY c.customer_id, c.name
)
WHERE customer_avg > cafe_avg
ORDER BY customer_avg DESC;


--Find the best-selling combination of book and food (pair ordered together most often).




--Identify the most loyal customers — those who ordered in at least 8 different months.





