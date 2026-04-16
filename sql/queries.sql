/* =========================================================
   Restaurant Ordering Database - Sample Queries & Tests
   Useful reporting queries and data integrity tests
   ========================================================= */

-- =========================
-- 1. DATA OVERVIEW
-- =========================
-- Verify Customers
SELECT * FROM CUSTOMER ORDER BY cust_id;

-- Verify Staff
SELECT * FROM STAFF ORDER BY staff_id;

-- Verify Menu Items
SELECT item_id, name, price, is_available FROM MENUITEM ORDER BY item_id;

-- =========================
-- 2. REPORTING & AUTOMATION VALIDATION
-- =========================
-- Verify that unit_price was auto-filled by the trigger
SELECT * FROM ORDERDETAIL ORDER BY order_id, item_id;

-- Verify that the total_amount for orders was automatically calculated 
-- via the Compound Trigger
SELECT order_id, order_time, order_type, total_amount, cust_id, staff_id
FROM ORDERS
ORDER BY order_time;

-- View aggregated daily sales reporting
SELECT *
FROM V_DAILY_SALES
ORDER BY sales_date;

-- View the full formatted receipt layout (joining 5 tables)
SELECT *
FROM V_ORDER_RECEIPT
ORDER BY order_time, order_id;

-- =========================
-- 3. DATA INTEGRITY TEST (Expected to Fail)
-- =========================
-- This query is intentionally designed to test the TRG_ORDERDETAIL_BI trigger.
-- It attempts to order an item where is_available = 'N' ('Expired Sandwich').
-- The trigger should block it and raise ORA-20001: Cannot order an unavailable item.
INSERT INTO ORDERDETAIL (order_id, item_id, quantity, unit_price)
VALUES (
  (SELECT MIN(order_id) FROM ORDERS),
  (SELECT item_id FROM MENUITEM WHERE name='Expired Sandwich'),
  1,
  NULL
);
