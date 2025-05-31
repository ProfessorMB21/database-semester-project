---
--- Name: demo; Type: DATABASE; Schema: -; Owner: -
---

CREATE DATABASE store_inventory;


\connect DATABASE store_inventory

---
--- Name: store; Type: SCHEMA; Schema: -; Owner: -
---

CREATE SCHEMA store;

---
--- Name: SCHEMA store; Type: COMMENT; Schema: -; Owner: -
---

COMMENT ON SCHEMA bookings IS 'Store inventory demo database schema';

-- Customers table (independent entity)
CREATE TABLE Customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL

    CONSTRAINT customers_email_check CHECK (email LIKE '%@%.%')
);

-- Suppliers table (independent entity)
CREATE TABLE Suppliers (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    address TEXT NOT NULL

    CONSTRAINT customers_email_check CHECK (email LIKE '%@%.%')
);

-- Categories table (Parent)
CREATE TABLE Categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    parent_category_id INT NULL,  -- For hierarchical categories (optional)
    description TEXT,
    FOREIGN KEY (parent_category_id) REFERENCES Categories(id)  -- Self-referential (if subcategories exist)
);

-- Products table (many-to-one with suppliers)
CREATE TABLE Products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    category_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0, 
    supplier_id INT NOT NULL,
    
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(id),
    FOREIGN KEY (category_id) REFERENCES Categories(id),
    
    CONSTRAINT products_stock_quantity_check CHECK ((stock_quantity >= (0)::DECIMAL)),
    CONSTRAINT products_price_check CHECK ((price > (0)::DECIMAL))  
);

-- Orders table (1-to-many with customers)
CREATE TABLE Orders (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(12,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'Processing',
    shipping_address TEXT NOT NULL,
    
    FOREIGN KEY (customer_id) REFERENCES Customers(id),
    
    CONSTRAINT orders_status_check CHECK ((status)::text = ANY (ARRAY[('Processing'::varchar)::text, ('Shipped'::varchar)::text, ('Delivered'::varchar)::text, ('Cancelled'::varchar)::text]))
    CONSTRAINT orders_total_amount CHECK ((total_amount > (0)::DECIMAL))
);

-- Order_Items table (many-to-many between orders and products)
CREATE TABLE Order_Items (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    
    FOREIGN KEY (order_id) REFERENCES Orders(id),
    FOREIGN KEY (product_id) REFERENCES Products(id),
    
    CONSTRAINT order_items_quantity_check CHECK ((quantity > (0)::int)),
    CONSTRAINT order_items_unit_price_check CHECK ((unit_price > (0)::int))
);

-- Payments table (1-to-1 with orders)
CREATE TABLE Payments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    amount DECIMAL(10,2),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Pending',
    
    FOREIGN KEY (order_id) REFERENCES Orders(id),
    UNIQUE (order_id)

    CONSTRAINT payments_amount_check CHECK ((amount > (0)::DECIMAL))
    CONSTRAINT payments_payment_method_check CHECK ((payment_method)::text = ANY (ARRAY[('Credit Card'::varchar)::text, ('PayPal'::varchar)::text, ('Bank Transfer'::varchar)::text, ('Cash on Delivery'::varchar)::text]))
    CONSTRAINT payments_status_check CHECK ((status)::text = ANY (ARRAY[('Pending'::varchar)::text, ('Completed'::varchar)::text, ('Failed'::varchar)::text, ('Refunded'::varchar)::text]))
);
