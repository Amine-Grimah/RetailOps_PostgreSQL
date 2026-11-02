-- =====================================================
-- RETAILOPS - GESTION DES ROLES ET UTILISATEURS
-- =====================================================

-- 1. Creation des roles et utilisateurs si necessaire

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'retail_ro') THEN
        CREATE ROLE retail_ro NOLOGIN;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'retail_rw') THEN
        CREATE ROLE retail_rw NOLOGIN;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'analyst_login') THEN
        CREATE ROLE analyst_login LOGIN PASSWORD 'Analyst_Local_2026!';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'app_login') THEN
        CREATE ROLE app_login LOGIN PASSWORD 'App_Local_2026!';
    END IF;
END
$$;


-- 2. Attribution des roles

GRANT retail_ro TO analyst_login;
GRANT retail_rw TO app_login;


-- 3. Permissions de lecture pour retail_ro

GRANT CONNECT ON DATABASE retail_admin TO retail_ro;
GRANT USAGE ON SCHEMA retail TO retail_ro;
GRANT SELECT ON ALL TABLES IN SCHEMA retail TO retail_ro;


-- 4. Permissions pour retail_rw

GRANT CONNECT ON DATABASE retail_admin TO retail_rw;
GRANT USAGE ON SCHEMA retail TO retail_rw;

-- Lecture seule sur toutes les tables
GRANT SELECT ON ALL TABLES IN SCHEMA retail TO retail_rw;

-- Ecriture uniquement sur orders
GRANT INSERT, UPDATE, DELETE ON retail.orders TO retail_rw;


-- 5. Droits par defaut pour les futures tables

ALTER DEFAULT PRIVILEGES IN SCHEMA retail
GRANT SELECT ON TABLES TO retail_ro;

ALTER DEFAULT PRIVILEGES IN SCHEMA retail
GRANT SELECT ON TABLES TO retail_rw;


-- 6. Retrait des anciens droits d'ecriture inutiles

REVOKE INSERT, UPDATE, DELETE ON
retail.customers,
retail.products,
retail.order_items
FROM retail_rw;