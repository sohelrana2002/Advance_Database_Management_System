CREATE DATABASE ASSIGNMENT_1

USE ASSIGNMENT_1;

/*
1. Create a table Worker with following schema:
(WORKER_ID(PK), FIRST_NAME, LAST_NAME, SALARY, DEPT_NAME)
*/
CREATE TABLE Worker(
WORKER_ID INT PRIMARY KEY,
FIRST_NAME VARCHAR(30),
LAST_NAME VARCHAR(30),
SALARY INT,
DEPT_NAME VARCHAR(30),
);


/*
2. Add a new column; JOINING_DATE to the existing relation.
*/
ALTER TABLE Worker
ADD JOINING_DATE VARCHAR(30);


/*
3. Change the datatype of SALARY.
*/
ALTER TABLE Worker
ALTER COLUMN SALARY INT;


/*
4. Change the name of column/field DEPT_NAME to DEPARTMENT.
*/
EXEC sp_rename 'Worker.DEPT_NAME', 'DEPARTMENT', 'COLUMN';


/*
5. Modify the column width of the DEPARTMENT field of EMPLOYEE table
*/
ALTER TABLE Worker
ALTER COLUMN DEPARTMENT VARCHAR(40);