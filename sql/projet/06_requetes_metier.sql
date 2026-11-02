-- RetailOps : trois requêtes métier

-- 1. Chiffre d'affaires par canal de vente
SELECT
    o.channel,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS chiffre_affaires
FROM retail.orders o
JOIN retail.order_items oi ON oi.order_id = o.order_id
GROUP BY o.channel
ORDER BY chiffre_affaires DESC;


-- 2. Les 10 produits les plus vendus
SELECT
    p.product_id,
    p.label,
    SUM(oi.quantity) AS quantite_vendue,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS chiffre_affaires
FROM retail.products p
JOIN retail.order_items oi ON oi.product_id = p.product_id
GROUP BY p.product_id, p.label
ORDER BY quantite_vendue DESC
LIMIT 10;


-- 3. Les 10 clients ayant passé le plus de commandes
SELECT
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS nombre_commandes
FROM retail.customers c
JOIN retail.orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY nombre_commandes DESC
LIMIT 10;