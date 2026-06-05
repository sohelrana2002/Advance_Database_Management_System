CREATE DATABASE EXPERIMENT_04;

USE EXPERIMENT_04;

--Worker table
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

--Bonus table
CREATE TABLE Bonus(
WORKER_REF_ID INT,
BONUS_DATE VARCHAR(20),
BONUS_AMOUNT INT
);

INSERT INTO Bonus(WORKER_REF_ID, BONUS_DATE, BONUS_AMOUNT)
VALUES
(1, '2019-02-20', 5000),
(2, '2019-06-11', 3000),
(3, '2019-02-20', 4000),
(4, '2019-02-20', 4500),
(5, '2019-06-11', 3500),
(6, '2019-06-12', NULL);

SELECT * 
FROM Bonus;

--Title table
CREATE TABLE Title(
WORKER_REF_ID INT,
WORKER_TITLE VARCHAR(20),
AFFECTED_FROM VARCHAR(20)
);


INSERT INTO Title(WORKER_REF_ID, WORKER_TITLE, AFFECTED_FROM)
VALUES
(1, 'Manager', '2019-02-20'),
(2, 'Executive', '2019-06-11'),
(8, 'Executive', '2019-06-11'),
(5, 'Manager', '2019-06-11'),
(4, 'Asst. Manager', '2019-06-11'),
(7, 'Executive', '2019-06-11'),
(6, 'Lead', '2019-06-11'),
(3, 'Lead', '2019-06-11');

SELECT * 
FROM Title;

--SHOWS ALL TABLE INFO
SELECT * 
FROM Worker;

SELECT * 
FROM Bonus;

SELECT * 
FROM Title;

/*
1. List all the employees except ‘Manager’ & ‘Asst. Manager’.
*/
SELECT *
FROM Worker
INNER JOIN Title
ON Worker.WORKER_ID = Title.WORKER_REF_ID
WHERE Title.WORKER_TITLE NOT IN('Manager', 'Asst. Manager');


/*
2. List the workers in the ascending order of Designations of those joined after April 2014
*/
SELECT *
FROM Worker
INNER JOIN Title
ON Worker.WORKER_ID = Title.WORKER_REF_ID
WHERE Worker.JOINING_DATE > '2014-04-01'
ORDER BY Title.WORKER_TITLE;

/*
3. Write an SQL query to fetch the number of employees working in the department
‘Admin’.
*/
SELECT COUNT(*) AS Number_of_admin
FROM Worker
WHERE DEPARTMENT = 'Admin';

/*
4. Write an SQL query to fetch worker names with salaries >= 50000 and <= 100000.
*/
SELECT FIRST_NAME + ' ' + LAST_NAME AS Full_name
FROM Worker
WHERE SALARY BETWEEN 50000 AND 100000;

/*
5. Write an SQL query to fetch the no. of workers for each department in the descending
order.
*/
SELECT DEPARTMENT, COUNT(*) AS No_of_worker
FROM Worker
GROUP BY DEPARTMENT
ORDER BY DEPARTMENT DESC;

/*
6. Write an SQL query to print details of the Workers who are also Managers.
*/
SELECT *
FROM Worker
INNER JOIN Title
ON Worker.WORKER_ID = Title.WORKER_REF_ID
WHERE Title.WORKER_TITLE IN('Manager');

/*
7. Write an SQL query to show only odd rows from a table.
*/
SELECT *
FROM Worker
WHERE WORKER_ID % 2 = 1;

/*
8. Write an SQL query to show only even rows from a table.
*/
SELECT *
FROM Worker
WHERE WORKER_ID % 2 = 0;

/*
9. Write an SQL query to clone a new table from another table.
*/
--1st method
SELECT *
INTO CloneTable
FROM Worker;

SELECT *
FROM CloneTable;

/*
Extra: If you want to clone only the structure (without data), you can do this
*/
SELECT *
INTO CloneTable2
FROM Worker
WHERE 1 = 0;

SELECT *
FROM CloneTable2;

/*
10. Write an SQL query to show the current date and time.
*/
SELECT GETDATE() AS CurrentDate;

/*
11. Write an SQL query to show the top n (say 5) records of a table with Name and
Designation
*/
SELECT TOP 5 W.FIRST_NAME + ' ' + W.LAST_NAME AS Full_name,
T.WORKER_TITLE AS Designation
FROM Worker W
INNER JOIN Title T
ON W.WORKER_ID = T.WORKER_REF_ID;

/*
12. Write an SQL query to determine the nth (say n=5) highest salary from a table.
*/
SELECT DISTINCT SALARY
FROM Worker
ORDER BY SALARY DESC
OFFSET 4 ROWS FETCH NEXT 1 ROWS ONLY;

/*
13. Write an SQL query to fetch the list of employees with the same salary.
*/
--1st method
SELECT *
FROM Worker
INNER JOIN
(SELECT SALARY 
FROM Worker
GROUP BY SALARY
HAVING COUNT(*) > 1
)AS Temp
ON Worker.SALARY = Temp.SALARY;

--2nd method
SELECT *
FROM Worker
WHERE SALARY IN
(SELECT SALARY 
FROM Worker
GROUP BY SALARY
HAVING COUNT(*) > 1
);

/*
Extra: Exact 2 people same salary(ঠিক ২ বার আছে)
*/
SELECT *
FROM Worker
INNER JOIN
(SELECT SALARY 
FROM Worker
GROUP BY SALARY
HAVING COUNT(*) = 2
)AS Temp
ON Worker.SALARY = Temp.SALARY;

/*
14. Write an SQL query to show the second highest salary from a table.
*/
--1st method
SELECT DISTINCT SALARY AS Second_highest_salary
FROM Worker
ORDER BY SALARY DESC
OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY;

--2nd method
SELECT *
FROM Worker
INNER JOIN
(SELECT DISTINCT SALARY
FROM Worker
ORDER BY SALARY DESC
OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY
) AS Temp
ON Worker.SALARY = Temp.SALARY;

/*
15. Write an SQL query to fetch the first 50% records from a table.
*/
--1st method
SELECT TOP 50 PERCENT *
FROM Worker;

--2nd method
SELECT TOP
(SELECT COUNT(*) / 2 FROM Worker) *
FROM Worker;

/*
16. Write an SQL query to fetch the departments that have less than five people in it.
*/
SELECT DEPARTMENT, COUNT(*) AS Total_count
FROM Worker
GROUP BY DEPARTMENT
HAVING COUNT(*) < 5;

/*
17. Write an SQL query to show all departments along with the number of people in there.
*/
SELECT DEPARTMENT, COUNT(*) AS No_Of_People
FROM Worker
GROUP BY DEPARTMENT;

/*
18. Write an SQL query to show the last record from table.
*/
SELECT TOP 1 *
FROM Worker
ORDER BY WORKER_ID DESC;

/*
19. Write an SQL query to fetch the first row of a table.
*/
SELECT TOP 1 *
FROM Worker;

/*
20. Write an SQL query to fetch the last five records from table
*/
--1st method
SELECT TOP 5 *
FROM Worker
ORDER BY WORKER_ID DESC

--2nd method
SELECT W.*
FROM Worker W
INNER JOIN
(SELECT TOP 5 WORKER_ID
FROM Worker
ORDER BY WORKER_ID DESC
) AS Temp
ON W.WORKER_ID = Temp.WORKER_ID
ORDER BY W.WORKER_ID;

/*
21. Write an SQL query to print the name of employees having the highest salary in each
department.
*/
SELECT W.FIRST_NAME + ' ' + W.LAST_NAME AS Full_Name,
Temp.DEPARTMENT, Temp.Highest_Salary
FROM Worker W
INNER JOIN
(SELECT DEPARTMENT, MAX(SALARY) AS Highest_Salary
FROM Worker
GROUP BY DEPARTMENT
) AS Temp
ON W.DEPARTMENT = Temp.DEPARTMENT AND W.SALARY = Temp.Highest_Salary;

/*
22. Write an SQL query to fetch three max salaries from table
*/
--1st method
SELECT DISTINCT TOP 3 SALARY AS Three_Max_Salaries
FROM Worker
ORDER BY SALARY DESC;

--2nd method
SELECT W.*, Temp.Three_Max_Salaries
FROM Worker W
INNER JOIN
(SELECT DISTINCT TOP 3 SALARY AS Three_Max_Salaries
FROM Worker
ORDER BY SALARY DESC
) AS Temp
ON W.SALARY = Temp.Three_Max_Salaries;


/*
EXTRA:
List all the employees who have maximum or minimum salary in each department
*/
SELECT W.*
FROM Worker W
INNER JOIN(
SELECT DEPARTMENT,
MAX(SALARY) AS Max_Salary,
MIN(SALARY) AS Min_Salary
FROM Worker
GROUP BY DEPARTMENT) AS Temp
ON W.DEPARTMENT = Temp.DEPARTMENT
AND (W.SALARY = Temp.Max_Salary OR W.SALARY = Temp.Min_Salary)
ORDER BY W.DEPARTMENT, W.SALARY;