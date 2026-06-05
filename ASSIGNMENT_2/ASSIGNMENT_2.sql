USE ASSIGNMENT_1;

/*
1. Allow NULL for all columns except WORKER_ID
*/
INSERT INTO Worker(WORKER_ID)
VALUES (222311057);

TRUNCATE TABLE Worker;

SELECT *
FROM Worker;

/*
2. Add constraints to check, while entering the SALARY value (i.e) SALARY > 100. 
*/
ALTER TABLE Worker
ADD CHECK(SALARY > 100);

INSERT INTO Worker(WORKER_ID, SALARY)
VALUES (2, 150);

/*
3. Define the field FIRST_NAME as UNIQUE. 
*/
ALTER TABLE Worker
ADD UNIQUE(FIRST_NAME);

INSERT INTO Worker(WORKER_ID, FIRST_NAME, SALARY)
VALUES (222311057, 'Sohel Rana', 200);