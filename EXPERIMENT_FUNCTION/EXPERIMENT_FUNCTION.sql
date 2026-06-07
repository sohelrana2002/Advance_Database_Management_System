CREATE DATABASE FunctionDB;

USE FunctionDB;

--employee table
CREATE TABLE Employee(
EMP_ID INT PRIMARY KEY,
FIRST_NAME VARCHAR(40),
LAST_NAME VARCHAR(40),
SALARY INT,
DEPT VARCHAR(40)
);

INSERT INTO Employee(EMP_ID, FIRST_NAME, LAST_NAME, SALARY, DEPT)
VALUES
(1, 'Rajesh', 'Sharma', 55000, 'IT'),
(2, 'Priya', 'Verma', 62000, 'HR'),
(3, 'Amit', 'Patel', 48000, 'Sales'),
(4, 'Sneha', 'Reddy', 71000, 'IT'),
(5, 'Vikram', 'Singh', 53000, 'Marketing'),
(6, 'Anjali', 'Gupta', 49500, 'HR');

SELECT *
FROM Employee;


--user-defined scaler function example
CREATE FUNCTION GetEmpFullName(
@First_Name VARCHAR(50),
@Last_Name VARCHAR(50)
)
RETURNS VARCHAR(110)
AS
BEGIN
	RETURN (SELECT @First_Name + ' ' + @Last_Name);
END;
	
--call the function
SELECT dbo.GetEmpFullName(FIRST_NAME, LAST_NAME) AS Full_Name,
SALARY, DEPT
FROM Employee


--simple example
CREATE FUNCTION CalculateSalary(@Salary FLOAT)
RETURNS FLOAT
AS
BEGIN
	DECLARE @MaxSalary FLOAT
	SET @MaxSalary = (@Salary) * 100

	RETURN @MaxSalary
END;

--Call the function
SELECT dbo.CalculateSalary(2000) AS Max_Salary;



--calculate highest salary using user define scalar function
CREATE FUNCTION CalculateHighestSalary()
RETURNS INT
AS
BEGIN
	DECLARE @MaxSalary INT
	SELECT @MaxSalary = MAX(SALARY) FROM Employee

	RETURN @MaxSalary
END;

--Call the function
SELECT dbo.CalculateHighestSalary() AS Max_Salary;


--calculate highest salary by deptname using user define scalar function
CREATE FUNCTION GetMaxSalaryByDept(@Dept_Name VARCHAR(40))
RETURNS INT
AS
BEGIN
	DECLARE @Max_Salary INT
	SELECT @Max_Salary = MAX(SALARY)
	FROM Employee
	WHERE DEPT = @Dept_Name

	RETURN @Max_Salary
END;

--Call the function
SELECT dbo.GetMaxSalaryByDept('HR') AS Max_Salary;


--Inline Table-Valued Functions
CREATE FUNCTION GetEmployee()
RETURNS TABLE
AS
RETURN (SELECT * FROM Employee);

--Call the function
SELECT * 
FROM dbo.GetEmployee();


--get employee by dept
CREATE FUNCTION GetEmployeeByDept(@Dept_Name VARCHAR(40))
RETURNS TABLE
AS
RETURN (
	SELECT *
	FROM Employee
	WHERE DEPT = @Dept_Name
);

--Call the function
SELECT *
FROM dbo.GetEmployeeByDept('IT');


--Multi-Statement Table-Valued Functions
CREATE FUNCTION GetMulEmployee()
RETURNS @Emp TABLE(
EmpId INT,
FirstName VARCHAR(40),
Salary INT
)
AS
BEGIN
	INSERT INTO @Emp SELECT E.EMP_ID, E.FIRST_NAME, E.SALARY FROM Employee E;

	--now update salary of firt employee
	UPDATE @Emp
	SET Salary = 30000
	WHERE EmpId = 1;

	--It will update only in @Emp table not in Original Employee table
	RETURN
END;

--Call the function
SELECT *
FROM GetMulEmployee();


--Example 2
CREATE FUNCTION GetDeptState(@MinTotalSalary INT)
RETURNS @DeptState TABLE(
DeptName VARCHAR(40),
TotalSalary INT,
EmpCount INT
)
AS
BEGIN
	INSERT INTO @DeptState
	SELECT DEPT, SUM(SALARY), COUNT(*)
	FROM Employee
	GROUP BY DEPT;

	DELETE FROM @DeptState
	WHERE TotalSalary < @MinTotalSalary;

	RETURN
END;

--Call the function
SELECT *
FROM GetDeptState(50000);



--Actual query
--Management Table
CREATE TABLE Tbl_Management (
    Mgt_id VARCHAR(10) PRIMARY KEY,
    Mgt_Name VARCHAR(50),
    Joining_date DATE,
    Salary INT,
    Position VARCHAR(50)
);

INSERT INTO Tbl_Management (Mgt_id, Mgt_Name, Joining_date, Salary, Position) VALUES
('M2015', 'Keshob', '2001-01-18', 250000, 'Managing Director'),
('M2016', 'Rana', '2003-01-30', 180000, 'Secretary'),
('M2017', 'Jasim', '2004-04-12', 150000, 'Join secretary'),
('M2018', 'Rajon', '2004-06-18', 140000, 'Join secretary');

-- Employee Table
CREATE TABLE Tbl_Emp (
    Emp_id VARCHAR(10) PRIMARY KEY,
    Emp_Name VARCHAR(50),
    Joining_Date DATE,
    Salary INT,
    Division VARCHAR(50)
);

INSERT INTO Tbl_Emp (Emp_id, Emp_Name, Joining_Date, Salary, Division) VALUES
('E1001', 'Suman', '2003-04-25', 92000, 'Software'),
('E1002', 'Rasel', '2004-03-13', 86000, 'Network'),
('E1003', 'Hossain', '2004-06-21', 82000, 'Software'),
('E1004', 'polash', '2005-05-05', 9800, 'Network');


-- Project Table
CREATE TABLE Tbl_Project (
    P_id VARCHAR(10) PRIMARY KEY,
    P_Name VARCHAR(100),
    Mgt_id VARCHAR(10) FOREIGN KEY REFERENCES Tbl_Management(Mgt_id),
    E_id VARCHAR(10) FOREIGN KEY REFERENCES Tbl_Emp(Emp_id),
    P_Cost INT,
    Delivery_date DATE
);

INSERT INTO Tbl_Project (P_id, P_Name, Mgt_id, E_id, P_Cost, Delivery_date) VALUES
('P3001', 'Office Automation', 'M2016', 'E1001', 2050000, '2016-05-08'),
('P3002', 'Repair Hub', 'M2016', 'E1004', 1200000, '2017-06-14'),
('P3003', 'Server Installation', 'M2018', 'E1001', 1500500, '2018-02-13'),
('P3004', 'Network setup', 'M2017', 'E1002', 2505000, '2018-03-12');


SELECT *
FROM Tbl_Management;

SELECT *
FROM Tbl_Emp;

SELECT *
FROM Tbl_Project;


/*
2. Write a sql create UDF query to show Project name, cost and assign employee name and
rearrange the project according to cost ascending order. Where Project name and
employee name pass by parameter.
*/
CREATE FUNCTION fnGetProjectDetails(
@Project_Name VARCHAR(50),
@Employee_Name VARCHAR(50)
)
RETURNS TABLE
AS
RETURN
(
	SELECT TP.P_Name, TP.P_Cost, TE.Emp_Name
	FROM Tbl_Project TP
	INNER JOIN Tbl_Emp TE
	ON TP.E_id = TE.Emp_id
	WHERE TP.P_Name = @Project_Name
	AND TE.Emp_Name = @Employee_Name
	ORDER BY TP.P_Cost ASC OFFSET 0 ROWS
);

--call the function
SELECT *
FROM fnGetProjectDetails('Office Automation', 'Suman');


/*
4. Write a sql create scalar function that has one parameter. In this function calculate the
Salary of employee whose salary is maximum and that salary increase 10%. Where salary
column pass by parameter 
*/
CREATE FUNCTION fnCalculateSalaryOfEmployee(@Max_Salary INT)
RETURNS INT
AS
BEGIN
	RETURN @Max_Salary * 1.10
END;

--call the function
SELECT dbo.fnCalculateSalaryOfEmployee(MAX(Salary)) AS IncreaseMaxSalary
FROM Tbl_Emp;


/*
5. Write a sql UDF to show the Name of maximum Cost Project.
*/
CREATE FUNCTION fnMaxCostProjectName()
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @Project_Name VARCHAR(100);

	SELECT @Project_Name = P_Name
	FROM Tbl_Project
	WHERE P_Cost = (SELECT MAX(P_Cost) FROM Tbl_Project);

	RETURN @Project_Name;
END;

--call the function
SELECT dbo.fnMaxCostProjectName() AS MaxCostProjectName;


/*
6. Write a sql Inline Table Valued function to show the Project name and Cost where cost in
between 1200000 and 2050000. Costs are passed by parameter
*/
CREATE FUNCTION fnGetProjectInfo(
@MinCost INT,
@MaxCost INT
)
RETURNS TABLE
AS
RETURN
(
	SELECT P_Name, P_Cost
	FROM Tbl_Project
	WHERE P_Cost BETWEEN @MinCost AND @MaxCost
);

--call the function
SELECT *
FROM fnGetProjectInfo(1200000, 2050000);


/*
7. Create Inline Function like “fnEmployee”, in this function find the Mgt_id, Mgt_Name,
Emp_Name, Joining_Date, Salary, P_Name, P_Cost, Delivery_date. Where P_id, Mgt_id,
Emp_id pass by parameter
*/
CREATE FUNCTION fnEmployee(
@PP_id VARCHAR(30),
@MMgt_id VARCHAR(30),
@EEmp_id VARCHAR(30)
)
RETURNS TABLE
AS
RETURN
(
	SELECT TM.Mgt_id, TM.Mgt_Name, TE.Emp_Name, TE.Joining_Date, 
	TE.Salary,TP.P_Name, TP.P_Cost, TP.Delivery_date
	FROM Tbl_Project TP
	INNER JOIN Tbl_Management TM
	ON TP.Mgt_id = TM.Mgt_id
	INNER JOIN Tbl_Emp TE
	ON TP.E_id = TE.Emp_id
	WHERE TP.P_id = @PP_id AND (TM.Mgt_id = @MMgt_id AND TE.Emp_id = @EEmp_id)
);

--call the function
SELECT *
FROM fnEmployee('P3001', 'M2016', 'E1001');