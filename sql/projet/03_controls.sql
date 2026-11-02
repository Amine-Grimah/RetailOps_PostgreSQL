
-- =====================================================
-- RETAILOPS - CONTROLES DE QUALITE ET INTEGRITE
-- =====================================================

-- 1. Volumes des quatre tables

SELECT 'customers' AS table_name, COUNT(*) AS total
FROM retail.customers
UNION ALL
SELECT 'products', COUNT(*)
FROM retail.products
UNION ALL
SELECT 'orders', COUNT(*)
FROM retail.orders
UNION ALL
SELECT 'order_items', COUNT(*)
FROM retail.order_items;


-- 2. Recherche de doublons sur les identifiants

SELECT 'customers' AS table_name, COUNT(*) AS duplicate_groups
FROM (
    SELECT customer_id
    FROM retail.customers
    GROUP BY customer_id
    HAVING COUNT(*) > 1
) d
UNION ALL
SELECT 'products', COUNT(*)
FROM (
    SELECT product_id
    FROM retail.products
    GROUP BY product_id
    HAVING COUNT(*) > 1
) d
UNION ALL
SELECT 'orders', COUNT(*)
FROM (
    SELECT order_id
    FROM retail.orders
    GROUP BY order_id
    HAVING COUNT(*) > 1
) d
UNION ALL
SELECT 'order_items', COUNT(*)
FROM (
    SELECT item_id
    FROM retail.order_items
    GROUP BY item_id
    HAVING COUNT(*) > 1
) d;


-- 3. Recherche de doublons sur les emails clients

SELECT email, COUNT(*) AS occurrences
FROM retail.customers
GROUP BY email
HAVING COUNT(*) > 1;


-- 4. Verification des cles etrangeres invalides

-- Commandes sans client existant
SELECT COUNT(*) AS orders_without_customer
FROM retail.orders o
LEFT JOIN retail.customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Lignes sans commande existante
SELECT COUNT(*) AS items_without_order
FROM retail.order_items i
LEFT JOIN retail.orders o
    ON i.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Lignes sans produit existant
SELECT COUNT(*) AS items_without_product
FROM retail.order_items i
LEFT JOIN retail.products p
    ON i.product_id = p.product_id
WHERE p.product_id IS NULL;
