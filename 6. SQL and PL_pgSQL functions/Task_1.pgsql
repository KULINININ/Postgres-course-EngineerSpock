-- 1

CREATE OR REPLACE FUNCTION backup_customers() RETURNS void AS $$
BEGIN
    DROP TABLE IF EXISTS temp_customers;

    SELECT *
    INTO temp_customers
    FROM customers;

    -- OR

    CREATE TABLE temp_customers AS
        SELECT * FROM customers;
END
$$ LANGUAGE plpgsql;

SELECT * FROM  backup_customers();

SELECT * FROM temp_customers
SELECT * FROM customers

-- 2

CREATE OR REPLACE FUNCTION get_average_freight (OUT avg_freight float) AS $$
BEGIN
    SELECT AVG(freight) INTO avg_freight FROM orders;    
END
$$ LANGUAGE plpgsql;

SELECT * FROM get_average_freight();

-- 3

CREATE OR REPLACE FUNCTION random_number_on_borders (IN high int, IN low int, OUT random_number int) AS $$
BEGIN
    random_number := floor((random() * (high - low + 1)) + low);
END
$$ LANGUAGE plpgsql

SELECT * FROM random_number_on_borders(10, 0)

-- 4

-- Add salary column
-- ALTER TABLE employees
-- ADD salary int

-- UPDATE employees
-- SET salary = random() * 1000

CREATE OR REPLACE FUNCTION get_low_and_high_salary_by_city (
    IN city varchar, OUT min_salary numeric, OUT max_salary numeric) AS $$
BEGIN
    SELECT MIN(salary), MAX(salary)
    INTO min_salary,  max_salary
    FROM employees;
END
$$ LANGUAGE plpgsql

SELECT * FROM get_low_and_high_salary_by_city('London')

-- 5

CREATE OR REPLACE FUNCTION adjust_salary (
    IN adjustment_percentage real DEFAULT 0.15, IN upper_salary_level int DEFAULT 700) RETURNS void AS $$
BEGIN
    UPDATE employees
    SET salary = salary * (1 + adjustment_percentage)
    WHERE salary <= upper_salary_level;
END
$$ LANGUAGE plpgsql

SELECT salary FROM employees ORDER BY salary

SELECT adjust_salary()

-- 6

DROP FUNCTION adjust_salary

CREATE OR REPLACE FUNCTION adjust_salary (
    IN adjustment_percentage real DEFAULT 0.15, IN upper_salary_level int DEFAULT 700)
        RETURNS SETOF employees AS
$$
    UPDATE employees
    SET salary = salary * (1 + adjustment_percentage)
    WHERE salary <= upper_salary_level
    RETURNING *
$$ LANGUAGE SQL

-- CREATE OR REPLACE FUNCTION adjust_salary (
--     IN adjustment_percentage real DEFAULT 0.15, IN upper_salary_level int DEFAULT 700)
--         RETURNS SETOF employees AS
-- $$
-- BEGIN
--     UPDATE employees
--     SET salary = salary * (1 + adjustment_percentage)
--     WHERE salary <= upper_salary_level;

--     RETURN QUERY SELECT * FROM employees
--     WHERE salary / (1 + adjustment_percentage) <= upper_salary_level;
-- END
-- $$ LANGUAGE plpgsql;

SELECT * FROM adjust_salary()

-- 7

CREATE OR REPLACE FUNCTION adjust_salary(
    IN adjustment_percentage real DEFAULT 0.15, IN upper_salary_level int DEFAULT 700)
        RETURNS TABLE (last_name varchar, first_name varchar, title varchar, salary int) AS
$$
    UPDATE employees
    SET salary = salary * (1 + adjustment_percentage)
    WHERE salary <= upper_salary_level
    RETURNING last_name, first_name, title, salary
$$ LANGUAGE SQL

SELECT * FROM adjust_salary()

-- 8

DROP FUNCTION get_optimal_shipping_method

CREATE OR REPLACE FUNCTION get_optimal_shipping_method(
    IN shipping_method int)
        RETURNS SETOF orders AS
$$
DECLARE
    max_freight float;
    avg_freight float;
BEGIN
    SELECT MAX(freight), AVG(freight)
    INTO max_freight, avg_freight
    FROM orders
    WHERE ship_via = shipping_method;

    RETURN QUERY
    SELECT *
    FROM orders
    WHERE freight < ((max_freight*0.7) + avg_freight) / 2;
END
$$ LANGUAGE plpgsql

SELECT COUNT(*) FROM get_optimal_shipping_method(1)

SELECT COUNT(*) FROM orders

-- 9

DROP FUNCTION check_salary_levels;

CREATE OR REPLACE FUNCTION check_salary_levels(
    IN salary_level float, IN max_salary float DEFAULT 80,
    IN min_salary float DEFAULT 30, IN wage_growth_rate float DEFAULT 0.2)
        RETURNS bool AS
$$
BEGIN
    IF salary_level > min_salary THEN
        RETURN FALSE;
    ELSEIF salary_level * (1 + wage_growth_rate) > max_salary THEN
        RETURN FALSE;
    ELSEIF salary_level * (1 + wage_growth_rate) < max_salary THEN
        RETURN TRUE;
    END IF;
END
$$ LANGUAGE plpgsql

SELECT * FROM check_salary_levels(40, 80, 30, 0.2)
SELECT * FROM check_salary_levels(79, 81, 80, 0.2)
SELECT * FROM check_salary_levels(79, 95, 80, 0.2)