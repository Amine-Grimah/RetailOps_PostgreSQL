-- RetailOps : optimisation des performances

-- 1. Analyser la requête avant index
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM retail.orders
WHERE customer_id = 100;

-- 2. Créer un index sur la clé de recherche
CREATE INDEX IF NOT EXISTS idx_orders_customer_id
ON retail.orders(customer_id);

-- 3. Mettre à jour les statistiques
ANALYZE retail.orders;

-- 4. Analyser la requête après index
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM retail.orders
WHERE customer_id = 100;