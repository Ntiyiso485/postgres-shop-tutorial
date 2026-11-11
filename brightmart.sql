CREATE TABLE customers (
    customer_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(20),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
    product_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    description TEXT,
    price NUMERIC(10, 2) NOT NULL CHECK (price >= 0),
    stock_quantity INTEGER NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
    order_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),
    CONSTRAINT chk_orders_status
        CHECK (status IN ('PENDING', 'PAID', 'SHIPPED', 'CANCELLED'))
);

CREATE TABLE order_items (
    order_item_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10, 2) NOT NULL CHECK (unit_price >= 0),

    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    CONSTRAINT uq_order_product
        UNIQUE (order_id, product_id)
);

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_type = 'BASE TABLE'
ORDER BY table_name;

INSERT INTO customers (first_name, last_name, email, phone)
VALUES('Aisha', 'Khumalo', 'aisha@example.com', '0710000001'),
    ('Daniel', 'Mokoena', 'daniel@example.com', '0720000002'),
	('Ntiyiso','Chauke','ntiyisovheli@gmail.com','0673404854'),
	('Duniso','Chauke','dunisochauke4@gmail.com','0731057484'),
	('Samson','Chauke','samchauke@gmail.com.com','0783890737'),
	('Betty','Chauke','bettychauke@gmail.com','0726907868');

SELECT * FROM customers;

INSERT INTO products (product_name, description, price, stock_quantity)
VALUES
    ('Wireless Mouse', 'Wireless computer mouse', 249.99, 30),
    ('Mechanical Keyboard', 'USB mechanical keyboard', 899.00, 15),
    ('USB-C Cable', 'One metre USB-C cable', 99.50, 50),
	 ('USB-C Cable', '2 metre USB-C cable', 209.50, 10),
	  ('USB-B Cable', 'One metre USB-C cable', 59.50, 30),
	  ('wireless Keyboard', 'wireless keyboard', 1000.00, 10);

SELECT * FROM products;

SELECT customer_id, first_name, last_name
FROM customers
ORDER BY customer_id;

INSERT INTO orders (customer_id, status)
VALUES
    (1, 'PAID'),
    (2, 'PENDING'),
	(3, 'PENDING'),
	 (4, 'PENDING'),
	  (5, 'PAID');

SELECT order_id, customer_id, status FROM orders;
SELECT product_id, product_name, price FROM products;

INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES
    (1, 1, 2, 249.99),
    (1, 3, 1, 99.50),
    (2, 2, 1, 899.00);
	
SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;

SELECT
    product_name AS product,
    price AS selling_price
FROM products;

SELECT product_name, price
FROM products
WHERE price > 200;

SELECT product_name, price, stock_quantity
FROM products
WHERE price > 100
  AND stock_quantity >= 20;

SELECT product_name
FROM products
WHERE product_name LIKE '%USB%';

SELECT order_id, status
FROM orders
WHERE status IN ('PAID', 'SHIPPED');

SELECT product_name, price
FROM products
WHERE price BETWEEN 100 AND 500;

SELECT product_name, price
FROM products
ORDER BY price DESC;

SELECT product_name, price
FROM products
ORDER BY product_name ASC;

SELECT product_name, stock_quantity, price
FROM products
ORDER BY stock_quantity ASC, price DESC;

SELECT
    orders.order_id,
    customers.first_name,
    customers.last_name,
    orders.status
FROM orders
INNER JOIN customers
    ON orders.customer_id = customers.customer_id;

SELECT
    o.order_id,
    c.first_name,
    c.last_name,
    o.status
FROM orders AS o
INNER JOIN customers AS c
    ON o.customer_id = c.customer_id;

SELECT
    o.order_id,
    c.first_name,
    p.product_name,
    oi.quantity,
    oi.unit_price
FROM orders AS o
INNER JOIN customers AS c
    ON o.customer_id = c.customer_id
INNER JOIN order_items AS oi
    ON o.order_id = oi.order_id
INNER JOIN products AS p
    ON oi.product_id = p.product_id;

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    o.order_id
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id
ORDER BY c.customer_id;
	