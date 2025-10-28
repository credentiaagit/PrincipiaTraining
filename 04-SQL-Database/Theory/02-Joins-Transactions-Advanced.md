# SQL Joins, Transactions, and Advanced Topics

## Table of Contents
1. [Table Joins](#table-joins)
2. [Subqueries](#subqueries)
3. [Transactions](#transactions)
4. [Indexes](#indexes)
5. [Views](#views)
6. [Capital Markets Database Design](#capital-markets-database-design)

---

## Table Joins

### Sample Tables
```sql
-- trades table
trade_id | symbol | quantity | price | trader_id | trade_date
---------|--------|----------|-------|-----------|------------
T0001    | AAPL   | 100      | 175.50| TR01      | 2024-10-28
T0002    | GOOGL  | 50       | 140.25| TR02      | 2024-10-28

-- traders table
trader_id | trader_name  | department
----------|--------------|------------
TR01      | John Smith   | Equity
TR02      | Mary Jones   | Fixed Income

-- symbols table
symbol | company_name    | sector
-------|-----------------|----------
AAPL   | Apple Inc       | Technology
GOOGL  | Google LLC      | Technology
```

### INNER JOIN
Returns only matching rows from both tables.

```sql
SELECT 
    t.trade_id,
    t.symbol,
    s.company_name,
    t.quantity,
    t.price
FROM trades t
INNER JOIN symbols s ON t.symbol = s.symbol;

-- Alternative syntax
SELECT t.trade_id, s.company_name
FROM trades t, symbols s
WHERE t.symbol = s.symbol;
```

### LEFT JOIN (LEFT OUTER JOIN)
Returns all rows from left table, matching from right.

```sql
SELECT 
    t.trade_id,
    t.symbol,
    s.company_name
FROM trades t
LEFT JOIN symbols s ON t.symbol = s.symbol;
-- Shows all trades, even if symbol not in symbols table
```

### RIGHT JOIN
Returns all rows from right table, matching from left.

```sql
SELECT 
    s.symbol,
    s.company_name,
    t.trade_id
FROM trades t
RIGHT JOIN symbols s ON t.symbol = s.symbol;
-- Shows all symbols, even if not traded
```

### FULL OUTER JOIN
Returns all rows from both tables.

```sql
SELECT *
FROM trades t
FULL OUTER JOIN symbols s ON t.symbol = s.symbol;
```

### Multiple Joins
```sql
SELECT 
    t.trade_id,
    t.symbol,
    s.company_name,
    tr.trader_name,
    tr.department,
    t.quantity * t.price AS value
FROM trades t
INNER JOIN symbols s ON t.symbol = s.symbol
INNER JOIN traders tr ON t.trader_id = tr.trader_id
WHERE t.trade_date = '2024-10-28'
ORDER BY value DESC;
```

### Self Join
Join table with itself.

```sql
-- Find trades of same symbol by different traders
SELECT 
    t1.trade_id AS trade1,
    t2.trade_id AS trade2,
    t1.symbol,
    t1.trader_id AS trader1,
    t2.trader_id AS trader2
FROM trades t1
INNER JOIN trades t2 ON t1.symbol = t2.symbol
WHERE t1.trader_id < t2.trader_id;
```

---

## Subqueries

### Subquery in WHERE
```sql
-- Find trades above average price
SELECT * FROM trades
WHERE price > (SELECT AVG(price) FROM trades);

-- Trades of most active symbol
SELECT * FROM trades
WHERE symbol = (
    SELECT symbol FROM trades
    GROUP BY symbol
    ORDER BY COUNT(*) DESC
    LIMIT 1
);
```

### Subquery with IN
```sql
-- Trades by equity traders
SELECT * FROM trades
WHERE trader_id IN (
    SELECT trader_id FROM traders
    WHERE department = 'Equity'
);
```

### Subquery in SELECT
```sql
SELECT 
    trade_id,
    symbol,
    price,
    (SELECT AVG(price) FROM trades) AS avg_price,
    price - (SELECT AVG(price) FROM trades) AS difference
FROM trades;
```

### Subquery in FROM
```sql
SELECT 
    symbol,
    AVG(daily_volume) AS avg_daily_volume
FROM (
    SELECT 
        symbol,
        trade_date,
        SUM(quantity) AS daily_volume
    FROM trades
    GROUP BY symbol, trade_date
) AS daily_totals
GROUP BY symbol;
```

### Correlated Subquery
```sql
-- Find trades with above-average price for that symbol
SELECT t1.*
FROM trades t1
WHERE price > (
    SELECT AVG(price)
    FROM trades t2
    WHERE t2.symbol = t1.symbol
);
```

### EXISTS
```sql
-- Find symbols that have been traded
SELECT * FROM symbols s
WHERE EXISTS (
    SELECT 1 FROM trades t
    WHERE t.symbol = s.symbol
);

-- Symbols not traded
SELECT * FROM symbols s
WHERE NOT EXISTS (
    SELECT 1 FROM trades t
    WHERE t.symbol = s.symbol
);
```

---

## Transactions

### Transaction Basics
```sql
BEGIN TRANSACTION;
-- or
START TRANSACTION;

-- SQL statements here

COMMIT;      -- Save changes
-- or
ROLLBACK;    -- Undo changes
```

### Example: Transfer Shares
```sql
BEGIN TRANSACTION;

-- Deduct from seller
UPDATE positions
SET quantity = quantity - 100
WHERE account_id = 'ACC001' AND symbol = 'AAPL';

-- Add to buyer
UPDATE positions
SET quantity = quantity + 100
WHERE account_id = 'ACC002' AND symbol = 'AAPL';

-- Record trade
INSERT INTO trades (trade_id, symbol, quantity, price)
VALUES ('T0001', 'AAPL', 100, 175.50);

COMMIT;
```

### ACID Properties
- **Atomicity**: All or nothing
- **Consistency**: Data remains valid
- **Isolation**: Transactions don't interfere
- **Durability**: Committed data persists

### Savepoints
```sql
BEGIN TRANSACTION;

INSERT INTO trades VALUES (...);

SAVEPOINT after_first_insert;

INSERT INTO trades VALUES (...);

-- Rollback to savepoint
ROLLBACK TO SAVEPOINT after_first_insert;

COMMIT;
```

---

## Indexes

### Creating Indexes
```sql
-- Simple index
CREATE INDEX idx_symbol ON trades(symbol);

-- Composite index
CREATE INDEX idx_symbol_date ON trades(symbol, trade_date);

-- Unique index
CREATE UNIQUE INDEX idx_trade_id ON trades(trade_id);
```

### When to Use Indexes
✅ Columns in WHERE clause
✅ Columns in JOIN conditions
✅ Columns in ORDER BY
✅ Foreign key columns

❌ Small tables
❌ Columns with few distinct values
❌ Frequently updated columns

### Viewing Indexes
```sql
-- PostgreSQL
\d+ trades

-- MySQL
SHOW INDEX FROM trades;

-- SQL Server
EXEC sp_helpindex 'trades';
```

---

## Views

### Creating Views
```sql
-- Simple view
CREATE VIEW v_large_trades AS
SELECT *
FROM trades
WHERE quantity * price > 100000;

-- Complex view with joins
CREATE VIEW v_trade_details AS
SELECT 
    t.trade_id,
    t.symbol,
    s.company_name,
    t.quantity,
    t.price,
    t.quantity * t.price AS value,
    tr.trader_name,
    tr.department
FROM trades t
JOIN symbols s ON t.symbol = s.symbol
JOIN traders tr ON t.trader_id = tr.trader_id;
```

### Using Views
```sql
-- Query view like a table
SELECT * FROM v_large_trades;

SELECT * FROM v_trade_details
WHERE department = 'Equity'
ORDER BY value DESC;
```

### Updating Views
```sql
-- Drop view
DROP VIEW v_large_trades;

-- Replace view
CREATE OR REPLACE VIEW v_large_trades AS
SELECT * FROM trades
WHERE quantity * price > 50000;
```

---

## Capital Markets Database Design

### Typical Schema

```sql
-- Symbols table
CREATE TABLE symbols (
    symbol VARCHAR(10) PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL,
    sector VARCHAR(50),
    exchange VARCHAR(20),
    created_date DATE
);

-- Traders table
CREATE TABLE traders (
    trader_id VARCHAR(10) PRIMARY KEY,
    trader_name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    email VARCHAR(100),
    active BOOLEAN DEFAULT TRUE
);

-- Trades table
CREATE TABLE trades (
    trade_id VARCHAR(20) PRIMARY KEY,
    symbol VARCHAR(10) NOT NULL,
    side VARCHAR(4) CHECK (side IN ('BUY', 'SELL')),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    trader_id VARCHAR(10) NOT NULL,
    trade_date DATE NOT NULL,
    trade_time TIME NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING',
    FOREIGN KEY (symbol) REFERENCES symbols(symbol),
    FOREIGN KEY (trader_id) REFERENCES traders(trader_id)
);

-- Positions table
CREATE TABLE positions (
    account_id VARCHAR(20),
    symbol VARCHAR(10),
    quantity INTEGER DEFAULT 0,
    avg_cost DECIMAL(10,2),
    last_updated TIMESTAMP,
    PRIMARY KEY (account_id, symbol),
    FOREIGN KEY (symbol) REFERENCES symbols(symbol)
);

-- Trade audit table
CREATE TABLE trade_audit (
    audit_id SERIAL PRIMARY KEY,
    trade_id VARCHAR(20),
    action VARCHAR(20),
    old_status VARCHAR(20),
    new_status VARCHAR(20),
    changed_by VARCHAR(50),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Common Queries

**1. Daily Trading Summary:**
```sql
SELECT 
    trade_date,
    COUNT(*) AS total_trades,
    SUM(CASE WHEN side = 'BUY' THEN quantity * price ELSE 0 END) AS buy_value,
    SUM(CASE WHEN side = 'SELL' THEN quantity * price ELSE 0 END) AS sell_value,
    SUM(quantity * price) AS total_value
FROM trades
WHERE trade_date >= CURRENT_DATE - INTERVAL '7 days'
GROUP BY trade_date
ORDER BY trade_date DESC;
```

**2. Top Traders by Volume:**
```sql
SELECT 
    tr.trader_name,
    tr.department,
    COUNT(t.trade_id) AS trade_count,
    SUM(t.quantity) AS total_volume,
    SUM(t.quantity * t.price) AS total_value
FROM trades t
JOIN traders tr ON t.trader_id = tr.trader_id
WHERE t.trade_date = CURRENT_DATE
GROUP BY tr.trader_id, tr.trader_name, tr.department
ORDER BY total_value DESC
LIMIT 10;
```

**3. Position Reconciliation:**
```sql
SELECT 
    p.account_id,
    p.symbol,
    p.quantity AS recorded_position,
    COALESCE(SUM(
        CASE WHEN t.side = 'BUY' THEN t.quantity
             WHEN t.side = 'SELL' THEN -t.quantity
        END
    ), 0) AS calculated_position,
    p.quantity - COALESCE(SUM(
        CASE WHEN t.side = 'BUY' THEN t.quantity
             WHEN t.side = 'SELL' THEN -t.quantity
        END
    ), 0) AS difference
FROM positions p
LEFT JOIN trades t ON p.account_id = t.account_id 
                   AND p.symbol = t.symbol
GROUP BY p.account_id, p.symbol, p.quantity
HAVING p.quantity != COALESCE(SUM(
    CASE WHEN t.side = 'BUY' THEN t.quantity
         WHEN t.side = 'SELL' THEN -t.quantity
    END
), 0);
```

**4. Risk Analysis:**
```sql
SELECT 
    p.account_id,
    COUNT(DISTINCT p.symbol) AS num_symbols,
    SUM(p.quantity * s.current_price) AS total_value,
    MAX(p.quantity * s.current_price) AS max_position,
    (MAX(p.quantity * s.current_price) / 
     SUM(p.quantity * s.current_price)) * 100 AS concentration_pct
FROM positions p
JOIN symbols s ON p.symbol = s.symbol
GROUP BY p.account_id
HAVING (MAX(p.quantity * s.current_price) / 
        SUM(p.quantity * s.current_price)) > 0.25;
```

---

## Best Practices

✅ Use appropriate JOIN types

✅ Index foreign key columns

✅ Use transactions for related operations

✅ Create views for complex, repeated queries

✅ Add constraints for data integrity

✅ Use meaningful table and column names

✅ Document database schema

✅ Regular backups

✅ Monitor query performance

---

## Quick Reference

| Operation | Syntax | Example |
|-----------|--------|---------|
| Inner Join | `INNER JOIN` | `FROM t1 INNER JOIN t2 ON...` |
| Left Join | `LEFT JOIN` | `FROM t1 LEFT JOIN t2 ON...` |
| Subquery WHERE | `WHERE col IN (SELECT...)` | `WHERE id IN (SELECT id FROM...)` |
| Transaction | `BEGIN; ... COMMIT;` | `BEGIN TRANSACTION; ...` |
| Index | `CREATE INDEX` | `CREATE INDEX idx ON table(col)` |
| View | `CREATE VIEW` | `CREATE VIEW v AS SELECT...` |

---

**This completes SQL Theory!**

Next: Sample queries and exercises in the respective directories.

