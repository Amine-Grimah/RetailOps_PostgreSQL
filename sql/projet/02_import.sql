
-- =====================================================
-- RETAILOPS - IMPORTATION DES DONNEES CSV
-- Base : retail_admin
-- Schema : retail
-- =====================================================

BEGIN;

-- 1. Importation des clients
COPY retail.customers
FROM '/dataset/customers.csv'
WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');

-- 2. Importation des produits
COPY retail.products
FROM '/dataset/products.csv'
WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');

-- 3. Importation des commandes
COPY retail.orders
FROM '/dataset/orders.csv'
WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');

-- 4. Importation des lignes de commandes
COPY retail.order_items
FROM '/dataset/order_items.csv'
WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');

COMMIT;
