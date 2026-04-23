# Assignment 6: Hive Data Manipulation Commands

> **Subject:** Big Data  
> **Student Name:** Arin Zingade  
> **Enrollment No:** 0801IT221035

---

## Objective
To execute and document 40 essential Hive commands covering Data Definition Language (DDL), Data Manipulation Language (DML), and advanced querying.

## Commands Executed

| # | Command Type | Description | SQL Snippet |
|---|---|---|---|
| 1 | DDL | Create Database | `CREATE DATABASE IF NOT EXISTS assignment6_db;` |
| 2 | DDL | Show Databases | `SHOW DATABASES;` |
| 3 | Context | Use Database | `USE assignment6_db;` |
| 4 | DDL | Create Internal Table | `CREATE TABLE emp_internal (...);` |
| 5 | DDL | Create External Table | `CREATE EXTERNAL TABLE emp_external (...) LOCATION ...;` |
| 6 | DDL | Show Tables | `SHOW TABLES;` |
| 7 | DDL | Describe Table | `DESCRIBE employees;` |
| 8 | DDL | Formatted Describe | `DESCRIBE FORMATTED employees;` |
| 9 | DDL | Rename Table | `ALTER TABLE emp_internal RENAME TO employees;` |
| 10 | DDL | Add Column | `ALTER TABLE employees ADD COLUMNS (age INT);` |
| 11 | DDL | Change Column | `ALTER TABLE employees CHANGE salary monthly_salary FLOAT;` |
| 12 | DDL | Create Table (Join) | `CREATE TABLE departments (...);` |
| 13 | DDL | Describe Join Table | `DESCRIBE departments;` |
| 14 | DML | Load Data (Local) | `LOAD DATA LOCAL INPATH ... INTO TABLE employees;` |
| 15 | DML | Load Data (Local) | `LOAD DATA LOCAL INPATH ... INTO TABLE departments;` |
| 16 | DQL | Select All | `SELECT * FROM employees;` |
| 17 | DQL | Select Columns | `SELECT name, dept FROM employees;` |
| 18 | DQL | Limit | `SELECT * FROM employees LIMIT 3;` |
| 19 | DQL | Where Clause | `SELECT * FROM employees WHERE monthly_salary > 50000;` |
| 20 | DQL | Like Pattern | `SELECT * FROM employees WHERE name LIKE 'A%';` |
| 21 | DQL | Order By | `SELECT * FROM employees ORDER BY monthly_salary DESC;` |
| 22 | DQL | Sort By | `SELECT * FROM employees SORT BY monthly_salary ASC;` |
| 23 | Agg | Count | `SELECT COUNT(*) FROM employees;` |
| 24 | Agg | Sum | `SELECT SUM(monthly_salary) FROM employees;` |
| 25 | Agg | Average | `SELECT AVG(monthly_salary) FROM employees;` |
| 26 | Agg | Min/Max | `SELECT MIN(salary), MAX(salary) FROM employees;` |
| 27 | Agg | Group By | `SELECT dept, COUNT(*) FROM employees GROUP BY dept;` |
| 28 | Agg | Having | `... GROUP BY dept HAVING AVG(salary) > 40000;` |
| 29 | Join | Inner Join | `SELECT ... FROM employees JOIN departments ...;` |
| 30 | Join | Left Join | `SELECT ... FROM employees LEFT JOIN departments ...;` |
| 31 | Join | Right Join | `SELECT ... FROM employees RIGHT JOIN departments ...;` |
| 32 | Join | Full Outer Join | `SELECT ... FROM employees FULL OUTER JOIN departments ...;` |
| 33 | Func | Upper/Lower | `SELECT UPPER(name), LOWER(dept) FROM employees;` |
| 34 | Func | Concat | `SELECT CONCAT(name, ' in ', dept) FROM employees;` |
| 35 | Func | Substring | `SELECT substr(doj, 1, 4) FROM employees;` |
| 36 | DDL | Partitioned Table | `CREATE TABLE ... PARTITIONED BY (dept STRING);` |
| 37 | DML | Static Partition | `INSERT INTO TABLE ... PARTITION(dept='IT') ...;` |
| 38 | DDL | Show Partitions | `SHOW PARTITIONS emp_partitioned;` |
| 39 | DDL | Drop Table | `DROP TABLE IF EXISTS emp_external;` |
| 40 | DDL | Final Check | `SHOW TABLES IN assignment6_db;` |

---

## Conclusion
Executed 40 Hive commands successfully on a single-node Hadoop cluster, demonstrating complete control over data life cycle in Apache Hive.
