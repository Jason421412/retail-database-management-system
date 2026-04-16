/* =========================================================
   Restaurant Ordering Database - Seed Data
   Populates initial reference data and sample orders
   ========================================================= */

-- =========================
-- 1. SEED CUSTOMERS
-- =========================
INSERT INTO CUSTOMER (cust_id, name, phone, um_student_id, membership_status)
VALUES (NULL, 'Jason Xu', '+6012-3456789', 'UM1234567', 'Active');

INSERT INTO CUSTOMER (cust_id, name, phone, um_student_id, membership_status)
VALUES (NULL, 'Aina Binti Ahmad', '013-2222333', 'UM7654321', 'Active');

INSERT INTO CUSTOMER (cust_id, name, phone, um_student_id, membership_status)
VALUES (NULL, 'Kumar Raj', '014-7777888', NULL, 'Inactive');

INSERT INTO CUSTOMER (cust_id, name, phone, um_student_id, membership_status)
VALUES (NULL, 'Lim Wei Ming', '011-88889999', 'UM0000001', 'Active');

COMMIT;

-- =========================
-- 2. SEED STAFF
-- =========================
INSERT INTO STAFF (staff_id, name, role, shift, salary)
VALUES (NULL, 'Mr Tan', 'Boss', 'morning', 6000);

INSERT INTO STAFF (staff_id, name, role, shift, salary)
VALUES (NULL, 'Mei Ling', 'Cashier', 'afternoon', 2800);

INSERT INTO STAFF (staff_id, name, role, shift, salary)
VALUES (NULL, 'Ali Hassan', 'Cook', 'evening', 3200);

INSERT INTO STAFF (staff_id, name, role, shift, salary)
VALUES (NULL, 'Siti Nur', 'Cashier', 'morning', 2700);

COMMIT;

-- =========================
-- 3. SEED MENU ITEMS
-- =========================
INSERT INTO MENUITEM (item_id, name, category, price, is_available, daily_special)
VALUES (NULL, 'Nasi Lemak', 'Main', 8.50, 'Y', 'Y');

INSERT INTO MENUITEM (item_id, name, category, price, is_available, daily_special)
VALUES (NULL, 'Chicken Chop', 'Main', 12.90, 'Y', 'N');

INSERT INTO MENUITEM (item_id, name, category, price, is_available, daily_special)
VALUES (NULL, 'Teh Tarik', 'Drink', 3.00, 'Y', 'Y');

INSERT INTO MENUITEM (item_id, name, category, price, is_available, daily_special)
VALUES (NULL, 'Ice Lemon Tea', 'Drink', 4.50, 'Y', 'N');

-- Unavailable item (to test trigger blocking orders)
INSERT INTO MENUITEM (item_id, name, category, price, is_available, daily_special)
VALUES (NULL, 'Expired Sandwich', 'Snack', 5.00, 'N', 'N');

COMMIT;

-- =========================
-- 4. SEED ORDERS
-- =========================
-- Day 1 orders
INSERT INTO ORDERS (order_id, order_time, order_type, total_amount, cust_id, staff_id)
VALUES (
  NULL,
  TO_DATE('2025-01-02 10:15','YYYY-MM-DD HH24:MI'),
  'dine-in',
  0,
  (SELECT cust_id FROM CUSTOMER WHERE um_student_id='UM1234567'),
  (SELECT staff_id FROM STAFF WHERE name='Mei Ling')
);

INSERT INTO ORDERS (order_id, order_time, order_type, total_amount, cust_id, staff_id)
VALUES (
  NULL,
  TO_DATE('2025-01-02 13:40','YYYY-MM-DD HH24:MI'),
  'takeaway',
  0,
  (SELECT cust_id FROM CUSTOMER WHERE um_student_id='UM7654321'),
  (SELECT staff_id FROM STAFF WHERE name='Siti Nur')
);

-- Day 2 orders
INSERT INTO ORDERS (order_id, order_time, order_type, total_amount, cust_id, staff_id)
VALUES (
  NULL,
  TO_DATE('2025-01-03 19:10','YYYY-MM-DD HH24:MI'),
  'dine-in',
  0,
  (SELECT cust_id FROM CUSTOMER WHERE um_student_id='UM1234567'),
  (SELECT staff_id FROM STAFF WHERE name='Mei Ling')
);

INSERT INTO ORDERS (order_id, order_time, order_type, total_amount, cust_id, staff_id)
VALUES (
  NULL,
  TO_DATE('2025-01-03 20:05','YYYY-MM-DD HH24:MI'),
  'takeaway',
  0,
  (SELECT cust_id FROM CUSTOMER WHERE name='Kumar Raj'),
  (SELECT staff_id FROM STAFF WHERE name='Siti Nur')
);

COMMIT;

-- =========================
-- 5. SEED ORDER DETAILS (Items included in orders)
-- =========================
-- Order 1: Jason (Nasi Lemak + Teh Tarik)
INSERT INTO ORDERDETAIL (order_id, item_id, quantity, unit_price)
VALUES (
  (SELECT MIN(order_id) FROM ORDERS WHERE order_time=TO_DATE('2025-01-02 10:15','YYYY-MM-DD HH24:MI')),
  (SELECT item_id FROM MENUITEM WHERE name='Nasi Lemak'),
  1,
  NULL
);

INSERT INTO ORDERDETAIL (order_id, item_id, quantity, unit_price)
VALUES (
  (SELECT MIN(order_id) FROM ORDERS WHERE order_time=TO_DATE('2025-01-02 10:15','YYYY-MM-DD HH24:MI')),
  (SELECT item_id FROM MENUITEM WHERE name='Teh Tarik'),
  1,
  NULL
);

-- Order 2: Aina (Chicken Chop + Ice Lemon Tea)
INSERT INTO ORDERDETAIL (order_id, item_id, quantity, unit_price)
VALUES (
  (SELECT MIN(order_id) FROM ORDERS WHERE order_time=TO_DATE('2025-01-02 13:40','YYYY-MM-DD HH24:MI')),
  (SELECT item_id FROM MENUITEM WHERE name='Chicken Chop'),
  1,
  NULL
);

INSERT INTO ORDERDETAIL (order_id, item_id, quantity, unit_price)
VALUES (
  (SELECT MIN(order_id) FROM ORDERS WHERE order_time=TO_DATE('2025-01-02 13:40','YYYY-MM-DD HH24:MI')),
  (SELECT item_id FROM MENUITEM WHERE name='Ice Lemon Tea'),
  2,
  NULL
);

-- Order 3: Jason (Nasi Lemak x2 + Teh Tarik x3)
INSERT INTO ORDERDETAIL (order_id, item_id, quantity, unit_price)
VALUES (
  (SELECT MIN(order_id) FROM ORDERS WHERE order_time=TO_DATE('2025-01-03 19:10','YYYY-MM-DD HH24:MI')),
  (SELECT item_id FROM MENUITEM WHERE name='Nasi Lemak'),
  2,
  NULL
);

INSERT INTO ORDERDETAIL (order_id, item_id, quantity, unit_price)
VALUES (
  (SELECT MIN(order_id) FROM ORDERS WHERE order_time=TO_DATE('2025-01-03 19:10','YYYY-MM-DD HH24:MI')),
  (SELECT item_id FROM MENUITEM WHERE name='Teh Tarik'),
  3,
  NULL
);

-- Order 4: Kumar (Ice Lemon Tea x1)
INSERT INTO ORDERDETAIL (order_id, item_id, quantity, unit_price)
VALUES (
  (SELECT MIN(order_id) FROM ORDERS WHERE order_time=TO_DATE('2025-01-03 20:05','YYYY-MM-DD HH24:MI')),
  (SELECT item_id FROM MENUITEM WHERE name='Ice Lemon Tea'),
  1,
  NULL
);

COMMIT;
