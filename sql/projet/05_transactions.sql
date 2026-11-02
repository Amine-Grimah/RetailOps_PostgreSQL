
-- =====================================================
-- Projet RetailOps - Tests des transactions
-- =====================================================

-- 1. Vérifier la valeur initiale
SELECT customer_id, region
FROM retail.customers
WHERE customer_id = 1;

-- 2. Tester BEGIN et ROLLBACK
BEGIN;

UPDATE retail.customers
SET region = 'TEST_ROLLBACK'
WHERE customer_id = 1;

-- Vérifier la modification temporaire
SELECT customer_id, region
FROM retail.customers
WHERE customer_id = 1;

-- Annuler la modification
ROLLBACK;

-- Vérifier le retour à la valeur initiale
SELECT customer_id, region
FROM retail.customers
WHERE customer_id = 1;

-- 3. Tester BEGIN et COMMIT
BEGIN;

UPDATE retail.customers
SET region = 'PACA'
WHERE customer_id = 1;

COMMIT;

-- Vérifier la valeur après validation
SELECT customer_id, region
FROM retail.customers
WHERE customer_id = 1;
