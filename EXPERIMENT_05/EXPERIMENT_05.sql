CREATE DATABASE EXPERIMENT_05;

USE EXPERIMENT_05;

CREATE TABLE TeacherInfo(
TID INT,
FirstName VARCHAR(30),
LastName VARCHAR(30),
Dept VARCHAR(30),
Age INT,
Salary INT
);

INSERT INTO TeacherInfo(TID, FirstName, LastName, Dept, Age, Salary)
VALUES
(1, 'Mizanur', 'Rahman', 'CSE', 28, 35000),
(2, 'Delwar', 'Hossain', 'CSE', 26, 33000),
(3, 'Shafiul', 'Islam', 'EEE', 24, 30000),
(4, 'Faisal', 'Imran', 'CSE', 30, 50000),
(5, 'Ahsan', 'Habib', 'English', 28, 28000);


CREATE TABLE TeacherMoreInfo(
deptID INT,
deptName VARCHAR(30),
location VARCHAR(30)
);

INSERT INTO TeacherMoreInfo(deptID, deptName, location)
VALUES
(1, 'CSE', 'Talaimari'),
(2, 'EEE', 'Talaimari'),
(3, 'English', 'Kazla'),
(4, 'BBA', 'Talaimari');



SELECT *
FROM TeacherInfo;

TRUNCATE TABLE TeacherInfo;

SELECT *
FROM TeacherMoreInfo;


/*
1. Update the Salary of Teacher by 15% whose DeptName is ‘CSE, otherwise update by
10% Salary.
*/
--1st method
UPDATE TeacherInfo
SET Salary = Salary * (
	CASE
		WHEN Dept = 'CSE' THEN 1.15
		ELSE 1.10
	END
);

--2nd method
UPDATE TI
SET TI.Salary = TI.Salary * (
	CASE
		WHEN TMI.deptName = 'CSE' THEN 1.15
		ELSE 1.10
	END
)
FROM TeacherInfo TI
INNER JOIN TeacherMoreInfo TMI
ON TI.Dept = TMI.deptName;


/*
2. Write a query to insert/copy the values of all attributes from one table to another using
(ID in) subquery.
*/
SELECT *
INTO CopyTable
FROM TeacherInfo
WHERE TID IN(SELECT TID FROM TeacherInfo);

SELECT *
FROM CopyTable;

/*
3. Write a query to find firstname and lastname as fullname , age whose salary is
maximum.
*/
--1st method
SELECT FirstName + ' ' + LastName AS FullName, Age
FROM TeacherInfo
WHERE Salary = (SELECT MAX(Salary) FROM TeacherInfo);

--2nd method
SELECT T.FirstName + ' ' + T.LastName AS FullName, T.Age
FROM TeacherInfo T
INNER JOIN
(SELECT MAX(Salary) AS Max_Salary
FROM TeacherInfo
) AS Temp
ON T.Salary = Temp.Max_Salary;

--3rd method
SELECT TOP 1 T.FirstName + ' ' + T.LastName AS FullName, T.Age
FROM TeacherInfo T
ORDER BY T.Salary DESC;

/*
4. Write a query to find firstname, age,dept whose age is between 23 to 27.
*/
SELECT T.FirstName, T.Age, T.Dept
FROM TeacherInfo T
WHERE T.Age BETWEEN 23 AND 27;

/*
5. Write a query to find TID,firstname whose salary is less than average salary.
*/
SELECT TID, FirstName, Salary
FROM TeacherInfo
WHERE Salary < (SELECT AVG(Salary) FROM TeacherInfo);

/*
Extra: Write a query to delete all ID where age is greater than 25 using subquery
*/
DELETE
FROM TeacherInfo
WHERE Age IN(SELECT Age FROM TeacherInfo WHERE Age > 25);

/*
6. Write a query to update Dept by ‘English’ where Dept is ‘EEE’ using subquery.
*/
--1st method
UPDATE TeacherInfo
SET Dept = 'English'
WHERE Dept = (SELECT Dept FROM TeacherInfo WHERE Dept = 'EEE');

--2nd method
UPDATE TeacherInfo
SET Dept = 'English'
WHERE Dept IN(SELECT Dept FROM TeacherInfo WHERE Dept = 'EEE');

/*
7. Write a query to update salary by multiplying the salary by 10 where salary is
greater than 40000 using subquery.
*/
UPDATE TeacherInfo
SET Salary = Salary * 100
WHERE Salary IN(SELECT Salary FROM TeacherInfo WHERE Salary > 40000);

/*
8. Write a query to find the name that starts with ‘k/s’ using a subquery.
*/
SELECT *
FROM TeacherInfo
WHERE FirstName IN(
		SELECT FirstName 
		FROM TeacherInfo 
		WHERE FirstName LIKE 'k%' 
		OR FirstName LIKE 's%'
);

/*
9. Find the Firstname,salary for all the teachers of CSE who have a higher salary than
Delwar Hossain using subquery.
*/
SELECT FirstName, Salary
FROM TeacherInfo
WHERE Dept = 'CSE' AND Salary > (
		SELECT Salary
		FROM TeacherInfo
		WHERE FirstName = 'Delwar'
		AND LastName = 'Hossain'
);

/*
10. Find out the id,names of all teachers who belong to the same department as the
teacher ‘Mizanur’ .
*/
SELECT TID, FirstName + ' ' + LastName AS Full_Name
FROM TeacherInfo
WHERE Dept = (
	SELECT Dept
	FROM TeacherInfo
	WHERE FirstName = 'Mizanur'
);

/*
11. Find TID, salary, deptID whose salary is greater than average salary
*/
SELECT TI.TID, TI.Salary, TMI.deptID
FROM TeacherInfo TI
INNER JOIN TeacherMoreInfo TMI
ON TI.Dept = TMI.deptName
WHERE TI.Salary > (SELECT AVG(Salary) FROM TeacherInfo);

/*
12. Find min salary from Teacher for each department where min salary is less than
average salary
*/
SELECT T.Dept, Temp.Min_Salary
FROM TeacherInfo T
INNER JOIN
(SELECT Dept,
MIN(Salary) AS Min_Salary
FROM TeacherInfo
GROUP BY Dept
) AS Temp
ON T.Dept = Temp.Dept AND T.Salary = Temp.Min_Salary
WHERE Temp.Min_Salary < (SELECT AVG(Salary) FROM TeacherInfo);

/*
Extra: Find min salary from Teacher for each department where min salary is less 
than department average salary
*/
SELECT T.Dept, Temp.Min_Salary
FROM TeacherInfo T
INNER JOIN
(SELECT Dept,
MIN(Salary) AS Min_Salary,
AVG(Salary) AS Avg_Salary
FROM TeacherInfo
GROUP BY Dept
) AS Temp
ON T.Dept = Temp.Dept AND T.Salary = Temp.Min_Salary
WHERE Temp.Min_Salary < Temp.Avg_Salary;

/*
13. Find firstname,lastname,Dept where location name is Kazla using subquery.
*/
--1st method
SELECT T.FirstName, T.LastName, T.Dept
FROM TeacherInfo T
INNER JOIN TeacherMoreInfo TMI
ON T.Dept = TMI.deptName
WHERE TMI.location IN(
	SELECT location
	FROM TeacherMoreInfo
	WHERE location = 'Kazla'
);

--2nd method
SELECT FirstName, LastName, Dept
FROM TeacherInfo
WHERE Dept IN(
	SELECT deptName
	FROM TeacherMoreInfo
	WHERE location = 'Kazla'
);

/*
14. Write a query to find the TID,firsname,salary where the length of the firstname is at
least 6.
*/
SELECT TID, FirstName, Salary
FROM TeacherInfo
WHERE LEN(FirstName) >= 6;