# SQL Coding Standards

## Table of Contents
1. [Naming Conventions](#naming-conventions)
2. [Formatting and Style](#formatting-and-style)
3. [Query Structure](#query-structure)
4. [Comments and Documentation](#comments-and-documentation)
5. [Join Standards](#join-standards)
6. [Subquery Standards](#subquery-standards)
7. [Index Naming](#index-naming)
8. [Constraint Naming](#constraint-naming)
9. [Stored Procedure Standards](#stored-procedure-standards)
10. [Capital Markets Specific Standards](#capital-markets-specific-standards)

---

## Naming Conventions

### Database Objects

**Tables**
- **Convention**: `snake_case`, plural nouns
- **Why**: Descriptive, represents collection of records
- **Examples**:
```sql
-- Good - Plural, descriptive
CREATE TABLE trades (
    trade_id VARCHAR(10) PRIMARY KEY,
    symbol VARCHAR(10),
    quantity INT
);

CREATE TABLE trade_settlements (
    settlement_id INT PRIMARY KEY,
    trade_id VARCHAR(10)
);

CREATE TABLE market_data (
    symbol VARCHAR(10),
    price DECIMAL(10,2)
);

-- Bad
CREATE TABLE trade (...)          -- Singular (inconsistent)
CREATE TABLE TradeSettlement (...) -- PascalCase
CREATE TABLE trade-settlement (...) -- Hyphens (invalid in most DBs)
CREATE TABLE ts (...)              -- Too cryptic
```

**Columns**
- **Convention**: `snake_case`, descriptive nouns
- **Why**: Readable, consistent with table names
- **Boolean columns**: Prefix with `is_`, `has_`, `can_`
- **Date/Time columns**: Suffix with `_date`, `_time`, `_at`
- **Examples**:
```sql
-- Good
CREATE TABLE trades (
    trade_id VARCHAR(10),
    trader_id VARCHAR(10),
    symbol VARCHAR(10),
    trade_quantity INT,
    trade_price DECIMAL(10,2),
    trade_value DECIMAL(15,2),
    order_type VARCHAR(20),
    is_executed BOOLEAN,
    is_settled BOOLEAN,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    execution_date DATE,
    settlement_date DATE
);

-- Bad
CREATE TABLE trades (
    TradeID VARCHAR(10),         -- PascalCase
    traderID VARCHAR(10),        -- Mixed case
    SYMBOL VARCHAR(10),          -- All caps
    qty INT,                     -- Abbreviation
    p DECIMAL(10,2),             -- Single letter
    executed BOOLEAN,            -- Not clear (is_executed better)
    created TIMESTAMP            -- Not clear (created_at better)
);
```

**Primary Keys**
- **Convention**: `table_name_id` or just `id`
- **Examples**:
```sql
-- Good - Explicit
CREATE TABLE trades (
    trade_id VARCHAR(10) PRIMARY KEY,
    ...
);

-- Also acceptable - Simple id
CREATE TABLE trades (
    id SERIAL PRIMARY KEY,
    ...
);

-- Bad
CREATE TABLE trades (
    tid INT PRIMARY KEY,         -- Cryptic
    trade_pk INT PRIMARY KEY     -- Redundant _pk suffix
);
```

**Foreign Keys**
- **Convention**: `referenced_table_id` (singular)
- **Examples**:
```sql
-- Good
CREATE TABLE trades (
    trade_id VARCHAR(10) PRIMARY KEY,
    trader_id VARCHAR(10),      -- References traders(trader_id)
    symbol_id INT,              -- References symbols(symbol_id)
    order_id VARCHAR(20)        -- References orders(order_id)
);

-- Bad
CREATE TABLE trades (
    trader VARCHAR(10),         -- Same name as table, confusing
    symbol INT,                 -- Not clear it's a foreign key
    ord_fk VARCHAR(20)          -- Unnecessary _fk suffix
);
```

---

### Indexes

**Convention**: `idx_tablename_column(s)`
- **Why**: Easy to identify purpose
```sql
-- Good
CREATE INDEX idx_trades_symbol ON trades(symbol);
CREATE INDEX idx_trades_trader_date ON trades(trader_id, trade_date);
CREATE INDEX idx_trades_execution_date ON trades(execution_date);

-- Bad
CREATE INDEX trades_idx ON trades(symbol);      -- Table name first
CREATE INDEX symbol_index ON trades(symbol);    -- Not clear which table
CREATE INDEX i1 ON trades(symbol);              -- Meaningless name
```

**Unique Indexes**
- **Convention**: `uq_tablename_column(s)` or `uk_tablename_column(s)`
```sql
-- Good
CREATE UNIQUE INDEX uq_trades_trade_number ON trades(trade_number);
CREATE UNIQUE INDEX uq_users_email ON users(email);

-- Also acceptable
CREATE UNIQUE INDEX uk_trades_trade_number ON trades(trade_number);
```

---

### Constraints

**Primary Key Constraints**
- **Convention**: `pk_tablename`
```sql
-- Good
ALTER TABLE trades ADD CONSTRAINT pk_trades PRIMARY KEY (trade_id);

-- Also acceptable (if DB auto-generates)
CREATE TABLE trades (
    trade_id VARCHAR(10) PRIMARY KEY
);
```

**Foreign Key Constraints**
- **Convention**: `fk_tablename_referenced_table`
```sql
-- Good
ALTER TABLE trades 
ADD CONSTRAINT fk_trades_traders 
FOREIGN KEY (trader_id) REFERENCES traders(trader_id);

ALTER TABLE trades 
ADD CONSTRAINT fk_trades_symbols 
FOREIGN KEY (symbol_id) REFERENCES symbols(symbol_id);

-- Bad
ALTER TABLE trades 
ADD CONSTRAINT trades_fk1        -- Not descriptive
FOREIGN KEY (trader_id) REFERENCES traders(trader_id);
```

**Check Constraints**
- **Convention**: `chk_tablename_column_description`
```sql
-- Good
ALTER TABLE trades 
ADD CONSTRAINT chk_trades_quantity_positive 
CHECK (quantity > 0);

ALTER TABLE trades 
ADD CONSTRAINT chk_trades_price_positive 
CHECK (trade_price > 0);

ALTER TABLE users 
ADD CONSTRAINT chk_users_email_format 
CHECK (email LIKE '%@%.%');

-- Bad
ALTER TABLE trades 
ADD CONSTRAINT check1            -- Not descriptive
CHECK (quantity > 0);
```

---

## Formatting and Style

### Keyword Case

**Standard**: SQL keywords in UPPERCASE, identifiers in lowercase
- **Why**: Distinguishes SQL syntax from database objects
```sql
-- Good
SELECT 
    trade_id,
    symbol,
    quantity,
    trade_price
FROM trades
WHERE trade_date = '2024-10-28'
ORDER BY trade_id;

-- Bad - All lowercase (hard to read)
select trade_id, symbol, quantity from trades where trade_date = '2024-10-28';

-- Bad - Mixed case inconsistent
Select trade_id, Symbol FROM Trades Where trade_date = '2024-10-28';
```

### Indentation

**Standard**: 4 spaces for nested clauses
```sql
-- Good
SELECT 
    t.trade_id,
    t.symbol,
    tr.trader_name,
    t.quantity * t.trade_price AS total_value
FROM trades t
INNER JOIN traders tr ON t.trader_id = tr.trader_id
WHERE t.trade_date >= '2024-01-01'
    AND t.is_executed = TRUE
ORDER BY t.trade_date DESC, t.trade_id;

-- Bad - No indentation
SELECT t.trade_id, t.symbol, tr.trader_name, t.quantity * t.trade_price AS total_value
FROM trades t
INNER JOIN traders tr ON t.trader_id = tr.trader_id
WHERE t.trade_date >= '2024-01-01' AND t.is_executed = TRUE
ORDER BY t.trade_date DESC, t.trade_id;
```

### Column Alignment

**One column per line** for readability:
```sql
-- Good - One column per line
SELECT 
    trade_id,
    symbol,
    quantity,
    trade_price,
    quantity * trade_price AS trade_value,
    execution_date
FROM trades;

-- Bad - All on one line (hard to read)
SELECT trade_id, symbol, quantity, trade_price, quantity * trade_price AS trade_value, execution_date FROM trades;

-- Acceptable for very short queries
SELECT COUNT(*) FROM trades;
SELECT * FROM trades WHERE trade_id = 'T001';
```

### JOIN Formatting

**Clear JOIN structure**:
```sql
-- Good - Each JOIN on separate lines, conditions aligned
SELECT 
    t.trade_id,
    t.symbol,
    tr.trader_name,
    s.company_name,
    t.quantity,
    t.trade_price
FROM trades t
INNER JOIN traders tr 
    ON t.trader_id = tr.trader_id
INNER JOIN symbols s 
    ON t.symbol = s.symbol
LEFT JOIN trade_settlements ts 
    ON t.trade_id = ts.trade_id
WHERE t.trade_date = CURRENT_DATE
ORDER BY t.trade_id;

-- Bad - Joins cramped together
SELECT t.trade_id, tr.trader_name, s.company_name
FROM trades t INNER JOIN traders tr ON t.trader_id = tr.trader_id
INNER JOIN symbols s ON t.symbol = s.symbol;
```

### WHERE Clause Formatting

```sql
-- Good - One condition per line for complex queries
SELECT *
FROM trades
WHERE trade_date >= '2024-01-01'
    AND trade_date < '2024-02-01'
    AND symbol IN ('AAPL', 'GOOGL', 'MSFT')
    AND quantity > 100
    AND is_executed = TRUE;

-- Good - Parentheses for complex logic
SELECT *
FROM trades
WHERE (
        trade_date >= '2024-01-01'
        AND trade_date < '2024-02-01'
    )
    AND (
        symbol = 'AAPL'
        OR symbol = 'GOOGL'
    );

-- Acceptable for simple queries
SELECT * FROM trades WHERE trade_id = 'T001';
```

---

## Query Structure

### SELECT Statement Order

**Standard order** (helps readability):
```sql
SELECT          -- 1. Select columns
    column1,
    column2
FROM table1     -- 2. From main table
INNER JOIN      -- 3. Joins
    table2 ON ...
WHERE           -- 4. Filter conditions
    condition1
    AND condition2
GROUP BY        -- 5. Grouping
    column1
HAVING          -- 6. Group filters
    condition
ORDER BY        -- 7. Sorting
    column1
LIMIT 100       -- 8. Limit results
OFFSET 0;       -- 9. Offset (pagination)
```

### Column Aliases

**Use AS keyword** for clarity:
```sql
-- Good - Explicit AS
SELECT 
    trade_id AS id,
    quantity * trade_price AS total_value,
    UPPER(symbol) AS symbol_upper,
    trader_id AS trader
FROM trades;

-- Bad - No AS (works but less clear)
SELECT 
    trade_id id,
    quantity * trade_price total_value,
    UPPER(symbol) symbol_upper
FROM trades;
```

**Alias names** should be descriptive:
```sql
-- Good
SELECT 
    COUNT(*) AS trade_count,
    SUM(quantity * trade_price) AS total_value,
    AVG(trade_price) AS average_price
FROM trades;

-- Bad
SELECT 
    COUNT(*) AS c,
    SUM(quantity * trade_price) AS tv,
    AVG(trade_price) AS ap
FROM trades;
```

### Table Aliases

**Use meaningful aliases**:
```sql
-- Good - Meaningful aliases
SELECT 
    t.trade_id,
    tr.trader_name,
    s.company_name
FROM trades t
INNER JOIN traders tr ON t.trader_id = tr.trader_id
INNER JOIN symbols s ON t.symbol = s.symbol;

-- Acceptable for very short queries
SELECT 
    a.name,
    b.value
FROM table_a a
INNER JOIN table_b b ON a.id = b.a_id;

-- Bad - Meaningless aliases
SELECT 
    x.trade_id,
    y.trader_name
FROM trades x
INNER JOIN traders y ON x.trader_id = y.trader_id;
```

---

## Comments and Documentation

### Query Documentation

**Header comment** for complex queries:
```sql
/*
 * Query: Daily Trade Summary Report
 * Description: Generates summary of all trades for a given day
 * Author: Trading Systems Team
 * Date: 2024-10-28
 * 
 * Parameters:
 *   - trade_date: Date to generate report for
 *
 * Returns:
 *   - Trader name, number of trades, total value
 *
 * Notes:
 *   - Only includes executed trades
 *   - Excludes cancelled trades
 */
SELECT 
    tr.trader_name,
    COUNT(*) AS trade_count,
    SUM(t.quantity * t.trade_price) AS total_value
FROM trades t
INNER JOIN traders tr ON t.trader_id = tr.trader_id
WHERE t.trade_date = '2024-10-28'
    AND t.is_executed = TRUE
    AND t.is_cancelled = FALSE
GROUP BY tr.trader_name
ORDER BY total_value DESC;
```

### Inline Comments

```sql
-- Good - Explains business logic
SELECT 
    trade_id,
    quantity * trade_price AS trade_value,
    -- Apply 0.5% commission fee
    quantity * trade_price * 0.005 AS commission,
    -- Net value after commission
    quantity * trade_price * 0.995 AS net_value
FROM trades;

-- Good - Complex condition explanation
SELECT *
FROM trades
WHERE 
    -- Trading hours: 9:30 AM - 4:00 PM EST
    EXTRACT(HOUR FROM execution_time) >= 9
    AND EXTRACT(HOUR FROM execution_time) < 16
    -- Only regular trading days (exclude weekends)
    AND EXTRACT(DOW FROM execution_time) BETWEEN 1 AND 5;

-- Bad - Obvious comments
SELECT 
    trade_id,  -- Select trade ID
    symbol     -- Select symbol
FROM trades;   -- From trades table
```

---

## Join Standards

### Explicit JOIN Syntax

**Always use explicit JOIN** syntax (not WHERE clause joins):
```sql
-- Good - Explicit INNER JOIN
SELECT 
    t.trade_id,
    tr.trader_name
FROM trades t
INNER JOIN traders tr ON t.trader_id = tr.trader_id;

-- Bad - Old-style WHERE clause join (avoid)
SELECT 
    t.trade_id,
    tr.trader_name
FROM trades t, traders tr
WHERE t.trader_id = tr.trader_id;
```

### JOIN Types

**Be explicit** about JOIN type:
```sql
-- Good - Explicit INNER JOIN
SELECT * FROM trades t
INNER JOIN symbols s ON t.symbol = s.symbol;

-- Good - Explicit LEFT JOIN
SELECT * FROM trades t
LEFT JOIN trade_settlements ts ON t.trade_id = ts.trade_id;

-- Bad - Implicit JOIN (avoid, ambiguous)
SELECT * FROM trades t
JOIN symbols s ON t.symbol = s.symbol;  -- Is this INNER or LEFT?
```

---

## Subquery Standards

### Subquery Formatting

```sql
-- Good - Subquery on separate lines, indented
SELECT 
    trade_id,
    symbol,
    quantity
FROM trades
WHERE trader_id IN (
    SELECT trader_id
    FROM traders
    WHERE department = 'Equity'
);

-- Good - Complex subquery
SELECT 
    t.symbol,
    t.total_quantity,
    (
        SELECT AVG(trade_price)
        FROM trades t2
        WHERE t2.symbol = t.symbol
    ) AS avg_price
FROM (
    SELECT 
        symbol,
        SUM(quantity) AS total_quantity
    FROM trades
    GROUP BY symbol
) t;

-- Bad - Cramped formatting
SELECT trade_id, symbol FROM trades WHERE trader_id IN (SELECT trader_id FROM traders WHERE department = 'Equity');
```

### CTE (Common Table Expressions)

**Prefer CTEs** over subqueries for readability:
```sql
-- Good - Using CTE
WITH equity_traders AS (
    SELECT trader_id
    FROM traders
    WHERE department = 'Equity'
),
daily_trades AS (
    SELECT 
        trader_id,
        COUNT(*) AS trade_count,
        SUM(quantity * trade_price) AS total_value
    FROM trades
    WHERE trade_date = CURRENT_DATE
    GROUP BY trader_id
)
SELECT 
    et.trader_id,
    dt.trade_count,
    dt.total_value
FROM equity_traders et
LEFT JOIN daily_trades dt ON et.trader_id = dt.trader_id;

-- Less readable - Nested subqueries
SELECT 
    et.trader_id,
    dt.trade_count,
    dt.total_value
FROM (
    SELECT trader_id FROM traders WHERE department = 'Equity'
) et
LEFT JOIN (
    SELECT trader_id, COUNT(*) AS trade_count, SUM(quantity * trade_price) AS total_value
    FROM trades WHERE trade_date = CURRENT_DATE GROUP BY trader_id
) dt ON et.trader_id = dt.trader_id;
```

---

## Stored Procedure Standards

### Naming Convention

**Procedures**: `sp_verb_noun` or `verb_noun`
```sql
-- Good
CREATE PROCEDURE sp_process_daily_trades()
CREATE PROCEDURE calculate_portfolio_value()
CREATE PROCEDURE validate_trade_limits()

-- Bad
CREATE PROCEDURE proc1()          -- Not descriptive
CREATE PROCEDURE ProcessTrades()  -- PascalCase
```

### Procedure Structure

```sql
-- Good - Well-structured procedure
CREATE PROCEDURE sp_process_trades(
    IN p_trade_date DATE,
    IN p_trader_id VARCHAR(10),
    OUT p_trade_count INT,
    OUT p_total_value DECIMAL(15,2)
)
BEGIN
    -- Declare variables
    DECLARE v_error_count INT DEFAULT 0;
    
    -- Log start
    INSERT INTO process_log (procedure_name, start_time)
    VALUES ('sp_process_trades', NOW());
    
    -- Main processing
    SELECT 
        COUNT(*),
        SUM(quantity * trade_price)
    INTO p_trade_count, p_total_value
    FROM trades
    WHERE trade_date = p_trade_date
        AND (p_trader_id IS NULL OR trader_id = p_trader_id);
    
    -- Error handling
    IF p_trade_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No trades found for specified criteria';
    END IF;
    
    -- Log completion
    INSERT INTO process_log (procedure_name, end_time, status)
    VALUES ('sp_process_trades', NOW(), 'SUCCESS');
    
END;
```

---

## Capital Markets Specific Standards

### Table Naming for Trading

```sql
-- Good - Clear trading domain tables
CREATE TABLE trades (...)
CREATE TABLE trade_executions (...)
CREATE TABLE trade_settlements (...)
CREATE TABLE market_data (...)
CREATE TABLE positions (...)
CREATE TABLE portfolios (...)
CREATE TABLE risk_limits (...)
```

### Column Naming for Trading

```sql
-- Good - Trading-specific columns
CREATE TABLE trades (
    trade_id VARCHAR(20) PRIMARY KEY,
    order_id VARCHAR(20),
    trader_id VARCHAR(10),
    symbol VARCHAR(10),
    side VARCHAR(4),              -- BUY/SELL
    order_type VARCHAR(20),       -- MARKET/LIMIT
    quantity INT,
    limit_price DECIMAL(10,2),
    execution_price DECIMAL(10,2),
    trade_value DECIMAL(15,2),
    commission DECIMAL(10,2),
    trade_date DATE,
    execution_time TIMESTAMP,
    settlement_date DATE,
    is_executed BOOLEAN,
    is_settled BOOLEAN,
    is_cancelled BOOLEAN
);
```

### Common Queries - Standard Format

```sql
-- Trade Summary by Trader
SELECT 
    tr.trader_id,
    tr.trader_name,
    COUNT(t.trade_id) AS trade_count,
    SUM(t.quantity) AS total_quantity,
    SUM(t.trade_value) AS total_value,
    AVG(t.trade_value) AS avg_trade_value
FROM traders tr
LEFT JOIN trades t 
    ON tr.trader_id = t.trader_id
    AND t.trade_date = CURRENT_DATE
GROUP BY tr.trader_id, tr.trader_name
ORDER BY total_value DESC;

-- Position Summary by Symbol
SELECT 
    symbol,
    SUM(CASE WHEN side = 'BUY' THEN quantity ELSE -quantity END) AS net_position,
    SUM(CASE WHEN side = 'BUY' THEN trade_value ELSE 0 END) AS total_buys,
    SUM(CASE WHEN side = 'SELL' THEN trade_value ELSE 0 END) AS total_sells
FROM trades
WHERE trade_date = CURRENT_DATE
    AND is_executed = TRUE
GROUP BY symbol
HAVING net_position != 0
ORDER BY net_position DESC;
```

---

## Performance Best Practices

### Index Usage

```sql
-- Good - Use indexed columns in WHERE
SELECT * FROM trades 
WHERE trade_date = '2024-10-28'  -- Assuming index on trade_date
    AND symbol = 'AAPL';          -- Assuming index on symbol

-- Bad - Function on indexed column (prevents index use)
SELECT * FROM trades 
WHERE DATE(execution_time) = '2024-10-28';  -- Can't use index

-- Better - Range on indexed column
SELECT * FROM trades 
WHERE execution_time >= '2024-10-28 00:00:00'
    AND execution_time < '2024-10-29 00:00:00';
```

### SELECT Specific Columns

```sql
-- Good - Select only needed columns
SELECT trade_id, symbol, quantity 
FROM trades;

-- Bad - SELECT * (wastes resources, breaks code if schema changes)
SELECT * FROM trades;
```

---

## Quick Reference

### Naming Summary

| Object | Convention | Example |
|--------|-----------|---------|
| Tables | `snake_case` plural | `trades`, `trade_settlements` |
| Columns | `snake_case` | `trade_id`, `execution_date` |
| Primary Key | `table_name_id` or `id` | `trade_id`, `id` |
| Foreign Key | `referenced_table_id` | `trader_id`, `symbol_id` |
| Indexes | `idx_table_column` | `idx_trades_symbol` |
| Unique Index | `uq_table_column` | `uq_trades_trade_number` |
| PK Constraint | `pk_tablename` | `pk_trades` |
| FK Constraint | `fk_table_reftable` | `fk_trades_traders` |
| Check Constraint | `chk_table_column_desc` | `chk_trades_qty_positive` |
| Procedures | `sp_verb_noun` | `sp_process_trades` |

### Formatting Summary

- **Keywords**: UPPERCASE
- **Identifiers**: lowercase
- **Indentation**: 4 spaces
- **One column per line**: For readability
- **Explicit JOINs**: Always use INNER/LEFT/RIGHT
- **Comments**: Explain WHY, not WHAT

---

*Last Updated: 2024-10-28*  
*Follow these standards for consistent, maintainable SQL code*

