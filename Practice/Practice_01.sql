CREATE DATABASE Practice;

USE Practice;

CREATE TABLE EmployeeInfo(
ID INT,
NAME VARCHAR(30),
SALARY INT,
GENDER VARCHAR(30),
DEPARTMENT_ID INT
);

DROP TABLE EmployeeInfo;

INSERT INTO EmployeeInfo(ID, NAME, SALARY, GENDER, DEPARTMENT_ID)
VALUES
(1, 'John', 5000, 'Male', 3),
(2, 'Mikey', NULL, 'Male', 2),
(3, 'Pam', 6000, 'Female', 1),
(4, 'Todd', 4800, 'Male', 4),
(5, 'Ben', 3200, 'Male', 3);

CREATE TABLE DepartmentInfo(
DEPT_ID INT,
DEPT_NAME VARCHAR(30)
);

INSERT INTO DepartmentInfo(DEPT_ID, DEPT_NAME)
VALUES
(1, 'IT'),
(2, 'Payroll'),
(3, 'HR'),
(4, 'Admin');

SELECT *
FROM DepartmentInfo;

SELECT *
FROM EmployeeInfo;

ALTER VIEW v_Employee_Info
AS
SELECT ID, SALARY, NAME, GENDER, D.DEPT_NAME
FROM EmployeeInfo
INNER JOIN DepartmentInfo D
ON EmployeeInfo.DEPARTMENT_ID = D.DEPT_ID;

SELECT *
FROM v_Employee_Info;

UPDATE v_Employee_Info
SET DEPT_NAME = 'IT'
WHERE NAME = 'John';

CREATE VIEW vw_Employee_Info
AS
SELECT *
FROM EmployeeInfo;

SELECT *
FROM vw_Employee_Info;

UPDATE vw_Employee_Info
SET SALARY = 6000
WHERE NAME = 'John';