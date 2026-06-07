CREATE DATABASE StoreProcedureDB;

USE StoreProcedureDB;

--Branch table
CREATE TABLE Branch(
Br_Id VARCHAR(30) PRIMARY KEY,
Branch_Name VARCHAR(40),
);

INSERT INTO Branch(Br_Id, Branch_Name)
VALUES 
('B-101','Bonani'),
('B-102','Romna'),
('B-103', 'Shaheb bazar'),
('B-104', 'Ullapara');

SELECT *
FROM Branch;

--Zone table
CREATE TABLE Zone(
Zone_Id VARCHAR(40) PRIMARY KEY,
Name VARCHAR(40),
);

INSERT INTO Zone(Zone_Id, Name)
VALUES 
('Z-801','Sirajgonj' ),
('Z-802','Rajshahi'),
('Z-803','Dhaka'),
('Z-804','Chittagong');

SELECT *
FROM Zone;

--Account_Detail table
CREATE TABLE Account_Detail(
Account_no INT PRIMARY KEY,
Acc_holder_name VARCHAR(40),
Amount INT,
Branch_Id VARCHAR(30) FOREIGN KEY REFERENCES Branch(Br_Id),
Zone_Id VARCHAR(40) FOREIGN KEY REFERENCES Zone(Zone_Id),
);

INSERT INTO Account_Detail( Account_no, Acc_holder_name, Amount,Branch_Id, Zone_Id)
VALUES
(1992212,'Mr. Nazmuzzaman',200000,'B-101', 'Z-803'),
(1992213,'Mr. Jibon', 170000, 'B-102', 'Z-803'), 
(1882212, 'Bushra',180000,'B-103', 'Z-802'), 
(1882213, 'Sajib', 170000, 'B-104', 'Z-801');

SELECT *
FROM Account_Detail;

/*
1. Create a simple stored procedure “SPdetails” to find Acc_holder_name, Amount,
Branch_Name and Zone_Name.
*/
CREATE PROC SPdetails
AS
BEGIN
	SELECT AD.Acc_holder_name, AD.Amount, B.Branch_Name, Z.Name AS ZoneName
	FROM Account_Detail AD
	INNER JOIN Branch B
	ON AD.Branch_Id = B.Br_Id
	INNER JOIN Zone Z
	ON AD.Zone_Id = Z.Zone_Id
END;

EXEC SPdetails;

/*
2. Create a simple stored procedure “SPaverage” to find Branch _name and Amount of
Branch where amount will be greater than particular amount (say 17000). Here
branch_name and amount will be passed by parameter
*/
CREATE PROC SPaverage
@BranchName VARCHAR(40),
@Amount INT
AS
BEGIN
	SELECT B.Branch_Name, AD.Amount
	FROM Branch B
	INNER JOIN Account_Detail AD
	ON B.Br_Id = AD.Branch_Id
	WHERE B.Branch_Name = @BranchName AND AD.Amount > @Amount
END;

EXEC SPaverage 'Bonani', 17000;

--exec another method
EXEC SPaverage @Amount = 17000, @BranchName = 'Bonani';

/*
3. Create a simple stored procedure “SPbalance” to find Amount of a particular zone. Here
zone name will be passed by parameter and amount will be shown by using return value().
*/
CREATE PROC SPbalance
@ZoneName VARCHAR(40)
AS
BEGIN
	DECLARE @TotalAmount INT

	SELECT @TotalAmount = ISNULL(SUM(AD.Amount), 0)
	FROM Account_Detail AD
	INNER JOIN Zone Z
	ON AD.Zone_Id = Z.Zone_Id
	WHERE Z.Name = @ZoneName
	
	RETURN @TotalAmount
END;

--How to drop proc
DROP PROC SPbalance

--execute the proc
DECLARE @Amount INT
EXEC @Amount = SPbalance 'Rajshahi'

IF @Amount > 1000
	PRINT 'Amount is greater than 1000, Amount: ' +  CAST(@Amount AS VARCHAR(10))
ELSE
	PRINT 'Amount is less than 1000, Amount: ' +  CAST(@Amount AS VARCHAR(10));


/*
4. Create a simple stored procedure “SPamount” to Find all account holders name with their
branch name and zone name whose name has substring ‘Mr.’ and Amount Less than
Maximum Amount
*/
CREATE PROC SPamount
AS
BEGIN
	SELECT AD.Acc_holder_name, B.Branch_Name, Z.Name AS ZoneName
	FROM Account_Detail AD
	INNER JOIN Branch B
	ON AD.Branch_Id = B.Br_Id
	INNER JOIN Zone Z
	ON AD.Zone_Id = Z.Zone_Id
	WHERE AD.Acc_holder_name LIKE '%Mr.%'
	AND AD.Amount < (SELECT MAX(Amount) FROM Account_Detail)
END;

EXEC SPamount;

/*
5. Create a simple stored procedure “SPdetailsInfo” to find number of customer of each
Zone. Here number of customers need to be printed as output parameter and zone_name
will be passed as parameter
*/
CREATE PROC SPdetailsInfo
@ZoneName VARCHAR(40),
@TotalCustomer INT OUTPUT
AS
BEGIN
	SELECT @TotalCustomer = COUNT(*)
	FROM Account_Detail AD
	INNER JOIN Zone Z
	ON AD.Zone_Id = Z.Zone_Id
	WHERE Z.Name = @ZoneName
END;

--drop statement
DROP PROC SPdetailsInfo

--execute the proc with output parameter
DECLARE @TotalCount INT
EXEC SPdetailsInfo 'Rajshahi', @TotalCount OUTPUT

PRINT 'Number of customer in Rajshahi zone: ' + CAST(@TotalCount AS VARCHAR(30));

/*
6. Create procedure like “spEmployeeSalaryDetails1” which has four parameter. three
parameter match the StartAmount, EndAmount value, Branch_Name Value and another
parameter return this value, in this procedure find the number of Branch_Name
where StartAmount, EndAmount value, Branch_Name value pass by parameter. 
*/
CREATE PROC spEmployeeSalaryDetails1
@StartAmount INT,
@EndAmount INT,
@BranchName VARCHAR(30),
@TotalCount INT OUTPUT
AS
BEGIN
	SELECT @TotalCount =  COUNT(*)
	FROM Account_Detail AD
	INNER JOIN Branch B
	ON AD.Branch_Id = B.Br_Id
	WHERE B.Branch_Name = @BranchName
	AND AD.Amount BETWEEN @StartAmount AND @EndAmount
END;

--execute the proc with output parameter
DECLARE @Result INT
EXEC spEmployeeSalaryDetails1 150000, 200000, 'Romna', @Result OUTPUT

PRINT 'Number of account in Romna: ' + CAST(@Result AS VARCHAR(30));

/*
7. Create a simple stored procedure “SPdetailsInfo2” to find Zone_name, number of customer
of a specific Zone.
*/
CREATE PROC SPdetailsInfo2
@ZoneName VARCHAR(30)
AS
BEGIN
	SELECT Z.Name AS ZoneName, COUNT(*) AS NumberOfCustomers
	FROM Account_Detail AD
	INNER JOIN Zone Z
	ON AD.Zone_Id = Z.Zone_Id
	WHERE Z.Name = @ZoneName
	GROUP BY Z.Name
END;

--drop statement
DROP PROC SPdetailsInfo2

--execute the pro
EXEC SPdetailsInfo2 'Dhaka';

/*
8. Create a simple stored procedure “SPdetailsInfo3” to find Zone_name, number of
Branch of a specific Zone(Zone name pass by parameter). 
*/
CREATE PROC SPdetailsInfo3
@ZoneName VARCHAR(40)
WITH ENCRYPTION
AS
BEGIN
	SELECT Z.Name AS ZoneName, COUNT(AD.Branch_Id) AS NumberOfBranchs
	FROM Account_Detail AD
	INNER JOIN Zone Z
	ON AD.Zone_Id = Z.Zone_Id
	WHERE Z.Name = @ZoneName
	GROUP BY Z.Name
END;

--execute the pro
EXEC SPdetailsInfo3 'Dhaka';