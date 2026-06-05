CREATE DATABASE EXPERIMENT_03;

USE EXPERIMENT_03;

CREATE TABLE Worker(
WORKER_ID INT PRIMARY KEY,
FIRST_NAME VARCHAR(30),
LAST_NAME VARCHAR(30),
SALARY INT,
JOINING_DATE VARCHAR(30),
DEPARTMENT VARCHAR(30),
);

INSERT INTO Worker(WORKER_ID, FIRST_NAME, LAST_NAME, SALARY, JOINING_DATE, DEPARTMENT)
VALUES
(1, 'Rana', 'Hamid', 100000, '2014-02-20 09:00:00', 'HR'),
(2, 'Sanjoy', 'Saha', 80000, '2014-06-11 09:00:00', 'Admin'),
(3, 'Mahmudul', 'Hasan', 300000, '2014-02-20 09:00:00', 'HR'),
(4, 'Asad', 'Zaman', 500000, '2014-02-20 09:00:00', 'Admin'),
(5, 'Sajib', 'Mia', 500000, '2014-06-11 09:00:00', 'Admin'),
(6, 'Alamgir', 'Kabir', 200000, '2014-06-11 09:00:00', 'Account'),
(7, 'Foridul', 'Islam', 75000, '2014-01-20 09:00:00', 'Account'),
(8, 'Keshob' ,'Ray', 90000 , '2014-04-11 09:00:00', 'Admin');

TRUNCATE TABLE Worker;

SELECT *
FROM Worker;

/*
1. Write an SQL query to print first three characters of FIRST_NAME from Worker table.
*/
SELECT SUBSTRING(FIRST_NAME, 1, 3) AS First_Three_Char
FROM Worker;

/*
2. Write an SQL query to print details of the Workers who have joined from Feb 2014 to
March 2014.
*/
SELECT *
FROM Worker
WHERE JOINING_DATE 
BETWEEN '2014-02-1' AND '2014-03-1';

/*
3. Write an SQL query to print details of the Workers who have served for at least 6 months.
*/
SELECT *
FROM Worker
WHERE DATEDIFF(MONTH, JOINING_DATE, GETDATE()) >= 6;

SELECT GETDATE() AS Curr_Date;

SELECT DATEDIFF(MONTH, JOINING_DATE, GETDATE()) AS Month_diff
FROM Worker;

/*
4. Write an SQL query to update all worker salary 10000Tk whose title is Admin.
*/
UPDATE Worker
SET SALARY = 10000
WHERE DEPARTMENT = 'Admin';

/*
EXTRA: Write an SQL query to update all worker salary 10% whose dept is Admin.
*/
UPDATE Worker
SET SALARY = SALARY * 1.10
WHERE DEPARTMENT = 'Admin';

/*
5. Write an SQL query to update all worker bonus 10% whose joining_date before ‘2014-
04-11 09:00:00’ otherwise bonus update 5% and also check department name is ‘Admin’.
*/
UPDATE Worker
SET SALARY = SALARY *
	CASE
		WHEN JOINING_DATE < '2014-04-11 09:00:00' THEN 1.10
		ELSE 1.05
	END
WHERE DEPARTMENT = 'Admin';

/*
6. Write an SQL query to delete all workers who have not taken any bonus
*/
DELETE
FROM Worker
WHERE DEPARTMENT != 'Admin';

/*
7. Write an SQL query to print details for Workers with the first name “Rana” and “Sajib”
from Worker table.
*/
--1st method
SELECT *
FROM Worker
WHERE FIRST_NAME BETWEEN 'Rana' AND 'Sajib';

--2nd method
SELECT *
FROM Worker
WHERE FIRST_NAME = 'Rana' OR FIRST_NAME = 'Sajib';

--3rd method
SELECT *
FROM Worker
WHERE FIRST_NAME IN('Rana', 'Sajib');

/*
8. Write an SQL query to print details of workers excluding first names, “Rana” and “Sajib”
from Worker table.
*/
SELECT *
FROM Worker
WHERE FIRST_NAME NOT IN('Rana', 'Sajib');

/*
9. Write an SQL query to print details of the Workers whose FIRST_NAME contains ‘a’.
*/
SELECT *
FROM Worker
WHERE FIRST_NAME LIKE '%a%';

/*
10. Write an SQL query to print details of the Workers whose FIRST_NAME starts with ‘k’.
*/
SELECT *
FROM Worker
WHERE FIRST_NAME LIKE 'k%';

/*
11. Write an SQL query to print details of the Workers whose FIRST_NAME ends with ‘r’
and contains seven alphabets.
*/
--1st method
SELECT *
FROM Worker
WHERE FIRST_NAME LIKE '%r' AND LEN(FIRST_NAME) = 7;

--2nd method
SELECT *
FROM Worker
WHERE FIRST_NAME LIKE '%r' AND DATALENGTH(FIRST_NAME) = 7;

/*
12. Write an SQL query to find the position of the alphabet (‘n’) in the FIRST_NAME
column ‘Sanjoy’ from Worker table.
*/
SELECT CHARINDEX('n', FIRST_NAME) AS Position_Of_N
FROM Worker
WHERE FIRST_NAME = 'Sanjoy';

/*
13. Find the average salary of employees for each department
*/
SELECT DEPARTMENT,
AVG(SALARY) AS Avg_salary
FROM Worker
GROUP BY DEPARTMENT;

/*
14. List all the employees who have maximum or minimum salary in each department
*/
SELECT Worker.*
FROM Worker
INNER JOIN(
SELECT DEPARTMENT,
MAX(SALARY) AS Max_salary,
MIN(SALARY) AS Min_salary
FROM Worker
GROUP BY DEPARTMENT) AS Temp
ON Worker.DEPARTMENT = Temp.DEPARTMENT
WHERE (Worker.SALARY = Temp.Max_salary OR Worker.SALARY = Temp.Min_salary)
ORDER BY DEPARTMENT, SALARY;

/*
15. Write an SQL query to find the position of the alphabet (‘r’) in the FIRST_NAME
column ‘Rana’ from Worker table.
*/
SELECT CHARINDEX('r', FIRST_NAME) AS Position_Of_R
FROM Worker
WHERE FIRST_NAME = 'Rana';

/*
16. Write an SQL query to print the FIRST_NAME from Worker table after removing white
spaces from the right side.
*/
SELECT RTRIM(FIRST_NAME) AS Remove_WhiteSpace_From_RighSide
FROM Worker;

/*
17. Write an SQL query that fetches the unique values of FIRST_NAME from Worker table
and prints its length.
*/
SELECT DISTINCT(FIRST_NAME) AS Unique_name,
LEN(FIRST_NAME) AS Name_length
FROM Worker;

/*
18. Write an SQL query to print the FIRST_NAME from Worker table after replacing ‘a’
with ‘A’.
*/
SELECT FIRST_NAME AS Before_replace,
REPLACE(FIRST_NAME, 'a', 'A') AS After_replace
FROM Worker;