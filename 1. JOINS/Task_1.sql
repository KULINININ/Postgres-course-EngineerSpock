-- 1

SELECT customers.company_name, 
	CONCAT(employees.first_name, ' ', employees.last_name)
FROM orders
INNER JOIN employees USING(employee_id)
INNER JOIN customers USING(customer_id)
INNER JOIN shippers ON orders.ship_via = shipper_id
WHERE shippers.company_name = 'Speedy Express'
	AND employees.city = 'London'
	AND customers.city = 'London'

-- 2

SELECT products.product_name, products.units_in_stock,
	suppliers.contact_name, suppliers.phone
FROM products
JOIN suppliers USING (supplier_id)
JOIN categories USING (category_id)
WHERE categories.category_name in ('Beverages', 'Seafood')
	AND products.discontinued <> 1
	AND products.units_in_stock < 20

-- 3

SELECT customers.contact_name, orders.order_id
FROM customers
LEFT JOIN orders USING(customer_id)
WHERE order_id IS NULL

-- 4

SELECT customers.contact_name, orders.order_id
FROM orders
RIGHT JOIN customers USING(customer_id)
WHERE order_id IS NULL