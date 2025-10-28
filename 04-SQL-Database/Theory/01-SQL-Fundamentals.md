# SQL Fundamentals for Capital Markets

## Table of Contents
1. [Introduction to SQL](#introduction-to-sql)
2. [Database Concepts](#database-concepts)
3. [SQL Basics](#sql-basics)
4. [SELECT Statements](#select-statements)
5. [Filtering and Sorting](#filtering-and-sorting)
6. [Aggregate Functions](#aggregate-functions)

---

## Introduction to SQL

### What is SQL?
**SQL** (Structured Query Language) is the standard language for managing and manipulating relational databases.

### Key Characteristics
- **Declarative**: Specify what you want, not how to get it
- **Standardized**: Works across different database systems
- **Powerful**: Handle complex data operations
- **Efficient**: Optimized for large datasets

### Common Database Systems
- **Oracle**: Enterprise-grade, common in finance
- **PostgreSQL**: Open-source, feature-rich
- **MySQL/MariaDB**: Popular open-source
- **Microsoft SQL Server**: Windows-integrated
- **SQLite**: Lightweight, embedded

---

## Database Concepts

### Relational Database
Data organized in tables (relations) with rows and columns.

```
trades Table:
+----------+--------+----------+--------+
| trade_id | symbol | quantity | price  |
+----------+--------+----------+--------+
| T0001    | AAPL   | 100      | 175.50 |
| T0002    | GOOGL  | 50       | 140.25 |
+----------+--------+----------+--------+
```

### Key Terms
- **Table**: Collection of related data
- **Row (Record)**: Single entry in a table
- **Column (Field)**: Specific attribute
- **Primary Key**: Unique identifier for rows
- **Foreign Key**: References another table
- **Index**: Improves query performance
- **Schema**: Structure/organization of database

---

## SQL Basics

### SQL Statement Categories

**DDL (Data Definition Language)**:
```sql
CREATE TABLE    -- Create new table
ALTER TABLE     -- Modify table structure
DROP TABLE      -- Delete table
```

**DML (Data Manipulation Language)**:
```sql
SELECT          -- Query data
INSERT          -- Add new records
UPDATE          -- Modify existing records
DELETE          -- Remove records
```

**DCL (Data Control Language)**:
```sql
GRANT           -- Give permissions
REVOKE          -- Remove permissions
```

**TCL (Transaction Control Language)**:
```sql
COMMIT          -- Save changes
ROLLBACK        -- Undo changes
SAVEPOINT       -- Set savepoint in transaction
```

---

## SELECT Statements

### Basic SELECT
```sql
-- Select all columns
SELECT * FROM trades;

-- Select specific columns
SELECT trade_id, symbol, quantity FROM trades;

-- Select with alias
SELECT 
    trade_id AS "Trade ID",
    symbol AS "Stock Symbol",
    quantity * price AS "Trade Value"
FROM trades;
```

### SELECT DISTINCT
```sql
-- Get unique symbols
SELECT DISTINCT symbol FROM trades;

-- Multiple columns
SELECT DISTINCT symbol, side FROM trades;
```

### Column Calculations
```sql
SELECT 
    trade_id,
    quantity,
    price,
    quantity * price AS trade_value,
    quantity * price * 0.001 AS commission
FROM trades;
```

---

## Filtering and Sorting

### WHERE Clause
```sql
-- Basic filtering
SELECT * FROM trades WHERE symbol = 'AAPL';

-- Numeric comparison
SELECT * FROM trades WHERE quantity > 100;
SELECT * FROM trades WHERE price >= 100.00;

-- Multiple conditions
SELECT * FROM trades
WHERE symbol = 'AAPL' AND quantity > 50;

SELECT * FROM trades
WHERE symbol = 'AAPL' OR symbol = 'GOOGL';

-- NOT operator
SELECT * FROM trades WHERE NOT symbol = 'AAPL';
```

### Comparison Operators
```sql
=       -- Equal
<> or !=  -- Not equal
>       -- Greater than
<       -- Less than
>=      -- Greater than or equal
<=      -- Less than or equal
BETWEEN -- Between range
IN      -- In list
LIKE    -- Pattern matching
IS NULL -- Is null value
```

### BETWEEN and IN
```sql
-- BETWEEN
SELECT * FROM trades
WHERE price BETWEEN 100 AND 200;

-- IN
SELECT * FROM trades
WHERE symbol IN ('AAPL', 'GOOGL', 'MSFT');

-- NOT IN
SELECT * FROM trades
WHERE symbol NOT IN ('AAPL', 'GOOGL');
```

### LIKE Pattern Matching
```sql
-- Starts with 'A'
SELECT * FROM trades WHERE symbol LIKE 'A%';

-- Ends with 'L'
SELECT * FROM trades WHERE symbol LIKE '%L';

-- Contains 'OO'
SELECT * FROM trades WHERE symbol LIKE '%OO%';

-- Second character is 'A'
SELECT * FROM trades WHERE symbol LIKE '_A%';

-- Wildcards:
-- % = zero or more characters
-- _ = exactly one character
```

### NULL Values
```sql
-- Find NULL values
SELECT * FROM trades WHERE notes IS NULL;

-- Find non-NULL values
SELECT * FROM trades WHERE notes IS NOT NULL;

-- Note: Use IS NULL, not = NULL
```

### ORDER BY
```sql
-- Sort ascending (default)
SELECT * FROM trades ORDER BY price;

-- Sort descending
SELECT * FROM trades ORDER BY price DESC;

-- Multiple columns
SELECT * FROM trades
ORDER BY symbol ASC, price DESC;

-- Sort by calculated column
SELECT 
    trade_id,
    quantity * price AS value
FROM trades
ORDER BY value DESC;
```

### LIMIT
```sql
-- Top 10 trades by value
SELECT * FROM trades
ORDER BY quantity * price DESC
LIMIT 10;

-- Skip first 10, get next 10 (pagination)
SELECT * FROM trades
ORDER BY trade_id
LIMIT 10 OFFSET 10;

-- PostgreSQL/MySQL syntax
SELECT * FROM trades LIMIT 10 OFFSET 10;

-- SQL Server syntax
SELECT TOP 10 * FROM trades;
```

---

## Aggregate Functions

### Common Functions
```sql
COUNT()     -- Count rows
SUM()       -- Sum values
AVG()       -- Average
MIN()       -- Minimum
MAX()       -- Maximum
```

### COUNT
```sql
-- Count all rows
SELECT COUNT(*) FROM trades;

-- Count non-NULL values
SELECT COUNT(notes) FROM trades;

-- Count distinct values
SELECT COUNT(DISTINCT symbol) FROM trades;
```

### SUM
```sql
-- Total quantity
SELECT SUM(quantity) FROM trades;

-- Total trade value
SELECT SUM(quantity * price) AS total_value
FROM trades;
```

### AVG
```sql
-- Average price
SELECT AVG(price) FROM trades;

-- Average quantity
SELECT AVG(quantity) AS avg_qty FROM trades;

-- Round result
SELECT ROUND(AVG(price), 2) AS avg_price
FROM trades;
```

### MIN and MAX
```sql
-- Lowest price
SELECT MIN(price) FROM trades;

-- Highest price
SELECT MAX(price) FROM trades;

-- Both together
SELECT 
    MIN(price) AS lowest_price,
    MAX(price) AS highest_price,
    MAX(price) - MIN(price) AS price_range
FROM trades;
```

### GROUP BY
```sql
-- Count trades by symbol
SELECT 
    symbol,
    COUNT(*) AS trade_count
FROM trades
GROUP BY symbol;

-- Total value by symbol
SELECT 
    symbol,
    SUM(quantity * price) AS total_value
FROM trades
GROUP BY symbol
ORDER BY total_value DESC;

-- Multiple columns
SELECT 
    symbol,
    side,
    COUNT(*) AS count,
    SUM(quantity) AS total_qty
FROM trades
GROUP BY symbol, side
ORDER BY symbol, side;
```

### HAVING
```sql
-- Filter groups (use HAVING, not WHERE)
SELECT 
    symbol,
    COUNT(*) AS trade_count
FROM trades
GROUP BY symbol
HAVING COUNT(*) > 10;

-- WHERE filters rows before grouping
-- HAVING filters groups after grouping

SELECT 
    symbol,
    AVG(price) AS avg_price
FROM trades
WHERE side = 'BUY'           -- Filter before grouping
GROUP BY symbol
HAVING AVG(price) > 100      -- Filter after grouping
ORDER BY avg_price DESC;
```

---

## Capital Markets Examples

### Example 1: Daily Trading Summary
```sql
SELECT 
    COUNT(*) AS total_trades,
    COUNT(DISTINCT symbol) AS unique_symbols,
    SUM(quantity * price) AS total_value,
    AVG(quantity * price) AS avg_trade_value,
    MIN(price) AS lowest_price,
    MAX(price) AS highest_price
FROM trades
WHERE trade_date = '2024-10-28';
```

### Example 2: Top 10 Most Traded Symbols
```sql
SELECT 
    symbol,
    COUNT(*) AS trade_count,
    SUM(quantity) AS total_volume,
    SUM(quantity * price) AS total_value
FROM trades
GROUP BY symbol
ORDER BY trade_count DESC
LIMIT 10;
```

### Example 3: Large Trades (>$100K)
```sql
SELECT 
    trade_id,
    symbol,
    quantity,
    price,
    quantity * price AS trade_value,
    side,
    trader_id
FROM trades
WHERE quantity * price > 100000
ORDER BY trade_value DESC;
```

### Example 4: Trader Performance
```sql
SELECT 
    trader_id,
    COUNT(*) AS trades,
    SUM(CASE WHEN side = 'BUY' THEN quantity ELSE 0 END) AS total_buys,
    SUM(CASE WHEN side = 'SELL' THEN quantity ELSE 0 END) AS total_sells,
    SUM(quantity * price) AS total_value
FROM trades
WHERE trade_date >= '2024-10-01'
GROUP BY trader_id
HAVING COUNT(*) >= 10
ORDER BY total_value DESC;
```

---

## Best Practices

✅ Use meaningful column aliases

✅ Format SQL for readability (indentation)

✅ Always specify column names in SELECT

✅ Use WHERE to filter before aggregating

✅ Use HAVING to filter groups

✅ Add ORDER BY for predictable results

✅ Use LIMIT for testing on large tables

✅ Comment complex queries

---

## Quick Reference

| Operation | Syntax | Example |
|-----------|--------|---------|
| Select all | `SELECT * FROM table` | `SELECT * FROM trades` |
| Select columns | `SELECT col1, col2 FROM table` | `SELECT symbol, price FROM trades` |
| Filter | `WHERE condition` | `WHERE symbol = 'AAPL'` |
| Sort | `ORDER BY column` | `ORDER BY price DESC` |
| Limit | `LIMIT n` | `LIMIT 10` |
| Count | `COUNT(*)` | `COUNT(*)` |
| Sum | `SUM(column)` | `SUM(quantity)` |
| Average | `AVG(column)` | `AVG(price)` |
| Group | `GROUP BY column` | `GROUP BY symbol` |

---

## Reference Links

### 📚 Theory & Learning Resources

1. **Comprehensive Tutorials**:
   - [W3Schools SQL Tutorial](https://www.w3schools.com/sql/) - Interactive beginner-friendly guide
   - [SQL Tutorial - Mode Analytics](https://mode.com/sql-tutorial/) - Comprehensive with real datasets
   - [SQLZoo](https://sqlzoo.net/) - Interactive SQL tutorial
   - [SQL Course - Khan Academy](https://www.khanacademy.org/computing/computer-programming/sql) - Free structured course

2. **Official Documentation**:
   - [MySQL Documentation](https://dev.mysql.com/doc/) - Complete MySQL reference
   - [PostgreSQL Documentation](https://www.postgresql.org/docs/) - PostgreSQL manual
   - [Oracle SQL Documentation](https://docs.oracle.com/en/database/oracle/oracle-database/) - Oracle reference
   - [SQL Server Documentation](https://docs.microsoft.com/en-us/sql/sql-server/) - Microsoft SQL Server

3. **Video Learning**:
   - [freeCodeCamp SQL Course](https://www.youtube.com/watch?v=HXV3zeQKqGY) - 4-hour comprehensive video
   - [LinkedIn Learning - SQL Essential Training](https://www.linkedin.com/learning/sql-essential-training-3)
   - [Coursera - SQL for Data Science](https://www.coursera.org/learn/sql-for-data-science)

### 🎮 Hands-On Practice Resources

1. **Interactive Practice Platforms**:
   - [HackerRank SQL](https://www.hackerrank.com/domains/sql) - Practice problems with instant feedback (FREE)
   - [LeetCode Database](https://leetcode.com/problemset/database/) - SQL coding challenges (FREE)
   - [SQLBolt](https://sqlbolt.com/) - Interactive lessons and exercises (FREE)
   - [Exercism - SQL Track](https://exercism.org/tracks/plsql) - Mentored practice

2. **Browser-Based SQL Environments**:
   - [DB Fiddle](https://www.db-fiddle.com/) - Test SQL queries online (MySQL, PostgreSQL, SQLite)
   - [SQL Fiddle](http://sqlfiddle.com/) - Practice SQL in browser
   - [SQL Online IDE](https://sqliteonline.com/) - SQLite in browser
   - [Programiz SQL Online](https://www.programiz.com/sql/online-compiler/) - Quick SQL testing

3. **Practice with Real Data**:
   - [Mode Analytics Public Datasets](https://mode.com/sql-tutorial/intro-to-intermediate-sql/) - Real business data
   - [Stack Overflow Data Explorer](https://data.stackexchange.com/) - Query Stack Overflow data
   - [Kaggle Datasets](https://www.kaggle.com/datasets) - Download and practice
   - [SQL Practice](https://www.sql-practice.com/) - Hospital database exercises

4. **SQL Challenge Sites**:
   - [SQLZoo](https://sqlzoo.net/) - Progressive difficulty challenges
   - [SQL Murder Mystery](https://mystery.knightlab.com/) - Learn SQL by solving a murder
   - [Select Star SQL](https://selectstarsql.com/) - Interactive book with exercises

### 📖 Quick References & Cheat Sheets

1. **Cheat Sheets**:
   - [SQL Cheat Sheet by Dataquest](https://www.dataquest.io/blog/sql-cheat-sheet/)
   - [SQL Quick Reference - W3Schools](https://www.w3schools.com/sql/sql_quickref.asp)
   - [PostgreSQL Cheat Sheet](https://www.postgresqltutorial.com/postgresql-cheat-sheet/)

2. **Performance & Optimization**:
   - [Use The Index, Luke!](https://use-the-index-luke.com/) - SQL indexing and tuning (EXCELLENT)
   - [SQL Performance Explained](https://sql-performance-explained.com/) - Performance guide
   - [Database Indexing Explained](https://www.essentialsql.com/what-is-a-database-index/)

### 📚 Books & Comprehensive Resources

1. **Free Books**:
   - [SQL Notes for Professionals](https://goalkicker.com/SQLBook/) - FREE comprehensive guide
   - [Intro to SQL - Khan Academy](https://www.khanacademy.org/computing/computer-programming/sql)

2. **Recommended Books**:
   - "SQL in 10 Minutes a Day" - Ben Forta
   - "Learning SQL" - Alan Beaulieu (O'Reilly)
   - "SQL Performance Explained" - Markus Winand

### 🎓 Courses & Certifications

1. **Free Online Courses**:
   - [Codecademy - Learn SQL](https://www.codecademy.com/learn/learn-sql) - Interactive course
   - [Udacity - SQL for Data Analysis](https://www.udacity.com/course/sql-for-data-analysis--ud198)
   - [Stanford - Databases Course](https://online.stanford.edu/courses/soe-ydatabases-databases)

2. **Certification Paths**:
   - Oracle Database SQL Certified Associate
   - Microsoft Certified: Azure Database Administrator Associate
   - MySQL Database Administrator Certification

### 💡 Community & Support

1. **Forums & Q&A**:
   - [Stack Overflow - SQL Tag](https://stackoverflow.com/questions/tagged/sql)
   - [Database Administrators Stack Exchange](https://dba.stackexchange.com/)
   - [Reddit r/SQL](https://www.reddit.com/r/SQL/)

2. **Blogs & Resources**:
   - [SQL Server Central](https://www.sqlservercentral.com/)
   - [PostgreSQL Weekly](https://postgresweekly.com/)
   - [Planet MySQL](https://planet.mysql.com/)

---

**Next Document**: `02-Joins-and-Advanced-Queries.md`

