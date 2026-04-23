-- ============================================================
-- Assignment 6: 40 Hive Commands Execution
-- Student Name  : Arin Zingade
-- Enrollment No : 0801IT221035
-- ============================================================

-- 1. Create a database
CREATE DATABASE IF NOT EXISTS assignment6_db;

-- Use the created database
USE assignment6_db;

-- Clean up existing tables for a fresh run
DROP TABLE IF EXISTS emp_internal;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS emp_external;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS emp_partitioned;

-- 4. Create an internal table (managed table)
CREATE TABLE IF NOT EXISTS emp_internal (
    id INT,
    name STRING,
    dept STRING,
    salary FLOAT,
    doj STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- 5. Create an external table
CREATE EXTERNAL TABLE IF NOT EXISTS emp_external (
    id INT,
    name STRING,
    dept STRING,
    salary FLOAT,
    doj STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LOCATION '/user/hive/external/employees';

-- 6. Show tables
SHOW TABLES;

-- 7. Describe table structure
DESCRIBE emp_internal;

-- 8. Describe table formatted (detailed info)
DESCRIBE FORMATTED emp_internal;

-- 9. Alter table - rename table
ALTER TABLE emp_internal RENAME TO employees;

-- 10. Alter table - add columns
ALTER TABLE employees ADD COLUMNS (age INT);

-- 11. Alter table - change column name/type
ALTER TABLE employees CHANGE salary monthly_salary FLOAT;

-- 12. Create a table for join (departments)
CREATE TABLE IF NOT EXISTS departments (
    dept_code STRING,
    dept_name STRING,
    location STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',';

-- 13. Describe the departments table
DESCRIBE departments;

-- 14. Load data into employees table (Local file)
LOAD DATA LOCAL INPATH 'data/employees.csv' OVERWRITE INTO TABLE employees;

-- 15. Load data into departments table (Local file)
LOAD DATA LOCAL INPATH 'data/departments.csv' OVERWRITE INTO TABLE departments;

-- 16. Select all from employees
SELECT * FROM employees;

-- 17. Select specific columns
SELECT name, dept, monthly_salary FROM employees;

-- 18. Select with LIMIT
SELECT * FROM employees LIMIT 3;

-- 19. Select with WHERE clause
SELECT * FROM employees WHERE monthly_salary > 50000;

-- 20. Select with LIKE (Pattern matching)
SELECT * FROM employees WHERE name LIKE 'A%';

-- 21. Select with ORDER BY (Global sort)
SELECT * FROM employees ORDER BY monthly_salary DESC;

-- 22. Select with SORT BY (Local sort within reducer)
SELECT * FROM employees SORT BY monthly_salary ASC;

-- 23. COUNT aggregate function
SELECT COUNT(*) FROM employees;

-- 24. SUM aggregate function
SELECT SUM(monthly_salary) FROM employees;

-- 25. AVG aggregate function
SELECT AVG(monthly_salary) FROM employees;

-- 26. MIN/MAX aggregate functions
SELECT MIN(monthly_salary), MAX(monthly_salary) FROM employees;

-- 27. GROUP BY clause
SELECT dept, COUNT(*) FROM employees GROUP BY dept;

-- 28. HAVING clause
SELECT dept, AVG(monthly_salary) FROM employees GROUP BY dept HAVING AVG(monthly_salary) > 40000;

-- 29. INNER JOIN
SELECT e.name, d.dept_name, d.location 
FROM employees e JOIN departments d ON (e.dept = d.dept_code);

-- 30. LEFT OUTER JOIN
SELECT e.name, d.dept_name 
FROM employees e LEFT JOIN departments d ON (e.dept = d.dept_code);

-- 31. RIGHT OUTER JOIN
SELECT e.name, d.dept_name 
FROM employees e RIGHT JOIN departments d ON (e.dept = d.dept_code);

-- 32. FULL OUTER JOIN
SELECT e.name, d.dept_name 
FROM employees e FULL OUTER JOIN departments d ON (e.dept = d.dept_code);

-- 33. UPPER and LOWER string functions
SELECT UPPER(name), LOWER(dept) FROM employees;

-- 34. CONCAT function
SELECT CONCAT(name, ' works in ', dept) FROM employees;

-- 35. TRUNC function (Year) / Date functions
SELECT id, name, doj, substr(doj, 1, 4) as year FROM employees;

-- 36. Create a partitioned table
CREATE TABLE IF NOT EXISTS emp_partitioned (
    id INT,
    name STRING,
    salary FLOAT
)
PARTITIONED BY (dept STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',';

-- 37. Insert data into partitioned table (Static Partitioning)
INSERT INTO TABLE emp_partitioned PARTITION(dept='IT') VALUES (10, 'Arin', 75000);

-- 38. Show partitions
SHOW PARTITIONS emp_partitioned;

-- 39. Drop a table
DROP TABLE IF EXISTS departments;

-- 40. Final Check
SHOW TABLES IN assignment6_db;
