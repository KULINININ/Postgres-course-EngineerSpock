-- 1

CREATE TABLE exam(
	exam_id int GENERATED ALWAYS AS IDENTITY NOT NULL,
	exam_name varchar(128),
	exam_date date,
	
	CONSTRAINT testdb_exam_key UNIQUE (exam_id)
)

-- 2

ALTER TABLE exam
DROP CONSTRAINT testdb_exam_key

-- 3

ALTER TABLE exam
ADD PRIMARY KEY (exam_id)

-- 4

CREATE TABLE person(
	person_id int PRIMARY KEY,
	first_name varchar (128),
	last_name varchar (128)
)

-- 5

CREATE TABLE passport(
	passport_id int PRIMARY KEY,
	serial_number int NOT NULL,
	registration_date date,
	person_id int REFERENCES person (person_id) 
)

-- 6

CREATE TABLE book
(
	book_id integer PRIMARY KEY,
	title text NOT NULL,
	isbn varchar(32) NOT NULL
);

ALTER TABLE book
ADD COLUMN weight decimal
	CONSTRAINT CHK_book_weight
		CHECK (weight BETWEEN 0 AND 100)

-- 7

INSERT INTO book
VALUES (2, 'test', 111, 140)
RETURNING *

-- 8


CREATE TABLE student
(
	student_id int GENERATED ALWAYS AS IDENTITY NOT NULL,
	full_name text,
	course smallint DEFAULT 1
)

-- 9

INSERT INTO student (full_name, course)
VALUES
('1', 1),
('2', 2),
('3', 3)

INSERT INTO student (full_name)
VALUES
('4'),
('5'),
('6')

-- 10

ALTER TABLE student
ALTER COLUMN course DROP DEFAULT

-- 11

ALTER TABLE products
ADD CONSTRAINT CHK_unit_price CHECK (unit_price > 0)

-- 12

SELECT MAX(product_id) FROM products; --78

CREATE SEQUENCE IF NOT EXISTS products_product_id_seq
START WITH 78 OWNED BY products.product_id;


ALTER TABLE products
ALTER COLUMN product_id SET DEFAULT nextval('products_product_id_seq')

-- 13

INSERT INTO products(product_name, supplier_id, category_id, quantity_per_unit, 
					 unit_price, units_in_stock, units_on_order, reorder_level, discontinued)
VALUES
('prod', 1, 1, 10, 20, 20, 10, 1, 0)
RETURNING product_id;