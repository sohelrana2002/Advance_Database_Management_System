USE ASSIGNMENT_1;

/*
1. Insert at least 10 rows in the table.
*/
INSERT INTO Worker(WORKER_ID, FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT, JOINING_DATE)
VALUES
(1, 'Rana', 'Hamid', 100000, 'HR', '2014-02-20 09:00:00'),
(2, 'Sanjoy', 'Saha', 80000, 'Admin', '2014-06-11 09:00:00'),
(3, 'Mahmudul', 'Hasan', 300000, 'HR', '2014-02-20 09:00:00'),
(4, 'Asad', 'Zaman', 500000, 'Admin', '2014-02-20 09:00:00'),
(5, 'Sajib', 'Mia', 500000, 'Admin', '2014-06-11 09:00:00'),
(6, 'Alamgir', 'Kabir', 200000, 'Account', '2014-06-11 09:00:00'),
(7, 'Foridul', 'Islam', 75000, 'Account', '2014-01-20 09:00:00'),
(8, 'Keshob' ,'Ray', 90000, 'Admin' , '2014-04-11 09:00:00');

/*
2. Display all the information of WORKER table
*/
SELECT *
FROM Worker;

/*
3. Display all the information of 1st 5 employees of WORKER table with
FIRST_NAME + LAST_NAME as FULL_NAME.
*/
SELECT FIRST_NAME + ' ' + LAST_NAME AS Full_Name, SALARY, DEPARTMENT, JOINING_DATE
FROM Worker

/*
4. Display the complete record of employees working in Admin Department
*/
SELECT *
FROM Worker
WHERE DEPARTMENT = 'Admin';

/*
5. Find the name of employees whose salary is greater than 10000 
*/
SELECT *
FROM Worker
WHERE SALARY > 10000;

/*
6. Write down the SQL Query to find out whose salary is greater than Sanjoy
*/
SELECT *
FROM Worker
WHERE SALARY > (SELECT SALARY FROM Worker WHERE FIRST_NAME = 'Sanjoy');

/*
7. Update the Salary of Worker by 95000 whose ID is 8 .
*/
UPDATE Worker
SET SALARY = 95000
WHERE WORKER_ID = 8;

/*
8. Delete the record of employee whose FIRST_NAME is Asad
*/
DELETE
FROM Worker
WHERE FIRST_NAME = 'Asad';