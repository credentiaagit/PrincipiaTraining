# SQL Exercises for Capital Markets

## Level 1: Basic Queries

### Exercise 1: Simple SELECT
**Task**: Write queries to:
1. Select all trades
2. Select only trade_id, symbol, and price
3. Select distinct symbols

**Answer**:
```sql
-- 1. All trades
SELECT * FROM trades;

-- 2. Specific columns
SELECT trade_id, symbol, price FROM trades;

-- 3. Distinct symbols
SELECT DISTINCT symbol FROM trades;
```

---

### Exercise 2: Filtering
**Task**: Find:
1. All AAPL trades
2. Trades with price > $150
3. Trades with quantity between 50 and 200

**Answer**:
```sql
-- 1. AAPL trades
SELECT * FROM trades WHERE symbol = 'AAPL';

-- 2. Price > 150
SELECT * FROM trades WHERE price > 150;

-- 3. Quantity 50-200
SELECT * FROM trades
WHERE quantity BETWEEN 50 AND 200;
```

---

## Level 2: Aggregations

### Exercise 3: Aggregate Functions
**Task**: Calculate:
1. Total number of trades
2. Average trade price
3. Total trading volume

**Answer**:
```sql
-- 1. Count trades
SELECT COUNT(*) AS total_trades FROM trades;

-- 2. Average price
SELECT AVG(price) AS avg_price FROM trades;

-- 3. Total volume
SELECT SUM(quantity) AS total_volume FROM trades;
```

---

### Exercise 4: GROUP BY
**Task**: Calculate trade count and total value by symbol.

**Answer**:
```sql
SELECT 
    symbol,
    COUNT(*) AS trade_count,
    SUM(quantity * price) AS total_value
FROM trades
GROUP BY symbol
ORDER BY total_value DESC;
```

---

## Level 3: Joins

### Exercise 5: INNER JOIN
**Task**: Join trades with traders to show trade ID, symbol, and trader name.

**Answer**:
```sql
SELECT 
    t.trade_id,
    t.symbol,
    t.quantity,
    t.price,
    tr.trader_name
FROM trades t
INNER JOIN traders tr ON t.trader_id = tr.trader_id;
```

---

### Exercise 6: Multiple Joins
**Task**: Join trades, traders, and symbols to show complete trade information.

**Answer**:
```sql
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
JOIN traders tr ON t.trader_id = tr.trader_id
ORDER BY value DESC;
```

---

## Level 4: Advanced Queries

### Exercise 7: Subqueries
**Task**: Find trades with above-average price.

**Answer**:
```sql
SELECT * FROM trades
WHERE price > (SELECT AVG(price) FROM trades)
ORDER BY price DESC;
```

---

### Exercise 8: Complex Aggregation
**Task**: Show top 5 traders by total trade value with department info.

**Answer**:
```sql
SELECT 
    tr.trader_name,
    tr.department,
    COUNT(t.trade_id) AS trade_count,
    SUM(t.quantity * t.price) AS total_value
FROM trades t
JOIN traders tr ON t.trader_id = tr.trader_id
GROUP BY tr.trader_id, tr.trader_name, tr.department
ORDER BY total_value DESC
LIMIT 5;
```

---

## Level 5: Real-World Scenarios

### Exercise 9: Daily Summary Report
**Task**: Create a daily summary showing:
- Total trades
- Total value
- Number of unique symbols
- Average trade value

**Answer**:
```sql
SELECT 
    trade_date,
    COUNT(*) AS total_trades,
    COUNT(DISTINCT symbol) AS unique_symbols,
    SUM(quantity * price) AS total_value,
    AVG(quantity * price) AS avg_value,
    MIN(price) AS min_price,
    MAX(price) AS max_price
FROM trades
WHERE trade_date = '2024-10-28'
GROUP BY trade_date;
```

---

### Exercise 10: Position Calculation
**Task**: Calculate current positions from trade history.

**Answer**:
```sql
SELECT 
    account_id,
    symbol,
    SUM(CASE 
        WHEN side = 'BUY' THEN quantity
        WHEN side = 'SELL' THEN -quantity
    END) AS net_position
FROM trades
WHERE status = 'SETTLED'
GROUP BY account_id, symbol
HAVING SUM(CASE 
    WHEN side = 'BUY' THEN quantity
    WHEN side = 'SELL' THEN -quantity
END) != 0
ORDER BY account_id, symbol;
```

---

## Challenge Problems

### Challenge 1: Top Trader by Department
Find the top trader (by value) in each department.

### Challenge 2: Volatility Analysis
Calculate price volatility (standard deviation) for each symbol.

### Challenge 3: Rolling Average
Calculate 7-day moving average of trading volume by symbol.

---

## Practice Tips

1. Start with simple queries
2. Test queries with small datasets
3. Use EXPLAIN to understand query plans
4. Practice joins thoroughly
5. Learn subquery patterns
6. Optimize with indexes

---

## Next Steps

1. Practice all exercises
2. Create your own queries
3. Study query performance
4. Learn about stored procedures
5. Master transaction management

**Keep practicing SQL!** 🚀

