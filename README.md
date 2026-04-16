# Restaurant Operations Database System

## Overview
A comprehensive relational database system engineered to manage and automate daily restaurant operations, including order processing, item tracking, and automated billing calculations. Built using Oracle SQL, this project demonstrates advanced schema design, data integrity enforcement, and automated transaction logic.

## Business Problem / Scenario
High-traffic hospitality businesses require robust back-end systems to track `Customers`, `Staff`, `Menu Items`, and dynamic `Orders`. 
The core challenges solved by this architecture include:
- **Billing Integrity:** Guaranteeing that the total bill is always exactly equal to the mathematical sum of individual ordered items, calculated entirely server-side.
- **Data Prevention:** Blocking cashiers from mistakenly processing out-of-stock items at the transaction layer.
- **Identity Tracking:** Managing both registered loyalty members and transient customers without data duplication.

## Key Features
- **Relational Integrity:** Enforced foreign key constraints mapping staff, customers, and complex many-to-many order relations.
- **Automated Triggers:** 
  - Implementation of Oracle Compound Triggers to instantly recalculate an `ORDER` total amount whenever an `ORDERDETAIL` line item is added, updated, or removed, avoiding the "mutating table" error.
  - Pre-insert triggers that lock-in historical unit prices, ensuring future menu price updates don't alter legacy receipts.
- **Identity Sequences:** Automated sequence generation for collision-free Primary Keys.
- **Data Validation:** Advanced Regex `CHECK` constraints enforcing phone number formats and specific organizational IDs.
- **Reporting Views:** Consolidated reporting layers (`V_ORDER_RECEIPT` and `V_DAILY_SALES`) that join multiple tables into formatted outputs.

## Technology Stack
- **Database Engine:** Oracle SQL (11g/12c/19c compatible)
- **Key Concepts:** DDL, DML, Relational Data Modeling, Compound Triggers, Identity Sequences, Regex Constraints, Views.

## Database Design Summary
The architecture operates on five normalized core tables:
1. `CUSTOMER` - Tracks client details, contact information, and loyalty status.
2. `STAFF` - Tracks employees, designated roles, and shift assignments.
3. `MENUITEM` - The centralized inventory, categorizations, and price lists.
4. `ORDERS` - The primary transaction bridge tying the Customer and Staff to an event.
5. `ORDERDETAIL` - The junction tracking individual line items mapped to a specific order.

## Repository Structure
```text
retail-database-management-system/
├── README.md               # Project documentation
├── .gitignore              # Dependency and OS file exclusions
├── LICENSE                 # Repository licensing
├── docs/                   
│   ├── Database_Design_Report.pdf  # Business logic and design decisions
│   └── Presentation_Slides.pdf     # High-level architecture presentation
├── assets/                 
│   └── erd.png             # Entity Relationship Diagram visualization
└── sql/                    
    ├── schema.sql          # Database structure, constraints, views, and triggers
    ├── seed.sql            # Sample data generation and validation
    └── queries.sql         # Test cases, reporting, and integrity checks
```

## Setup and Usage Instructions
To deploy this database on any Oracle SQL compliant environment (such as Oracle APEX, SQL Developer, or SQL*Plus):

1. **Initialize the Schema:** Run `sql/schema.sql` first. This establishes sequences, tables, constraints, analytical views, and triggers.
2. **Populate Data:** Run `sql/seed.sql` to populate the environment with mock staff, customers, menu items, and realistic rolling order data.
3. **Verify Constraints:** Run `sql/queries.sql` to execute tests on the business logic and ensure the triggers successfully stop illegal operations.

## Example Queries / Testing
**Validation Test:** Prevent staff from accidentally submitting an order for an out-of-stock item (`is_available = 'N'`).
```sql
-- Attempting to order an 'Expired Sandwich' (Item 1004)
INSERT INTO ORDERDETAIL (order_id, item_id, quantity, unit_price)
VALUES (5000, 1004, 1, NULL);
```
**Expected Output Event:**
```text
ORA-20001: Cannot order an unavailable item.
ORA-06512: at "TRG_ORDERDETAIL_BI", line 9
```
*Result: The database intercept engine aggressively stops bad data entry before it reaches the core tables.*

## What I Contributed
*Note: The foundational business scenario and initial specifications were originally conceptualized collaboratively within a team. For this independent portfolio presentation:*
- I orchestrated the final **schema architecture and table normalization**.
- I engineered the advanced **Compound Triggers** to solve sequence aggregation issues and enforced the regex data constraints.
- I meticulously refactored and audited the original codebase into clean, modular SQL files to demonstrate production-ready database deployment standards, independent of the original academic scope.

## Learning Outcomes
- Advanced understanding of **automating state** strictly within relational databases instead of relying on unpredictable front-end application logic.
- Practical mastery of **Compound Triggers** in Oracle to solve the notorious "mutating table" error during aggregation logic changes.
- Practical experience normalizing unorganized data into optimized, indexable junction tables.

## Future Improvements
- **Security & Roles:** Implement distinct User Roles (e.g., `APP_CASHIER`, `APP_ADMIN`) with strict grants restricting raw `DROP` and `UPDATE` capabilities.
- **Stored Procedures:** Wrap the ordering logic into secure PL/SQL stored procedures (`p_place_order`) instead of relying on external inserts.
- **Scaling Analytics:** Add window functions to generate expansive end-of-month financial reports dynamically.
