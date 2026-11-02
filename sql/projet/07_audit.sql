-- RetailOps : vérification de la configuration pgAudit

-- 1. Vérifier le préchargement de pgAudit
SHOW shared_preload_libraries;

-- 2. Vérifier la configuration des événements audités
SHOW pgaudit.log;

-- 3. Vérifier la présence de l'extension
SELECT extname, extversion
FROM pg_extension
WHERE extname = 'pgaudit';

-- 4. Vérifier le préfixe des journaux
SHOW log_line_prefix;