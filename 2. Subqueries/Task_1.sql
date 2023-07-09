-- 1

SELECT product_name, units_in_stock
FROM products
WHERE units_in_stock < ALL(SELECT AVG(quantity)
						FROM order_details
						GROUP BY product_id)
ORDER BY units_in_stock

-- 2

SELECT customer_id, SUM(freight) AS freight_sum 
FROM orders
JOIN (
	SELECT customer_id, AVG(freight) AS freight_avg
	FROM orders
	GROUP BY customer_id) AS os
	USING (customer_id)
WHERE orders.freight >= os.freight_avg
	AND orders.shipped_date BETWEEN '1996-07-16' AND '1996-07-31'
GROUP BY orders.customer_id
ORDER BY freight_sum;

-- 3

SELECT customer_id, ship_country, order_price
FROM orders
JOIN(
	SELECT order_id, SUM(unit_price * quantity * (1-discount)) as order_price
	FROM order_details
	GROUP BY order_id) as od
		USING (order_id)
WHERE order_date >= '1997-09-01'
	AND ship_country IN ('Argentina' , 'Bolivia', 'Brazil', 'Chile', 'Colombia', 'Ecuador', 'Guyana', 'Paraguay', 
							'Peru', 'Suriname', 'Uruguay', 'Venezuela')
ORDER BY order_price DESC
LIMIT 3

-- 4

SELECT DISTINCT product_name
FROM products
JOIN(
	SELECT product_id, quantity
	FROM order_details
	) as od
	USING (product_id)
WHERE od.quantity = 10

-- Варианты от автора
SELECT product_name
FROM products
WHERE product_id = ANY (SELECT product_id FROM order_details WHERE quantity = 10);

SELECT distinct product_name, quantity
FROM products
join order_details using(product_id)
where order_details.quantity = 10
-- 