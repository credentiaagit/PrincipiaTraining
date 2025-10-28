-- ============================================================================
-- File: 02-advanced-sql-queries.sql
-- Purpose: Advanced SQL queries for capital markets database
-- Author: Training Team
-- Usage: Execute in your SQL client (MySQL, PostgreSQL, Oracle, etc.)
-- ============================================================================

-- ============================================================================
-- SECTION 1: Complex Joins
-- ============================================================================

-- Example 1.1: Multiple Table JOIN
-- Get complete trade information with client and symbol details
SELECT 
    t.trade_id,
    t.trade_date,
    c.client_name,
    c.account_id,
    s.symbol,
    s.company_name,
    t.quantity,
    t.price,
    t.quantity * t.price AS trade_value,
    t.trade_type,
    t.status
FROM trades t
INNER JOIN clients c ON t.client_id = c.client_id
INNER JOIN symbols s ON t.symbol_id = s.symbol_id
WHERE t.trade_date = CURRENT_DATE
ORDER BY t.trade_date DESC, t.trade_id;

-- Example 1.2: LEFT JOIN - Find clients with no trades today
SELECT 
    c.client_id,
    c.client_name,
    c.account_id,
    COUNT(t.trade_id) AS trade_count
FROM clients c
LEFT JOIN trades t ON c.client_id = t.client_id 
    AND t.trade_date = CURRENT_DATE
GROUP BY c.client_id, c.client_name, c.account_id
HAVING COUNT(t.trade_id) = 0;

-- Example 1.3: SELF JOIN - Find trades with same symbol but different prices
SELECT 
    t1.trade_id AS trade_1,
    t2.trade_id AS trade_2,
    t1.symbol_id,
    t1.price AS price_1,
    t2.price AS price_2,
    ABS(t1.price - t2.price) AS price_diff
FROM trades t1
INNER JOIN trades t2 ON t1.symbol_id = t2.symbol_id
    AND t1.trade_id < t2.trade_id
    AND t1.trade_date = t2.trade_date
WHERE ABS(t1.price - t2.price) > 1.0
ORDER BY price_diff DESC;

-- ============================================================================
-- SECTION 2: Subqueries
-- ============================================================================

-- Example 2.1: Subquery in WHERE clause
-- Find trades with above-average value
SELECT 
    trade_id,
    symbol_id,
    quantity,
    price,
    quantity * price AS trade_value
FROM trades
WHERE quantity * price > (
    SELECT AVG(quantity * price)
    FROM trades
    WHERE trade_date = CURRENT_DATE
)
ORDER BY trade_value DESC;

-- Example 2.2: Correlated Subquery
-- Find clients who traded more than their own average
SELECT 
    c.client_id,
    c.client_name,
    t.trade_id,
    t.quantity * t.price AS trade_value
FROM clients c
INNER JOIN trades t ON c.client_id = t.client_id
WHERE t.quantity * t.price > (
    SELECT AVG(t2.quantity * t2.price)
    FROM trades t2
    WHERE t2.client_id = c.client_id
);

-- Example 2.3: Subquery in FROM clause (Derived Table)
-- Get top traders by total volume
SELECT 
    ranked_clients.client_name,
    ranked_clients.total_value,
    ranked_clients.trade_count,
    ranked_clients.rank_position
FROM (
    SELECT 
        c.client_name,
        SUM(t.quantity * t.price) AS total_value,
        COUNT(t.trade_id) AS trade_count,
        RANK() OVER (ORDER BY SUM(t.quantity * t.price) DESC) AS rank_position
    FROM clients c
    INNER JOIN trades t ON c.client_id = t.client_id
    WHERE t.trade_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
    GROUP BY c.client_id, c.client_name
) AS ranked_clients
WHERE ranked_clients.rank_position <= 10;

-- Example 2.4: EXISTS Subquery
-- Find clients who have traded in the last 7 days
SELECT 
    c.client_id,
    c.client_name,
    c.account_id
FROM clients c
WHERE EXISTS (
    SELECT 1
    FROM trades t
    WHERE t.client_id = c.client_id
        AND t.trade_date >= DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY)
);

-- ============================================================================
-- SECTION 3: Window Functions
-- ============================================================================

-- Example 3.1: Running Total
-- Calculate running total of trade values by date
SELECT 
    trade_date,
    trade_id,
    symbol_id,
    quantity * price AS trade_value,
    SUM(quantity * price) OVER (
        ORDER BY trade_date, trade_id
    ) AS running_total
FROM trades
WHERE trade_date >= DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY)
ORDER BY trade_date, trade_id;

-- Example 3.2: Ranking Functions
-- Rank symbols by trading volume
SELECT 
    s.symbol,
    s.company_name,
    SUM(t.quantity) AS total_quantity,
    SUM(t.quantity * t.price) AS total_value,
    RANK() OVER (ORDER BY SUM(t.quantity * t.price) DESC) AS value_rank,
    DENSE_RANK() OVER (ORDER BY SUM(t.quantity) DESC) AS quantity_rank,
    ROW_NUMBER() OVER (ORDER BY SUM(t.quantity * t.price) DESC) AS row_num
FROM symbols s
INNER JOIN trades t ON s.symbol_id = t.symbol_id
WHERE t.trade_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
GROUP BY s.symbol_id, s.symbol, s.company_name
ORDER BY value_rank;

-- Example 3.3: Moving Average
-- Calculate 5-day moving average of trading volume per symbol
SELECT 
    trade_date,
    symbol_id,
    SUM(quantity) AS daily_volume,
    AVG(SUM(quantity)) OVER (
        PARTITION BY symbol_id
        ORDER BY trade_date
        ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
    ) AS moving_avg_5day
FROM trades
WHERE trade_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
GROUP BY trade_date, symbol_id
ORDER BY symbol_id, trade_date;

-- Example 3.4: LAG and LEAD Functions
-- Compare current price with previous trade
SELECT 
    trade_id,
    symbol_id,
    trade_date,
    price AS current_price,
    LAG(price) OVER (
        PARTITION BY symbol_id 
        ORDER BY trade_date, trade_id
    ) AS previous_price,
    price - LAG(price) OVER (
        PARTITION BY symbol_id 
        ORDER BY trade_date, trade_id
    ) AS price_change,
    LEAD(price) OVER (
        PARTITION BY symbol_id 
        ORDER BY trade_date, trade_id
    ) AS next_price
FROM trades
WHERE trade_date >= DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY)
ORDER BY symbol_id, trade_date, trade_id;

-- ============================================================================
-- SECTION 4: Common Table Expressions (CTEs)
-- ============================================================================

-- Example 4.1: Simple CTE
-- Calculate client trading statistics
WITH client_stats AS (
    SELECT 
        client_id,
        COUNT(trade_id) AS trade_count,
        SUM(quantity * price) AS total_value,
        AVG(quantity * price) AS avg_value,
        MIN(trade_date) AS first_trade,
        MAX(trade_date) AS last_trade
    FROM trades
    WHERE trade_date >= DATE_SUB(CURRENT_DATE, INTERVAL 90 DAY)
    GROUP BY client_id
)
SELECT 
    c.client_name,
    cs.trade_count,
    cs.total_value,
    cs.avg_value,
    cs.first_trade,
    cs.last_trade,
    DATEDIFF(cs.last_trade, cs.first_trade) AS days_active
FROM client_stats cs
INNER JOIN clients c ON cs.client_id = c.client_id
WHERE cs.trade_count >= 10
ORDER BY cs.total_value DESC;

-- Example 4.2: Multiple CTEs
-- Analyze trading patterns
WITH 
daily_volumes AS (
    SELECT 
        trade_date,
        symbol_id,
        SUM(quantity) AS daily_qty,
        SUM(quantity * price) AS daily_value,
        COUNT(trade_id) AS daily_trades
    FROM trades
    WHERE trade_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
    GROUP BY trade_date, symbol_id
),
symbol_averages AS (
    SELECT 
        symbol_id,
        AVG(daily_qty) AS avg_qty,
        AVG(daily_value) AS avg_value,
        AVG(daily_trades) AS avg_trades
    FROM daily_volumes
    GROUP BY symbol_id
)
SELECT 
    s.symbol,
    s.company_name,
    sa.avg_qty,
    sa.avg_value,
    sa.avg_trades,
    dv.trade_date,
    dv.daily_qty,
    dv.daily_value,
    CASE 
        WHEN dv.daily_value > sa.avg_value * 1.5 THEN 'High Volume'
        WHEN dv.daily_value < sa.avg_value * 0.5 THEN 'Low Volume'
        ELSE 'Normal'
    END AS volume_category
FROM daily_volumes dv
INNER JOIN symbol_averages sa ON dv.symbol_id = sa.symbol_id
INNER JOIN symbols s ON dv.symbol_id = s.symbol_id
WHERE dv.trade_date >= DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY)
ORDER BY s.symbol, dv.trade_date;

-- Example 4.3: Recursive CTE
-- Hierarchical organization structure
WITH RECURSIVE org_hierarchy AS (
    -- Base case: top-level managers
    SELECT 
        employee_id,
        employee_name,
        manager_id,
        1 AS level,
        CAST(employee_name AS CHAR(1000)) AS hierarchy_path
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- Recursive case: employees under managers
    SELECT 
        e.employee_id,
        e.employee_name,
        e.manager_id,
        oh.level + 1,
        CONCAT(oh.hierarchy_path, ' > ', e.employee_name)
    FROM employees e
    INNER JOIN org_hierarchy oh ON e.manager_id = oh.employee_id
    WHERE oh.level < 10  -- Prevent infinite recursion
)
SELECT 
    employee_id,
    CONCAT(REPEAT('  ', level - 1), employee_name) AS employee_hierarchy,
    level,
    hierarchy_path
FROM org_hierarchy
ORDER BY hierarchy_path;

-- ============================================================================
-- SECTION 5: Pivot and Unpivot
-- ============================================================================

-- Example 5.1: Pivot - Trading volume by symbol and month
SELECT 
    symbol_id,
    SUM(CASE WHEN MONTH(trade_date) = 1 THEN quantity ELSE 0 END) AS Jan,
    SUM(CASE WHEN MONTH(trade_date) = 2 THEN quantity ELSE 0 END) AS Feb,
    SUM(CASE WHEN MONTH(trade_date) = 3 THEN quantity ELSE 0 END) AS Mar,
    SUM(CASE WHEN MONTH(trade_date) = 4 THEN quantity ELSE 0 END) AS Apr,
    SUM(CASE WHEN MONTH(trade_date) = 5 THEN quantity ELSE 0 END) AS May,
    SUM(CASE WHEN MONTH(trade_date) = 6 THEN quantity ELSE 0 END) AS Jun,
    SUM(CASE WHEN MONTH(trade_date) = 7 THEN quantity ELSE 0 END) AS Jul,
    SUM(CASE WHEN MONTH(trade_date) = 8 THEN quantity ELSE 0 END) AS Aug,
    SUM(CASE WHEN MONTH(trade_date) = 9 THEN quantity ELSE 0 END) AS Sep,
    SUM(CASE WHEN MONTH(trade_date) = 10 THEN quantity ELSE 0 END) AS Oct,
    SUM(CASE WHEN MONTH(trade_date) = 11 THEN quantity ELSE 0 END) AS Nov,
    SUM(CASE WHEN MONTH(trade_date) = 12 THEN quantity ELSE 0 END) AS Dec,
    SUM(quantity) AS Total
FROM trades
WHERE YEAR(trade_date) = YEAR(CURRENT_DATE)
GROUP BY symbol_id;

-- Example 5.2: Dynamic Pivot using GROUP_CONCAT (MySQL specific)
SELECT 
    client_id,
    GROUP_CONCAT(
        CONCAT(symbol_id, ':', quantity) 
        ORDER BY trade_date 
        SEPARATOR '; '
    ) AS trading_activity
FROM trades
WHERE trade_date >= DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY)
GROUP BY client_id;

-- ============================================================================
-- SECTION 6: Advanced Aggregations
-- ============================================================================

-- Example 6.1: ROLLUP - Hierarchical Totals
SELECT 
    COALESCE(s.symbol, 'TOTAL') AS symbol,
    COALESCE(t.trade_type, 'ALL TYPES') AS trade_type,
    COUNT(t.trade_id) AS trade_count,
    SUM(t.quantity * t.price) AS total_value
FROM trades t
LEFT JOIN symbols s ON t.symbol_id = s.symbol_id
WHERE t.trade_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
GROUP BY s.symbol, t.trade_type WITH ROLLUP;

-- Example 6.2: GROUPING SETS
SELECT 
    CASE 
        WHEN GROUPING(symbol_id) = 1 THEN 'ALL SYMBOLS'
        ELSE CAST(symbol_id AS CHAR)
    END AS symbol,
    CASE 
        WHEN GROUPING(trade_type) = 1 THEN 'ALL TYPES'
        ELSE trade_type
    END AS type,
    CASE 
        WHEN GROUPING(status) = 1 THEN 'ALL STATUS'
        ELSE status
    END AS status,
    COUNT(trade_id) AS trade_count,
    SUM(quantity * price) AS total_value
FROM trades
WHERE trade_date >= DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY)
GROUP BY GROUPING SETS (
    (symbol_id, trade_type, status),
    (symbol_id, trade_type),
    (symbol_id),
    ()
);

-- Example 6.3: CUBE - All possible combinations
SELECT 
    COALESCE(CAST(symbol_id AS CHAR), 'ALL') AS symbol,
    COALESCE(trade_type, 'ALL') AS type,
    COALESCE(status, 'ALL') AS status,
    COUNT(trade_id) AS trade_count,
    SUM(quantity * price) AS total_value
FROM trades
WHERE trade_date = CURRENT_DATE
GROUP BY symbol_id, trade_type, status WITH CUBE;

-- ============================================================================
-- SECTION 7: Date and Time Functions
-- ============================================================================

-- Example 7.1: Trading activity by time periods
SELECT 
    trade_date,
    DAYNAME(trade_date) AS day_of_week,
    WEEK(trade_date) AS week_number,
    MONTH(trade_date) AS month_number,
    MONTHNAME(trade_date) AS month_name,
    QUARTER(trade_date) AS quarter,
    COUNT(trade_id) AS trade_count,
    SUM(quantity * price) AS total_value
FROM trades
WHERE trade_date >= DATE_SUB(CURRENT_DATE, INTERVAL 90 DAY)
GROUP BY trade_date
ORDER BY trade_date;

-- Example 7.2: Business days calculation
SELECT 
    trade_date,
    COUNT(trade_id) AS trades_today,
    SUM(COUNT(trade_id)) OVER (
        ORDER BY trade_date
    ) AS cumulative_trades,
    (
        SELECT COUNT(DISTINCT trade_date)
        FROM trades t2
        WHERE t2.trade_date <= t.trade_date
            AND t2.trade_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
            AND DAYOFWEEK(t2.trade_date) NOT IN (1, 7)  -- Exclude weekends
    ) AS business_days_count
FROM trades t
WHERE trade_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
GROUP BY trade_date
HAVING COUNT(trade_id) > 0
ORDER BY trade_date;

-- ============================================================================
-- SECTION 8: String Manipulation
-- ============================================================================

-- Example 8.1: Text analysis and formatting
SELECT 
    client_id,
    client_name,
    UPPER(client_name) AS uppercase_name,
    LOWER(client_name) AS lowercase_name,
    LENGTH(client_name) AS name_length,
    SUBSTRING(client_name, 1, 3) AS initials,
    CONCAT(client_name, ' (', account_id, ')') AS full_description,
    REPLACE(email, '@', ' AT ') AS masked_email
FROM clients
WHERE status = 'ACTIVE';

-- Example 8.2: Pattern matching with REGEXP
SELECT 
    trade_id,
    symbol_id,
    notes
FROM trades
WHERE notes REGEXP 'urgent|priority|critical'
    AND trade_date >= DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY);

-- ============================================================================
-- SECTION 9: Performance Optimization Queries
-- ============================================================================

-- Example 9.1: Using indexes effectively
EXPLAIN SELECT 
    t.trade_id,
    t.symbol_id,
    t.price
FROM trades t
WHERE t.symbol_id = 'AAPL'
    AND t.trade_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
    AND t.status = 'COMPLETED';

-- Example 9.2: Avoiding full table scans
SELECT 
    symbol_id,
    COUNT(*) AS trade_count
FROM trades
WHERE trade_date BETWEEN '2024-01-01' AND '2024-12-31'
    AND status = 'COMPLETED'
GROUP BY symbol_id
HAVING COUNT(*) > 100;

-- ============================================================================
-- SECTION 10: Data Quality and Validation
-- ============================================================================

-- Example 10.1: Find data quality issues
SELECT 
    'Missing Price' AS issue_type,
    COUNT(*) AS issue_count
FROM trades
WHERE price IS NULL OR price <= 0

UNION ALL

SELECT 
    'Missing Quantity',
    COUNT(*)
FROM trades
WHERE quantity IS NULL OR quantity <= 0

UNION ALL

SELECT 
    'Future Dates',
    COUNT(*)
FROM trades
WHERE trade_date > CURRENT_DATE

UNION ALL

SELECT 
    'Duplicate Trades',
    COUNT(*) - COUNT(DISTINCT trade_id)
FROM trades;

-- Example 10.2: Referential integrity check
SELECT 
    'Trades with invalid client_id' AS issue,
    COUNT(*) AS count
FROM trades t
LEFT JOIN clients c ON t.client_id = c.client_id
WHERE c.client_id IS NULL

UNION ALL

SELECT 
    'Trades with invalid symbol_id',
    COUNT(*)
FROM trades t
LEFT JOIN symbols s ON t.symbol_id = s.symbol_id
WHERE s.symbol_id IS NULL;

-- ============================================================================
-- End of Advanced SQL Queries
-- ============================================================================

