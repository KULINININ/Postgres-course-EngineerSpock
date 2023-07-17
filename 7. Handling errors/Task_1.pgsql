DROP FUNCTION IF EXISTS should_increase_salary

CREATE OR REPLACE FUNCTION should_increase_salary(
    current_salary numeric,
    max_salary numeric DEFAULT 80, 
    min_salary numeric DEFAULT 30,
    increase_rate numeric DEFAULT 0.2) 
        RETURNS bool AS
$$
DECLARE
    new_salary numeric;
BEGIN
    IF min_salary > max_salary THEN
        RAISE EXCEPTION 'min_salary (%) > max_salary (%)', min_salary, max_salary
            USING HINT = 'max_salary should be more than min_salary',
                ERRCODE = 12345;
    END IF;

    IF min_salary < 0 OR max_salary < 0 THEN
        RAISE EXCEPTION 'min_salary (%) or max_salary (%) less than 0', min_salary, max_salary
            USING HINT = 'max_salary and min_salary can''t be less than 0',
                ERRCODE = 12345;
    END IF;

    IF increase_rate < 0.05 THEN
        RAISE EXCEPTION 'increase_rate (%) less than 5%%', increase_rate
            USING HINT = 'increase_rate can''t be less than 5%%',
                ERRCODE = 12345;
    END IF;

    IF current_salary >= max_salary OR current_salary >= min_salary THEN         
        RETURN false;
    END IF;

    new_salary = current_salary + (current_salary * increase_rate);

    IF new_salary > max_salary THEN
        RETURN false;
    ELSE
        RETURN true;
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM should_increase_salary(79,10,80,0.2)
SELECT * FROM should_increase_salary(79,10,-1,0.2)
SELECT * FROM should_increase_salary(79,10,10,0.04)