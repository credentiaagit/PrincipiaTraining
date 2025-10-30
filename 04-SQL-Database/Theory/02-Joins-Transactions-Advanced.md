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

**What are JOINs?**
JOINs combine data from two or more tables based on a related column. In relational databases, data is often split across multiple tables to avoid redundancy. JOINs allow you to query related data together.

**Why use JOINs?**
- Combine related data from different tables
- Get complete information in a single query
- Maintain normalized database design
- Essential for real-world queries (trades + trader info, orders + customer details, etc.)

**Real-World Example:**
In a trading system, you might have:
- `trades` table (trade details)
- `traders` table (who made the trade)
- `symbols` table (stock information)

To get a complete picture, you need to JOIN these tables together.

### Sample Tables

We'll use these tables for all examples:

```sql
-- trades table (what was traded)
trade_id | symbol | quantity | price | trader_id | trade_date
---------|--------|----------|-------|-----------|------------
T0001    | AAPL   | 100      | 175.50| TR01      | 2024-10-28
T0002    | GOOGL  | 50       | 140.25| TR02      | 2024-10-28
T0003    | MSFT   | 200      | 380.00| TR01      | 2024-10-28
T0004    | UNKN   | 10       | 50.00 | TR03      | 2024-10-28

-- traders table (who trades)
trader_id | trader_name  | department
----------|--------------|------------
TR01      | John Smith   | Equity
TR02      | Mary Jones   | Fixed Income
TR03      | Bob Wilson   | Derivatives

-- symbols table (stock info)
symbol | company_name    | sector     | exchange
-------|-----------------|------------|----------
AAPL   | Apple Inc       | Technology | NASDAQ
GOOGL  | Google LLC      | Technology | NASDAQ
MSFT   | Microsoft Corp  | Technology | NASDAQ
TSLA   | Tesla Inc       | Automotive | NASDAQ
-- Note: UNKN (from trades) is NOT in this table
-- Note: TSLA (from symbols) has NOT been traded
```

---

### INNER JOIN

**What is INNER JOIN?**
Returns ONLY the rows where there is a match in BOTH tables.

**When to use:**
- Get only complete records with matching data
- Most commonly used JOIN type
- When you only want records that exist in both tables

**How it works:**
- Compares each row from table A with each row from table B
- If the join condition matches, combine the rows
- If no match, the row is excluded

**Visual Representation:**
```
Table A (Trades)          Table B (Symbols)
    AAPL   ←─────────────→   AAPL      ✓ Match
    GOOGL  ←─────────────→   GOOGL     ✓ Match
    MSFT   ←─────────────→   MSFT      ✓ Match
    UNKN   ←  (no match)      TSLA     ✓ In symbols but not traded

INNER JOIN Result: Only AAPL, GOOGL, MSFT (matches only)
```

**Syntax:**
```sql
SELECT columns
FROM table1
INNER JOIN table2 ON table1.column = table2.column;
```

**Example:**
```sql
-- Get trade details with company names (only matching records)
SELECT 
    t.trade_id,
    t.symbol,
    s.company_name,
    s.sector,
    t.quantity,
    t.price,
    (t.quantity * t.price) AS total_value
FROM trades t
INNER JOIN symbols s ON t.symbol = s.symbol;

-- Result: Only trades where symbol exists in symbols table
-- T0001: AAPL + Apple Inc     ✓
-- T0002: GOOGL + Google LLC   ✓
-- T0003: MSFT + Microsoft     ✓
-- T0004: UNKN (excluded - no matching symbol)
-- TSLA info (excluded - not traded)
```

**Alternative Syntax (older style, less clear):**
```sql
-- Same as INNER JOIN above
SELECT t.trade_id, s.company_name
FROM trades t, symbols s
WHERE t.symbol = s.symbol;
-- Note: Modern code prefers explicit INNER JOIN syntax
```

---

### LEFT JOIN (LEFT OUTER JOIN)

**What is LEFT JOIN?**
Returns ALL rows from the LEFT table, plus matching rows from the RIGHT table. If no match, NULL values appear for right table columns.

**When to use:**
- Get all records from main table
- Include records even if related data doesn't exist
- Example: All trades, even if symbol info is missing

**How it works:**
- Start with ALL rows from left table
- Add matching data from right table
- If no match, fill right table columns with NULL

**Visual Representation:**
```
LEFT Table (Trades)       RIGHT Table (Symbols)
    AAPL   ←─────────────→   AAPL      ✓ Match
    GOOGL  ←─────────────→   GOOGL     ✓ Match  
    MSFT   ←─────────────→   MSFT      ✓ Match
    UNKN   ←  (no match)      TSLA     ✗ No trade

LEFT JOIN Result: ALL 4 trades (UNKN gets NULL for symbol info)
```

**Syntax:**
```sql
SELECT columns
FROM left_table
LEFT JOIN right_table ON left_table.column = right_table.column;
```

**Example:**
```sql
-- Get ALL trades, with symbol info if available
SELECT 
    t.trade_id,
    t.symbol,
    s.company_name,    -- May be NULL
    s.sector,          -- May be NULL
    t.quantity,
    t.price
FROM trades t
LEFT JOIN symbols s ON t.symbol = s.symbol;

-- Result: ALL trades, even without symbol match
-- T0001: AAPL  + Apple Inc          ✓
-- T0002: GOOGL + Google LLC         ✓
-- T0003: MSFT  + Microsoft Corp     ✓
-- T0004: UNKN  + NULL (no symbol info) ✓ Still included!
```

**Use Case - Find Missing Data:**
```sql
-- Find trades with missing symbol information
SELECT 
    t.trade_id,
    t.symbol,
    s.company_name
FROM trades t
LEFT JOIN symbols s ON t.symbol = s.symbol
WHERE s.symbol IS NULL;  -- Only trades without symbol info

-- Result: T0004 (UNKN symbol not in database)
-- Useful for data quality checks!
```

---

### RIGHT JOIN (RIGHT OUTER JOIN)

**What is RIGHT JOIN?**
Returns ALL rows from the RIGHT table, plus matching rows from the LEFT table. Opposite of LEFT JOIN.

**When to use:**
- Get all records from reference table
- Include reference data even if not used
- Example: All symbols, even if not traded

**How it works:**
- Start with ALL rows from right table
- Add matching data from left table
- If no match, fill left table columns with NULL

**Visual Representation:**
```
LEFT Table (Trades)       RIGHT Table (Symbols)
    AAPL   ←─────────────→   AAPL      ✓ Match
    GOOGL  ←─────────────→   GOOGL     ✓ Match
    MSFT   ←─────────────→   MSFT      ✓ Match
    UNKN   ✗ Not in symbols   TSLA     ← No trade (gets NULL)

RIGHT JOIN Result: ALL 4 symbols (TSLA gets NULL for trade info)
```

**Syntax:**
```sql
SELECT columns
FROM left_table
RIGHT JOIN right_table ON left_table.column = right_table.column;
```

**Example:**
```sql
-- Get ALL symbols, with trade info if available
SELECT 
    s.symbol,
    s.company_name,
    s.sector,
    t.trade_id,      -- May be NULL
    t.quantity,      -- May be NULL
    t.price          -- May be NULL
FROM trades t
RIGHT JOIN symbols s ON t.symbol = s.symbol;

-- Result: ALL symbols, even without trades
-- AAPL:  Apple Inc   + T0001         ✓
-- GOOGL: Google LLC  + T0002         ✓
-- MSFT:  Microsoft   + T0003         ✓
-- TSLA:  Tesla Inc   + NULL (not traded) ✓ Still included!
```

**Use Case - Find Unused Data:**
```sql
-- Find symbols that were never traded
SELECT 
    s.symbol,
    s.company_name
FROM trades t
RIGHT JOIN symbols s ON t.symbol = s.symbol
WHERE t.trade_id IS NULL;  -- Only symbols without trades

-- Result: TSLA (in database but never traded)
-- Useful for finding inactive stocks!
```

**Note:** Most databases support RIGHT JOIN, but LEFT JOIN is more commonly used (just swap table order).

---

### FULL OUTER JOIN

**What is FULL OUTER JOIN?**
Returns ALL rows from BOTH tables. Combines LEFT JOIN and RIGHT JOIN.

**When to use:**
- Get complete picture from both tables
- Include all records, whether matched or not
- Rare in practice, but useful for comprehensive analysis

**How it works:**
- Include ALL rows from left table
- Include ALL rows from right table
- Match where possible
- NULL for missing data on either side

**Visual Representation:**
```
LEFT Table (Trades)       RIGHT Table (Symbols)
    AAPL   ←─────────────→   AAPL      ✓ Match
    GOOGL  ←─────────────→   GOOGL     ✓ Match
    MSFT   ←─────────────→   MSFT      ✓ Match
    UNKN   ← (no match)       TSLA     ← (no match)

FULL OUTER JOIN Result: ALL records from BOTH tables
```

**Syntax:**
```sql
SELECT columns
FROM table1
FULL OUTER JOIN table2 ON table1.column = table2.column;

-- Note: Some databases (like MySQL) don't support FULL OUTER JOIN
-- Alternative: Use LEFT JOIN UNION RIGHT JOIN
```

**Example:**
```sql
-- Get ALL trades AND ALL symbols
SELECT 
    t.trade_id,
    t.symbol AS trade_symbol,
    s.symbol AS symbol_symbol,
    s.company_name,
    t.quantity,
    t.price
FROM trades t
FULL OUTER JOIN symbols s ON t.symbol = s.symbol;

-- Result: Everything from both tables
-- T0001: AAPL  + Apple Inc          ✓ Matched
-- T0002: GOOGL + Google LLC         ✓ Matched
-- T0003: MSFT  + Microsoft Corp     ✓ Matched
-- T0004: UNKN  + NULL (no symbol)   ✓ Trade without symbol
-- NULL:  TSLA  + Tesla Inc          ✓ Symbol without trade
```

**Use Case - Complete Data Audit:**
```sql
-- Find ALL mismatches (trades without symbols OR symbols without trades)
SELECT 
    COALESCE(t.symbol, s.symbol) AS symbol,
    t.trade_id,
    s.company_name,
    CASE
        WHEN t.symbol IS NULL THEN 'No trades'
        WHEN s.symbol IS NULL THEN 'Unknown symbol'
        ELSE 'Matched'
    END AS status
FROM trades t
FULL OUTER JOIN symbols s ON t.symbol = s.symbol
WHERE t.symbol IS NULL OR s.symbol IS NULL;

-- Result: Data quality issues
-- UNKN: Unknown symbol
-- TSLA: No trades
```

---

### CROSS JOIN

**What is CROSS JOIN?**
Returns the Cartesian product of both tables (every row from table A matched with every row from table B).

**When to use:**
- Generate all possible combinations
- Rarely used in practice
- Useful for creating test data or combination tables

**How it works:**
- For each row in table A, combine with EVERY row in table B
- If A has 3 rows and B has 4 rows, result has 3 × 4 = 12 rows
- No join condition needed

**Syntax:**
```sql
SELECT columns
FROM table1
CROSS JOIN table2;
```

**Example:**
```sql
-- Generate all possible trader-symbol combinations
SELECT 
    tr.trader_name,
    s.symbol,
    s.company_name
FROM traders tr
CROSS JOIN symbols s;

-- Result: 3 traders × 4 symbols = 12 rows
-- John Smith - AAPL
-- John Smith - GOOGL
-- John Smith - MSFT
-- John Smith - TSLA
-- Mary Jones - AAPL
-- ... (all combinations)
```

---

### Self JOIN

**What is Self JOIN?**
A table joined with itself. Used to compare rows within the same table.

**When to use:**
- Find related records in same table
- Compare values within same table
- Example: Find traders in same department, compare trade prices

**Example:**
```sql
-- Find traders in the same department
SELECT 
    t1.trader_name AS trader1,
    t2.trader_name AS trader2,
    t1.department
FROM traders t1
INNER JOIN traders t2 ON t1.department = t2.department
WHERE t1.trader_id < t2.trader_id;  -- Avoid duplicates

-- Find trades of same symbol with different prices
SELECT 
    t1.trade_id AS trade1,
    t2.trade_id AS trade2,
    t1.symbol,
    t1.price AS price1,
    t2.price AS price2,
    ABS(t1.price - t2.price) AS price_difference
FROM trades t1
INNER JOIN trades t2 ON t1.symbol = t2.symbol
WHERE t1.trade_id < t2.trade_id;
```

---

### JOIN Types Summary Table

| JOIN Type | Returns | Use Case | Example |
|-----------|---------|----------|---------|
| **INNER** | Only matches from both tables | Most common; get complete records | Trades with valid symbols |
| **LEFT** | All from left + matches from right | Keep all main records | All trades (even invalid symbols) |
| **RIGHT** | All from right + matches from left | Keep all reference records | All symbols (even untraded) |
| **FULL OUTER** | All from both tables | Complete data audit | All trades AND all symbols |
| **CROSS** | All combinations (A × B) | Generate combinations | All trader-symbol pairs |
| **SELF** | Table joined with itself | Compare within same table | Same-day trades comparison |

---

### Visual Comparison of JOIN Types

Using our example tables (3 matched + 1 unmatched in each table):

```
INNER JOIN:      3 rows  (only matches)
LEFT JOIN:       4 rows  (all trades, UNKN gets NULL)
RIGHT JOIN:      4 rows  (all symbols, TSLA gets NULL)
FULL OUTER JOIN: 5 rows  (all trades + all symbols)
CROSS JOIN:      16 rows (4 trades × 4 symbols)
```

---

### When to Use Which JOIN?

**Use INNER JOIN when:**
✓ You only want complete, valid records
✓ Both sides must have matching data
✓ Example: "Show me trades with complete company information"

**Use LEFT JOIN when:**
✓ You want all records from main table
✓ Related data is optional
✓ Example: "Show me all trades, with company info if available"

**Use RIGHT JOIN when:**
✓ You want all records from reference table
✓ Usage is optional
✓ Example: "Show me all symbols, with trade info if they were traded"

**Use FULL OUTER JOIN when:**
✓ You want everything from both tables
✓ Data quality audit
✓ Example: "Show me all trades and all symbols, matched or not"

---

### Common JOIN Mistakes

❌ **Mistake 1**: Cartesian Product (Forgetting ON clause)
```sql
-- WRONG: No ON clause creates cross join
SELECT * FROM trades t, symbols s;
-- Result: 4 trades × 4 symbols = 16 rows! (usually not wanted)

-- CORRECT: Include join condition
SELECT * FROM trades t
INNER JOIN symbols s ON t.symbol = s.symbol;
```

❌ **Mistake 2**: Confusing LEFT/RIGHT
```sql
-- These are DIFFERENT:
SELECT * FROM trades LEFT JOIN symbols ...  -- All trades
SELECT * FROM trades RIGHT JOIN symbols ... -- All symbols (NOT all trades!)
```

❌ **Mistake 3**: Using wrong JOIN type
```sql
-- WRONG: INNER JOIN loses trades with unknown symbols
SELECT * FROM trades t
INNER JOIN symbols s ON t.symbol = s.symbol;

-- CORRECT: Use LEFT JOIN to keep all trades
SELECT * FROM trades t
LEFT JOIN symbols s ON t.symbol = s.symbol;
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

