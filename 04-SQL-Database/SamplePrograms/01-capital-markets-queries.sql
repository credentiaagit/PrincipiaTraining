/*
 * Capital Markets - SQL Sample Queries
 * Comprehensive examples for trading system database
 */

-- ==========================================
-- 1. DAILY TRADING SUMMARY
-- ==========================================

-- Daily trade statistics
SELECT 
    trade_date,
    COUNT(*) AS total_trades,
    COUNT(DISTINCT symbol) AS unique_symbols,
    COUNT(DISTINCT trader_id) AS active_traders,
    SUM(quantity * price) AS total_value,
    AVG(quantity * price) AS avg_trade_value,
    MIN(price) AS lowest_price,
    MAX(price) AS highest_price
FROM trades
WHERE trade_date = '2024-10-28'
GROUP BY trade_date;

-- ==========================================
-- 2. TOP PERFORMERS
-- ==========================================

-- Top 10 symbols by trading volume
SELECT 
    symbol,
    COUNT(*) AS trade_count,
    SUM(quantity) AS total_volume,
    SUM(quantity * price) AS total_value,
    AVG(price) AS avg_price
FROM trades
WHERE trade_date >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY symbol
ORDER BY total_value DESC
LIMIT 10;

-- Top traders by trade count
SELECT 
    t.trader_id,
    tr.trader_name,
    tr.department,
    COUNT(*) AS trade_count,
    SUM(t.quantity * t.price) AS total_value
FROM trades t
JOIN traders tr ON t.trader_id = tr.trader_id
WHERE t.trade_date = CURRENT_DATE
GROUP BY t.trader_id, tr.trader_name, tr.department
ORDER BY trade_count DESC
LIMIT 10;

-- ==========================================
-- 3. POSITION ANALYSIS
-- ==========================================

-- Current positions by account
SELECT 
    p.account_id,
    p.symbol,
    s.company_name,
    p.quantity,
    p.avg_cost,
    s.current_price,
    p.quantity * s.current_price AS market_value,
    p.quantity * (s.current_price - p.avg_cost) AS unrealized_pnl,
    ((s.current_price - p.avg_cost) / p.avg_cost) * 100 AS pnl_percent
FROM positions p
JOIN symbols s ON p.symbol = s.symbol
WHERE p.quantity != 0
ORDER BY unrealized_pnl DESC;

-- Portfolio concentration
SELECT 
    account_id,
    symbol,
    quantity * current_price AS position_value,
    (quantity * current_price / SUM(quantity * current_price) OVER (PARTITION BY account_id)) * 100 AS portfolio_pct
FROM positions p
JOIN symbols s ON p.symbol = s.symbol
WHERE quantity > 0
ORDER BY account_id, position_value DESC;

-- ==========================================
-- 4. RISK MANAGEMENT
-- ==========================================

-- Large trades (>$100K)
SELECT 
    t.trade_id,
    t.symbol,
    s.company_name,
    t.side,
    t.quantity,
    t.price,
    t.quantity * t.price AS trade_value,
    tr.trader_name,
    tr.department
FROM trades t
JOIN symbols s ON t.symbol = s.symbol
JOIN traders tr ON t.trader_id = tr.trader_id
WHERE t.quantity * t.price > 100000
  AND t.trade_date = CURRENT_DATE
ORDER BY trade_value DESC;

-- High concentration risk
SELECT 
    p.account_id,
    COUNT(DISTINCT p.symbol) AS num_positions,
    SUM(p.quantity * s.current_price) AS total_portfolio_value,
    MAX(p.quantity * s.current_price) AS largest_position,
    (MAX(p.quantity * s.current_price) / SUM(p.quantity * s.current_price)) * 100 AS concentration_pct
FROM positions p
JOIN symbols s ON p.symbol = s.symbol
WHERE p.quantity > 0
GROUP BY p.account_id
HAVING (MAX(p.quantity * s.current_price) / SUM(p.quantity * s.current_price)) > 0.25
ORDER BY concentration_pct DESC;

-- ==========================================
-- 5. TRADER PERFORMANCE
-- ==========================================

-- Trader activity by hour
SELECT 
    trader_id,
    EXTRACT(HOUR FROM trade_time) AS hour_of_day,
    COUNT(*) AS trade_count,
    SUM(quantity * price) AS total_value
FROM trades
WHERE trade_date = CURRENT_DATE
GROUP BY trader_id, EXTRACT(HOUR FROM trade_time)
ORDER BY trader_id, hour_of_day;

-- Trader buy/sell analysis
SELECT 
    tr.trader_name,
    SUM(CASE WHEN t.side = 'BUY' THEN 1 ELSE 0 END) AS buy_count,
    SUM(CASE WHEN t.side = 'SELL' THEN 1 ELSE 0 END) AS sell_count,
    SUM(CASE WHEN t.side = 'BUY' THEN t.quantity * t.price ELSE 0 END) AS buy_value,
    SUM(CASE WHEN t.side = 'SELL' THEN t.quantity * t.price ELSE 0 END) AS sell_value
FROM trades t
JOIN traders tr ON t.trader_id = tr.trader_id
WHERE t.trade_date >= CURRENT_DATE - INTERVAL '7 days'
GROUP BY tr.trader_id, tr.trader_name
ORDER BY (buy_value + sell_value) DESC;

-- ==========================================
-- 6. RECONCILIATION
-- ==========================================

-- Position reconciliation
SELECT 
    p.account_id,
    p.symbol,
    p.quantity AS book_position,
    COALESCE(SUM(
        CASE 
            WHEN t.side = 'BUY' THEN t.quantity
            WHEN t.side = 'SELL' THEN -t.quantity
        END
    ), 0) AS calculated_position,
    p.quantity - COALESCE(SUM(
        CASE 
            WHEN t.side = 'BUY' THEN t.quantity
            WHEN t.side = 'SELL' THEN -t.quantity
        END
    ), 0) AS break_quantity
FROM positions p
LEFT JOIN trades t ON p.account_id = t.account_id 
                   AND p.symbol = t.symbol
                   AND t.status = 'SETTLED'
GROUP BY p.account_id, p.symbol, p.quantity
HAVING p.quantity != COALESCE(SUM(
    CASE 
        WHEN t.side = 'BUY' THEN t.quantity
        WHEN t.side = 'SELL' THEN -t.quantity
    END
), 0);

-- ==========================================
-- 7. MARKET ANALYSIS
-- ==========================================

-- Most volatile symbols (price range)
SELECT 
    symbol,
    MIN(price) AS low_price,
    MAX(price) AS high_price,
    MAX(price) - MIN(price) AS price_range,
    ((MAX(price) - MIN(price)) / MIN(price)) * 100 AS volatility_pct,
    COUNT(*) AS trade_count
FROM trades
WHERE trade_date >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY symbol
HAVING COUNT(*) >= 10
ORDER BY volatility_pct DESC
LIMIT 20;

-- Trading volume trend
SELECT 
    trade_date,
    symbol,
    SUM(quantity) AS daily_volume,
    AVG(price) AS avg_price,
    COUNT(*) AS trade_count
FROM trades
WHERE trade_date >= CURRENT_DATE - INTERVAL '30 days'
  AND symbol IN ('AAPL', 'GOOGL', 'MSFT')
GROUP BY trade_date, symbol
ORDER BY symbol, trade_date;

-- ==========================================
-- 8. AUDIT AND COMPLIANCE
-- ==========================================

-- Failed trades
SELECT 
    t.trade_id,
    t.symbol,
    t.trader_id,
    tr.trader_name,
    t.quantity,
    t.price,
    t.status,
    t.trade_date,
    t.trade_time
FROM trades t
JOIN traders tr ON t.trader_id = tr.trader_id
WHERE t.status IN ('FAILED', 'REJECTED')
  AND t.trade_date >= CURRENT_DATE - INTERVAL '7 days'
ORDER BY t.trade_date DESC, t.trade_time DESC;

-- Audit trail
SELECT 
    ta.audit_id,
    ta.trade_id,
    ta.action,
    ta.old_status,
    ta.new_status,
    ta.changed_by,
    ta.changed_at
FROM trade_audit ta
WHERE ta.trade_id = 'T0001'
ORDER BY ta.changed_at;

-- Unusual trading patterns
SELECT 
    trader_id,
    trade_date,
    COUNT(*) AS trade_count,
    SUM(quantity * price) AS total_value,
    AVG(quantity * price) AS avg_value
FROM trades
WHERE trade_date >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY trader_id, trade_date
HAVING COUNT(*) > (
    SELECT AVG(daily_count) * 2
    FROM (
        SELECT trader_id, trade_date, COUNT(*) AS daily_count
        FROM trades
        WHERE trade_date >= CURRENT_DATE - INTERVAL '30 days'
        GROUP BY trader_id, trade_date
    ) AS daily_stats
)
ORDER BY trade_count DESC;

-- ==========================================
-- 9. REPORTING
-- ==========================================

-- Monthly summary by department
SELECT 
    tr.department,
    DATE_TRUNC('month', t.trade_date) AS month,
    COUNT(*) AS total_trades,
    SUM(t.quantity * t.price) AS total_value,
    AVG(t.quantity * t.price) AS avg_trade_value
FROM trades t
JOIN traders tr ON t.trader_id = tr.trader_id
WHERE t.trade_date >= CURRENT_DATE - INTERVAL '6 months'
GROUP BY tr.department, DATE_TRUNC('month', t.trade_date)
ORDER BY month DESC, total_value DESC;

-- Symbol performance ranking
SELECT 
    symbol,
    SUM(quantity * price) AS total_value,
    RANK() OVER (ORDER BY SUM(quantity * price) DESC) AS value_rank,
    COUNT(*) AS trade_count,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS count_rank
FROM trades
WHERE trade_date >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY symbol
ORDER BY value_rank;

-- ==========================================
-- 10. OPTIMIZATION EXAMPLES
-- ==========================================

-- Using indexes effectively
CREATE INDEX IF NOT EXISTS idx_trades_date ON trades(trade_date);
CREATE INDEX IF NOT EXISTS idx_trades_symbol ON trades(symbol);
CREATE INDEX IF NOT EXISTS idx_trades_trader ON trades(trader_id);
CREATE INDEX IF NOT EXISTS idx_trades_composite ON trades(symbol, trade_date);

-- View for commonly used query
CREATE OR REPLACE VIEW v_daily_trade_summary AS
SELECT 
    t.trade_date,
    t.symbol,
    s.company_name,
    s.sector,
    COUNT(*) AS trade_count,
    SUM(t.quantity) AS total_volume,
    AVG(t.price) AS avg_price,
    MIN(t.price) AS low_price,
    MAX(t.price) AS high_price,
    SUM(t.quantity * t.price) AS total_value
FROM trades t
JOIN symbols s ON t.symbol = s.symbol
GROUP BY t.trade_date, t.symbol, s.company_name, s.sector;

-- Using the view
SELECT * FROM v_daily_trade_summary
WHERE trade_date = CURRENT_DATE
ORDER BY total_value DESC;

