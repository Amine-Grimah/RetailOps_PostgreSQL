
-- =====================================================
-- RETAILOPS - CREATION DU MODELE RELATIONNEL
-- Base : retail_admin
-- Schema : retail
-- PostgreSQL 17
-- =====================================================

CREATE SCHEMA IF NOT EXISTS retail;

-- 1. TABLE CUSTOMERS
CREATE TABLE IF NOT EXISTS retail.customers (
    customer_id INTEGER PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL,
    region VARCHAR(100) NOT NULL,
    created_at DATE NOT NULL
);

-- 2. TABLE PRODUCTS
CREATE TABLE IF NOT EXISTS retail.products (
    product_id INTEGER PRIMARY KEY,
    sku VARCHAR(50) NOT NULL UNIQUE,
    label VARCHAR(200) NOT NULL,
    category VARCHAR(100) NOT NULL,
    list_price NUMERIC(10,2) NOT NULL
        CHECK (list_price >= 0),
    active BOOLEAN NOT NULL
);

-- 3. TABLE ORDERS
CREATE TABLE IF NOT EXISTS retail.orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    ordered_at TIMESTAMP NOT NULL,
    status VARCHAR(50) NOT NULL,
    channel VARCHAR(50) NOT NULL,

    CONSTRAINT fk_orders_customers
        FOREIGN KEY (customer_id)
        REFERENCES retail.customers(customer_id)
);

-- 4. TABLE ORDER_ITEMS
CREATE TABLE IF NOT EXISTS retail.order_items (
    item_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10,2) NOT NULL
        CHECK (unit_price >= 0),

    CONSTRAINT fk_items_orders
        FOREIGN KEY (order_id)
        REFERENCES retail.orders(order_id),

    CONSTRAINT fk_items_products
        FOREIGN KEY (product_id)
        REFERENCES retail.products(product_id)
);

-- FIN DE LA CREATION DU MODELE
