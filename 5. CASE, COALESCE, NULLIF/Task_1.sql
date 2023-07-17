-- 1

SELECT contact_name, city, country
FROM customers
ORDER BY contact_name,
	CASE WHEN city IS NULL THEN country
		ELSE city
	END

-- 2

SELECT product_name, unit_price,
	CASE
		WHEN unit_price >= 100 THEN 'too expensive'
		WHEN unit_price < 100 AND unit_price >= 50 THEN 'average'
		WHEN unit_price < 50 THEN 'low price'
	END AS price
FROM products

-- 3

SELECT contact_name, COALESCE (order_id::text, 'no orders') as order_id
FROM customers
LEFT JOIN orders USING (customer_id)
WHERE order_id IS NULL

-- 4

SELECT CONCAT(first_name, ' ', last_name),
	COALESCE(
		NULLIF(title, 'Sales Representative'), 'Sales Stuff') AS title
FROM employees