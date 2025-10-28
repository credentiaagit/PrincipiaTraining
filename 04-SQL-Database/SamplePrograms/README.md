# SQL Database Sample Programs

This directory contains comprehensive SQL examples for capital markets database operations.

## Files Overview

### 01-capital-markets-queries.sql
**Purpose**: Basic to intermediate SQL queries for trading database
**Topics Covered**:
- Database schema creation
- Table creation with constraints
- Basic CRUD operations (Create, Read, Update, Delete)
- Simple SELECT queries
- WHERE clauses and filtering
- ORDER BY and sorting
- Basic JOIN operations
- Aggregate functions (COUNT, SUM, AVG, MIN, MAX)
- GROUP BY and HAVING clauses
- Basic indexes

**Database Schema**:
- `clients`: Client information
- `symbols`: Trading symbols and company details
- `trades`: Trading transactions
- `accounts`: Account balances
- `market_data`: Market price data

---

### 02-advanced-sql-queries.sql
**Purpose**: Advanced SQL queries and techniques
**Topics Covered**:
1. **Complex Joins**: Multiple tables, LEFT/RIGHT/FULL joins, SELF joins
2. **Subqueries**: WHERE clause, FROM clause, correlated subqueries, EXISTS
3. **Window Functions**: RANK, ROW_NUMBER, LAG, LEAD, running totals, moving averages
4. **Common Table Expressions (CTEs)**: Simple, multiple, recursive CTEs
5. **Pivot/Unpivot**: Cross-tabulation, dynamic pivoting
6. **Advanced Aggregations**: ROLLUP, CUBE, GROUPING SETS
7. **Date/Time Functions**: Date manipulation, business days calculation
8. **String Manipulation**: Text functions, pattern matching
9. **Performance Optimization**: Query analysis, index usage
10. **Data Quality**: Validation queries, integrity checks

---

## Getting Started

### Prerequisites
- SQL database installed (MySQL, PostgreSQL, Oracle, or SQL Server)
- Database client (MySQL Workbench, pgAdmin, DBeaver, or command-line client)
- Basic understanding of relational databases

### Setup Database

```sql
-- Connect to your database server
mysql -u username -p

-- Or PostgreSQL
psql -U username -d database_name
```

### Execute SQL Files

```bash
# MySQL
mysql -u username -p database_name < 01-capital-markets-queries.sql

# PostgreSQL
psql -U username -d database_name -f 01-capital-markets-queries.sql

# SQL Server (sqlcmd)
sqlcmd -S server_name -d database_name -i 01-capital-markets-queries.sql
```

---

## SQL Quick Reference

### Basic SELECT
```sql
SELECT column1, column2
FROM table_name
WHERE condition
ORDER BY column1 DESC;
```

### Joins
```sql
-- INNER JOIN
SELECT *
FROM table1 t1
INNER JOIN table2 t2 ON t1.id = t2.id;

-- LEFT JOIN
SELECT *
FROM table1 t1
LEFT JOIN table2 t2 ON t1.id = t2.id;

-- Multiple Joins
SELECT *
FROM table1 t1
INNER JOIN table2 t2 ON t1.id = t2.id
LEFT JOIN table3 t3 ON t1.id = t3.id;
```

### Aggregates
```sql
SELECT 
    category,
    COUNT(*) AS total_count,
    SUM(amount) AS total_amount,
    AVG(amount) AS average_amount,
    MIN(amount) AS min_amount,
    MAX(amount) AS max_amount
FROM table_name
GROUP BY category
HAVING COUNT(*) > 10;
```

### Subqueries
```sql
-- IN subquery
SELECT *
FROM table1
WHERE id IN (SELECT id FROM table2);

-- EXISTS subquery
SELECT *
FROM table1 t1
WHERE EXISTS (
    SELECT 1 FROM table2 t2 
    WHERE t2.id = t1.id
);
```

### Window Functions
```sql
SELECT 
    column1,
    SUM(column2) OVER (
        PARTITION BY column1 
        ORDER BY column3
    ) AS running_total
FROM table_name;
```

### CTEs
```sql
WITH cte_name AS (
    SELECT column1, column2
    FROM table_name
    WHERE condition
)
SELECT * FROM cte_name;
```

---

## Capital Markets Database Schema

### Core Tables

**clients**
- `client_id` (PK): Unique client identifier
- `client_name`: Full name
- `account_id`: Account number
- `email`: Contact email
- `status`: ACTIVE/INACTIVE

**symbols**
- `symbol_id` (PK): Unique symbol identifier
- `symbol`: Trading symbol (e.g., AAPL)
- `company_name`: Full company name
- `sector`: Industry sector
- `exchange`: Stock exchange

**trades**
- `trade_id` (PK): Unique trade identifier
- `client_id` (FK): Reference to clients
- `symbol_id` (FK): Reference to symbols
- `trade_date`: Date of trade
- `trade_type`: BUY/SELL
- `quantity`: Number of shares
- `price`: Price per share
- `status`: COMPLETED/PENDING/FAILED

**accounts**
- `account_id` (PK): Account identifier
- `client_id` (FK): Reference to clients
- `balance`: Current balance
- `currency`: Currency code

---

## Common Query Patterns

### 1. Daily Trading Summary
```sql
SELECT 
    trade_date,
    COUNT(*) AS total_trades,
    SUM(CASE WHEN trade_type = 'BUY' THEN 1 ELSE 0 END) AS buy_count,
    SUM(CASE WHEN trade_type = 'SELL' THEN 1 ELSE 0 END) AS sell_count,
    SUM(quantity * price) AS total_value
FROM trades
WHERE trade_date = CURRENT_DATE
GROUP BY trade_date;
```

### 2. Top Traders
```sql
SELECT 
    c.client_name,
    COUNT(t.trade_id) AS trade_count,
    SUM(t.quantity * t.price) AS total_value
FROM clients c
INNER JOIN trades t ON c.client_id = t.client_id
WHERE t.trade_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
GROUP BY c.client_id, c.client_name
ORDER BY total_value DESC
LIMIT 10;
```

### 3. Portfolio Holdings
```sql
SELECT 
    c.client_name,
    s.symbol,
    SUM(CASE 
        WHEN t.trade_type = 'BUY' THEN t.quantity 
        ELSE -t.quantity 
    END) AS net_position,
    AVG(t.price) AS avg_price
FROM clients c
INNER JOIN trades t ON c.client_id = t.client_id
INNER JOIN symbols s ON t.symbol_id = s.symbol_id
WHERE t.status = 'COMPLETED'
GROUP BY c.client_id, c.client_name, s.symbol_id, s.symbol
HAVING net_position != 0;
```

### 4. Price Movement Analysis
```sql
SELECT 
    symbol_id,
    trade_date,
    MIN(price) AS low_price,
    MAX(price) AS high_price,
    FIRST_VALUE(price) OVER (
        PARTITION BY symbol_id, trade_date 
        ORDER BY trade_timestamp
    ) AS open_price,
    LAST_VALUE(price) OVER (
        PARTITION BY symbol_id, trade_date 
        ORDER BY trade_timestamp
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS close_price
FROM trades
WHERE trade_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
GROUP BY symbol_id, trade_date;
```

### 5. Risk Analysis
```sql
WITH client_exposure AS (
    SELECT 
        client_id,
        symbol_id,
        SUM(CASE 
            WHEN trade_type = 'BUY' THEN quantity * price 
            ELSE -quantity * price 
        END) AS exposure
    FROM trades
    WHERE status = 'COMPLETED'
    GROUP BY client_id, symbol_id
)
SELECT 
    c.client_name,
    COUNT(DISTINCT ce.symbol_id) AS symbols_traded,
    SUM(ABS(ce.exposure)) AS total_exposure,
    MAX(ABS(ce.exposure)) AS max_single_exposure,
    MAX(ABS(ce.exposure)) / NULLIF(SUM(ABS(ce.exposure)), 0) * 100 
        AS concentration_pct
FROM client_exposure ce
INNER JOIN clients c ON ce.client_id = c.client_id
GROUP BY ce.client_id, c.client_name
ORDER BY total_exposure DESC;
```

---

## Performance Tips

### 1. Use Indexes
```sql
-- Create index on frequently queried columns
CREATE INDEX idx_trades_date ON trades(trade_date);
CREATE INDEX idx_trades_symbol ON trades(symbol_id);
CREATE INDEX idx_trades_client ON trades(client_id);

-- Composite index for common queries
CREATE INDEX idx_trades_symbol_date 
ON trades(symbol_id, trade_date);
```

### 2. Analyze Query Performance
```sql
-- MySQL
EXPLAIN SELECT * FROM trades WHERE trade_date = '2024-10-28';

-- PostgreSQL
EXPLAIN ANALYZE SELECT * FROM trades WHERE trade_date = '2024-10-28';
```

### 3. Optimize Joins
```sql
-- Use INNER JOIN instead of WHERE for joins
-- Bad:
SELECT * FROM trades t, clients c 
WHERE t.client_id = c.client_id;

-- Good:
SELECT * FROM trades t 
INNER JOIN clients c ON t.client_id = c.client_id;
```

### 4. Limit Result Sets
```sql
-- Always use LIMIT/TOP for testing
SELECT * FROM trades 
WHERE trade_date = CURRENT_DATE
LIMIT 100;
```

### 5. Use EXISTS instead of IN for large subqueries
```sql
-- Less efficient
SELECT * FROM clients 
WHERE client_id IN (SELECT client_id FROM trades);

-- More efficient
SELECT * FROM clients c
WHERE EXISTS (SELECT 1 FROM trades t WHERE t.client_id = c.client_id);
```

---

## Data Types Reference

### Numeric Types
```sql
INT, INTEGER          -- Whole numbers
BIGINT                -- Large integers
DECIMAL(10,2)         -- Fixed-point (prices)
FLOAT, DOUBLE         -- Floating-point
```

### String Types
```sql
CHAR(10)              -- Fixed length
VARCHAR(100)          -- Variable length
TEXT                  -- Long text
```

### Date/Time Types
```sql
DATE                  -- Date only
TIME                  -- Time only
DATETIME, TIMESTAMP   -- Date and time
```

### Other Types
```sql
BOOLEAN               -- True/False
ENUM('BUY','SELL')    -- Enumeration
JSON                  -- JSON data
```

---

## Transaction Management

```sql
-- Start transaction
START TRANSACTION;
-- or
BEGIN;

-- Execute statements
INSERT INTO trades (...) VALUES (...);
UPDATE accounts SET balance = balance - 1000;

-- Commit if successful
COMMIT;

-- Rollback if error
ROLLBACK;
```

### Transaction Example
```sql
START TRANSACTION;

-- Debit from account
UPDATE accounts 
SET balance = balance - 10000
WHERE account_id = 'ACC001';

-- Record trade
INSERT INTO trades (trade_id, client_id, symbol_id, quantity, price)
VALUES ('T001', 'C001', 'AAPL', 100, 150.00);

-- Commit transaction
COMMIT;
```

---

## Best Practices

✅ **Always use WHERE clauses** to avoid full table scans

✅ **Use appropriate data types** for efficiency

✅ **Create indexes** on frequently queried columns

✅ **Use transactions** for multiple related operations

✅ **Test queries** on small datasets first

✅ **Use LIMIT** during development

✅ **Comment your SQL** for documentation

✅ **Use meaningful table and column names**

✅ **Normalize your database** to reduce redundancy

✅ **Regular backups** of critical data

---

## Common Mistakes to Avoid

❌ SELECT * in production code (specify columns)

❌ Missing WHERE clause (accidental full table updates)

❌ Not using indexes on large tables

❌ Forgetting to commit transactions

❌ Not handling NULL values properly

❌ Using functions on indexed columns in WHERE (breaks index usage)

❌ Not testing queries before production

---

## Database-Specific Notes

### MySQL
- Use `LIMIT n` for row limiting
- Date format: `'YYYY-MM-DD'`
- String concatenation: `CONCAT()`

### PostgreSQL
- Use `LIMIT n` for row limiting
- Supports arrays and JSON
- String concatenation: `||` or `CONCAT()`

### SQL Server
- Use `TOP n` for row limiting
- Date format may vary
- String concatenation: `+` or `CONCAT()`

### Oracle
- Use `ROWNUM <= n` or `FETCH FIRST n ROWS ONLY`
- Sequence for auto-increment
- String concatenation: `||` or `CONCAT()`

---

## Exercises

After studying these examples, try to:

1. Write a query to find top 10 most volatile stocks
2. Calculate each client's profit/loss
3. Find trading patterns (time of day, day of week)
4. Identify potential fraudulent activities
5. Generate month-end reports
6. Create a leaderboard of top performers

---

## Reference Links

1. **SQL Tutorial**: https://www.w3schools.com/sql/
2. **PostgreSQL Documentation**: https://www.postgresql.org/docs/
3. **MySQL Documentation**: https://dev.mysql.com/doc/
4. **SQL Server Documentation**: https://docs.microsoft.com/en-us/sql/
5. **SQL Performance**: https://use-the-index-luke.com/
6. **DB Fiddle (Online SQL Editor)**: https://www.db-fiddle.com/

---

## Troubleshooting

### Syntax Errors
```sql
-- Check SQL syntax for your database version
-- Use database-specific tools or online validators
```

### Performance Issues
```sql
-- Analyze slow queries
EXPLAIN your_query;

-- Check for missing indexes
SHOW INDEX FROM table_name;
```

### Connection Issues
```bash
# Test connection
mysql -u username -p -h hostname

# Check if server is running
systemctl status mysql    # Linux
```

---

**Next Steps**: Complete the exercises in the `Exercises` directory to master SQL queries for capital markets applications.

