DROP FUNCTION IF EXISTS hello_world();

CREATE OR REPLACE FUNCTION greet_user(name TEXT)
RETURNS VARCHAR
LANGUAGE plpgsql AS
$$
BEGIN
    RETURN CONCAT('hello ', name, ' !! ', 'time ', 'is', current_timestamp);
END;
$$;

-- Usage:
SELECT greet_user('Alex');


DROP PROCEDURE IF EXISTS create_orders_table();

CREATE OR REPLACE PROCEDURE create_orders_table()
LANGUAGE plpgsql AS
$$
BEGIN
    CREATE TABLE IF NOT EXISTS demo (
        id SERIAL PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL
    );
END;
$$;

-- Usage:
CALL create_orders_table();


CREATE OR REPLACE FUNCTION multiply_three(x DOUBLE PRECISION, y DOUBLE PRECISION, z DOUBLE PRECISION)
RETURNS DOUBLE PRECISION
LANGUAGE plpgsql AS
$$
BEGIN
    RETURN x * y * z;
END;
$$;

-- Usage:
SELECT multiply_three(2, 3, 4);



CREATE OR REPLACE FUNCTION div_mod(
	a DOUBLE PRECISION, 
	b DOUBLE PRECISION,
    OUT quotient DOUBLE PRECISION,
    OUT remainder DOUBLE PRECISION
)
LANGUAGE plpgsql AS
$$
BEGIN
    quotient := a / b;
	remainder := mod(a::numeric, b::numeric)::double precision;
END;
$$;

-- Usage:
SELECT * FROM div_mod(17, 5);



SELECT multiply_three(2, 3, 4);



CREATE OR REPLACE FUNCTION sp_math_roots(
	x DOUBLE PRECISION, 
	y DOUBLE PRECISION,
	OUT sum_result integer,
	OUT diff_result integer,
	OUT sqrt_x integer,
	OUT y_power_4 integer
)
LANGUAGE plpgsql AS
$$
BEGIN
	sum_result := x + y;
	diff_result := x - y;
	sqrt_x := sqrt(x);
	y_power_4 := power(y, 4);
END;
$$;

-- Usage:
SELECT * FROM sp_math_roots(16, 2);



drop procedure if exists prepare_books_db();

create or replace procedure prepare_books_db()

LANGUAGE plpgsql
AS $$
BEGIN
    CREATE TABLE IF NOT EXISTS authors(
		id SERIAL PRIMARY KEY, 
		name TEXT NOT NULL
    );

    CREATE TABLE IF NOT EXISTS books(
		id SERIAL PRIMARY KEY, 
		title TEXT, 
		price DOUBLE PRECISION, 
		publish_date DATE, 
		author_id INT REFERENCES authors(id)
	);

    INSERT INTO authors(name) 
	VALUES 
		('Alice Munro'), 
		('George Orwell'), 
		('Haruki Murakami'), 
		('Chimamanda Ngozi Adichie');
		
    INSERT INTO books(title, price, publish_date, author_id) 
	VALUES
		('Lives of Girls and Women', 45.0, '1971-05-01', 1),
		('1984', 30.0, '1949-06-08', 2),
		('Norwegian Wood', 50.0, '1987-09-04', 3),
		('Half of a Yellow Sun', 42.5, '2006-08-15', 4),
		('Kafka on the Shore', 55.0, '2002-01-01', 3),
		('Dear Life', 48.0, '2012-11-13', 1),
		('The Thing Around Your Neck', 35.0, '2009-04-01', 4),
		('Animal Farm', 28.0, '1945-08-17', 2),
		('The Testaments', 60.0, '2019-09-10', 2),
		('Colorless Tsukuru Tazaki', 47.5, '2013-04-12', 3);

END;
$$;

CALL prepare_books_db();



drop function sp_get_books_with_year();

CREATE OR REPLACE FUNCTION sp_get_books_with_year()
		RETURNS TABLE (
    		title TEXT,
    		publish_year INT,
    		price DOUBLE PRECISION
		) 
LANGUAGE plpgsql AS
$$
BEGIN
    RETURN QUERY
	select
		b.title, EXTRACT(YEAR FROM b.publish_date)::INT AS publish_year, b.price
	from books b;
END;
$$;

SELECT * FROM sp_get_books_with_year();


drop function sp_latest_book();

CREATE OR REPLACE FUNCTION sp_latest_book()
		RETURNS TABLE (
    		title TEXT,
    		publish_date DATE
		) 
LANGUAGE plpgsql AS
$$
BEGIN
    RETURN QUERY
	select
		b.title, b.publish_date
	from books b
	ORDER BY b.publish_date DESC
    LIMIT 1;
END;
$$;

SELECT * FROM sp_latest_book();



drop function sp_books_summary();

CREATE OR REPLACE FUNCTION sp_books_summary(
		OUT youngest_book DATE,
		OUT oldest_book DATE,
		OUT avg_price NUMERIC(5,2),
		OUT total_books INT
		)
LANGUAGE plpgsql AS
$$
BEGIN
      SELECT MAX(publish_date) INTO youngest_book FROM books;
	  SELECT MIN(publish_date) INTO oldest_book FROM books;
	  SELECT ROUND(AVG(price)::NUMERIC, 2) INTO avg_price FROM books;
	  SELECT COUNT(*) INTO total_books FROM books;
END;
$$;

SELECT * FROM sp_books_summary();



drop function sp_books_by_year_range();

CREATE OR REPLACE FUNCTION sp_books_by_year_range(from_year INT, to_year INT)
		RETURNS TABLE (
    		id INT,
    		title TEXT,
    		publish_date DATE,
    		price DOUBLE PRECISION
		)
LANGUAGE plpgsql AS
$$
BEGIN
	  RETURN QUERY
      SELECT 
	  	b.id, 
		b.title, 
		b.publish_date, 
		b.price
	  FROM books b;
END;
$$;

SELECT * FROM sp_books_by_year_range(2000, 2015);

















































