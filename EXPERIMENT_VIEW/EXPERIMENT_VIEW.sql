CREATE DATABASE VIEWDB;

USE VIEWDB;

--salesman table
CREATE TABLE salesman(
salesman_id INT PRIMARY KEY,
name VARCHAR(30),
city VARCHAR(30),
commission FLOAT
);

INSERT INTO salesman(salesman_id, name, city, commission)
VALUES
(5001, 'James Hoog', 'New York', 0.15),
(5002, 'Nail Knite', 'Paris', 0.13),
(5005, 'Pit Alex', 'London', 0.11),
(5006, 'Mc Lyon', 'Paris', 0.14),
(5003, 'Lauson Hen', NULL, 0.12), 
(5007, 'Paul Adam', 'Rome', 0.13);

SELECT *
FROM salesman;

--customer table
CREATE TABLE customer(
customer_id INT PRIMARY KEY,
cust_name VARCHAR(30),
city VARCHAR(30),
grade INT,
salesman_id INT FOREIGN KEY REFERENCES salesman(salesman_id)
);

INSERT INTO customer(customer_id, cust_name, city, grade, salesman_id)
VALUES
(3002, 'Nick Rimando', 'New York', 100, 5001),
(3005, 'Graham Zusi', 'California', 200, 5002),
(3001, 'Brad Guzan', 'London', NULL, 5005),
(3004, 'Fabian Johns', 'Paris', 300, 5006),
(3007, 'Brad Davis', 'New York', 200, 5001),
(3009, 'Geoff Camero', 'Berlin', 100, 5003),
(3008, 'Julian Green', 'London', 300, 5002),
(3003, 'Jozy Altidor', 'Moscow', 200, 5007);

SELECT *
FROM customer;

--orders table
CREATE TABLE orders(
ord_no INT PRIMARY KEY,
purch_amt FLOAT,
ord_date VARCHAR(40),
customer_id INT FOREIGN KEY REFERENCES customer(customer_id),
salesman_id INT FOREIGN KEY REFERENCES salesman(salesman_id),
);

INSERT INTO orders(ord_no, purch_amt, ord_date, customer_id, salesman_id)
VALUES
(70001, 150.5, '2012-10-05', 3005, 5002),
(70009, 270.65, '2012-09-10', 3001, 5005),
(70002, 65.26, '2012-10-05', 3002, 5001),
(70004, 110.5, '2012-08-17', 3009, 5003),
(70007, 948.5, '2012-09-10', 3005, 5002),
(70005, 2400.6, '2012-07-27', 3007, 5001),
(70008, 5760, '2012-09-10', 3002, 5001),
(70010, 1983.43, '2012-10-10', 3004, 5006),
(70003, 2480.4, '2012-10-10', 3009, 5003),
(70012, 250.45, '2012-06-27', 3008, 5002),
(70011, 75.29, '2012-08-17', 3003, 5007),
(70013, 3045.6, '2012-04-25', 3002, 5001);

SELECT *
FROM orders;

/*
1. Write a query to create a view for those salesmen belongs to the city New York.
*/
CREATE VIEW Salesman_NewYork AS
SELECT *
FROM salesman
WHERE city = 'New York';

SELECT *
FROM Salesman_NewYork;

/*
2. Write a query to create a view for all salesmen with columns salesman_id, name and
city.
*/
CREATE VIEW AllSalesMan AS
SELECT salesman_id, name, city
FROM salesman;

SELECT *
FROM AllSalesMan;

/*
3. Write a query to find the salesmen of the city New York who achieved the
commission more than 13%.
*/
CREATE VIEW SalesmanCommision AS
SELECT *
FROM salesman
WHERE city = 'New York' AND commission > 0.13;

SELECT *
FROM SalesmanCommision;

/*
4. Write a query to create a view to getting a count of how many customers we have at
each level of a grade.
*/
CREATE VIEW CustomerCount AS
SELECT grade, COUNT(*) AS Total_Customer
FROM customer
GROUP BY grade;

SELECT *
FROM CustomerCount;

/*
5. Write a query to create a view to keeping track the number of customers ordering,
number of salesmen attached, average amount of orders and the total amount of orders
in a day.
*/
CREATE VIEW OrderTrack AS
SELECT ord_date,
COUNT(customer_id) AS No_of_Customer_Ordering,
COUNT(salesman_id) AS No_of_Salesman_Attach,
AVG(purch_amt) AS Avg_Amount_of_Orders,
SUM(purch_amt) AS Total_Amount_of_Orders
FROM orders
GROUP BY ord_date;

SELECT *
FROM OrderTrack;

/*
6. Write a query to create a view that shows for each order the salesman and customer
by name.
*/
CREATE VIEW ShowsOrder AS
SELECT O.ord_no, S.name, C.cust_name
FROM orders O
INNER JOIN salesman S
ON O.salesman_id = S.salesman_id
INNER JOIN customer C
ON O.customer_id = C.customer_id;

SELECT *
FROM ShowsOrder;

/*
7. Write a query to create a view that finds the salesman who has the customer with the
highest order of a day.
*/


/*
8. Write a query to create a view that shows all of the customers who have the highest
grade.
*/
CREATE VIEW CustomerWithHighestGrade AS
SELECT *
FROM customer 
WHERE grade IN(SELECT MAX(grade) FROM customer);

SELECT *
FROM CustomerWithHighestGrade;

/*
9. Write a query to create a view that shows the number of the salesman in each city.
*/
CREATE VIEW Salesman_In_Each_City AS
SELECT city, COUNT(*) AS No_Of_Salesman
FROM salesman
GROUP BY city
ORDER BY No_Of_Salesman OFFSET 0 ROWS;

SELECT *
FROM Salesman_In_Each_City;

/*
10. Write a query to create a view that shows the average and total orders for each
salesman after his or her name. (Assume all names are unique)
*/
CREATE VIEW Order_Info AS
SELECT S.salesman_id, S.name, Temp.Avg_Orders, Temp.Total_Orders
FROM salesman S
LEFT JOIN (
	SELECT salesman_id,
	AVG(purch_amt) AS Avg_Orders,
	SUM(purch_amt) AS Total_Orders
	FROM orders
	GROUP BY salesman_id
) AS Temp
ON S.salesman_id = Temp.salesman_id;

SELECT *
FROM Order_Info;

/*
11. Write a query to create a view that shows each salesman with more than one
customers.
*/
CREATE VIEW Salesman_With_At_Least_One_Customer AS
SELECT S.salesman_id, S.name, Temp.No_Of_Customers
FROM salesman S
INNER JOIN (
	SELECT salesman_id,
	COUNT(customer_id) AS No_Of_Customers
	FROM orders
	GROUP BY salesman_id
	HAVING COUNT(customer_id) > 1
) AS Temp
ON S.salesman_id = Temp.salesman_id;

SELECT *
FROM Salesman_With_At_Least_One_Customer;

/*
12. Write a query to create a view that shows all matches of customers with salesman
such that at least one customer in the city of customer served by a salesman in the city
of the salesman.
*/
CREATE VIEW Matches_Customer_and_Salesman AS
SELECT DISTINCT C.customer_id, C.cust_name, C.city AS Customer_City,
S.salesman_id, S.name, S.city AS Salesman_City
FROM customer C
INNER JOIN salesman S
ON C.city = S.city
INNER JOIN orders O
ON C.customer_id = O.customer_id
AND S.salesman_id = O.salesman_id;

SELECT *
FROM Matches_Customer_and_Salesman;

/*
13. Write a query to create a view that shows the number of orders in each day.
*/
CREATE VIEW No_Of_Orders_Each_Day AS
SELECT ord_date, COUNT(*) AS Number_of_orders
FROM orders
GROUP BY ord_date;

SELECT *
FROM No_Of_Orders_Each_Day;

/*
14. Write a query to create a view that finds the salesmen who issued orders on October
10th, 2012.
*/
CREATE VIEW Find_Salesman_With_Issued_Date AS
SELECT S.salesman_id, S.name, S.city, O.ord_date
FROM salesman S
INNER JOIN orders O
ON S.salesman_id = O.salesman_id
WHERE O.ord_date = '2012-10-10';

SELECT *
FROM Find_Salesman_With_Issued_Date;

--2nd method
SELECT S.*, ord_date
FROM salesman S
INNER JOIN
(SELECT salesman_id, ord_date
FROM orders
WHERE ord_date = '2012-10-10') AS temp
ON S.salesman_id = temp.salesman_id;

/*
15. Write a query to create a view that finds the salesmen who issued orders on either
August 17th, 2012 or October 10th, 2012.
*/
CREATE VIEW Find_Salesman_With_Diff_Date AS
SELECT S.salesman_id, S.name, S.city, O.ord_date
FROM salesman S
INNER JOIN orders O
ON S.salesman_id = O.salesman_id
WHERE O.ord_date = '2012-08-17' OR O.ord_date = '2012-10-10';

SELECT *
FROM Find_Salesman_With_Diff_Date;

--2nd method
SELECT S.salesman_id, S.name, S.city, O.ord_date
FROM salesman S
INNER JOIN orders O
ON S.salesman_id = O.salesman_id
WHERE O.ord_date IN('2012-08-17', '2012-10-10');

--3rd method
SELECT S.salesman_id, S.name, S.city, Temp.ord_date
FROM salesman S
INNER JOIN (
	SELECT salesman_id, ord_date
	FROM orders
	WHERE ord_date = '2012-08-17' OR ord_date = '2012-10-10'
) AS Temp
ON S.salesman_id = Temp.salesman_id;