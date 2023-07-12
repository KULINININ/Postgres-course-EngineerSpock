-- 1

CREATE VIEW view_orders_customers_employees AS
SELECT order_date, required_date, shipped_date,
	ship_postal_code, company_name, contact_name,
	phone, last_name, first_name, title
FROM orders
JOIN customers USING (customer_id)
JOIN employees USING (employee_id)

SELECT *
FROM view_orders_customers_employees
WHERE order_date > '1997-01-01'
ORDER BY order_date

-- 2

DROP VIEW view_orders_customers_employees

CREATE OR REPLACE VIEW view_orders_customers_employees AS
SELECT order_date, required_date, shipped_date,
	ship_postal_code, ship_country, company_name,
	contact_name, phone, last_name, first_name, title,
	customers.postal_code, reports_to
FROM orders
JOIN customers USING (customer_id)
JOIN employees USING (employee_id)

ALTER VIEW view_orders_customers_employees
RENAME TO view_orders_customers_employees_old

SELECT *
FROM view_orders_customers_employees
ORDER BY ship_country

DROP VIEW view_orders_customers_employees_old

-- 3

CREATE VIEW active_products AS
SELECT *
FROM products
WHERE discontinued = 0
WITH LOCAL CHECK OPTION

INSERT INTO active_products
VALUES(82, 'abc', 1, 1, 'abc', 1, 1, 1, 1, 1);