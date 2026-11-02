# Supervision de la base PostgreSQL — RetailOps

## 1. Objectif

La supervision permet de contrôler la disponibilité, les performances, l'utilisation des ressources et la sécurité de la base PostgreSQL.

## 2. Indicateurs à surveiller

| Indicateur | Source PostgreSQL | Objectif |
|---|---|---|
| Disponibilité | `pg_isready` | Vérifier que le serveur répond |
| Connexions actives | `pg_stat_activity` | Surveiller les connexions |
| Requêtes longues | `pg_stat_activity` | Identifier les requêtes lentes |
| Verrous | `pg_locks` | Détecter les blocages |
| Taille des bases | `pg_database_size()` | Suivre la croissance |
| Archivage WAL | `pg_stat_archiver` | Vérifier les sauvegardes WAL |
| Transactions | `pg_stat_database` | Surveiller l'activité |
| Utilisation disque | Docker / système hôte | Anticiper le manque d'espace |

## 3. Seuils d'alerte proposés

### Alerte 1 — Connexions

Déclencher une alerte lorsque le nombre de connexions actives dépasse 80 % de `max_connections` pendant 5 minutes.

Action : identifier les connexions inutiles ou les requêtes longues et examiner la configuration du pool de connexions.

### Alerte 2 — Archivage WAL

Déclencher une alerte lorsque `failed_count` dans `pg_stat_archiver` augmente ou lorsqu'aucun nouveau fichier WAL n'est archivé pendant une période anormalement longue.

Action : vérifier les journaux PostgreSQL, les droits du dossier d'archivage et l'espace disque disponible.

## 4. Commandes de contrôle

```sql
-- Connexions actives
SELECT count(*) FROM pg_stat_activity
WHERE state = 'active';

-- Requêtes exécutées depuis plus de 30 secondes
SELECT pid, usename, state, now() - query_start AS duration, query
FROM pg_stat_activity
WHERE state = 'active'
AND now() - query_start > interval '30 seconds';

-- Statistiques d'archivage WAL
SELECT archived_count, failed_count, last_archived_wal, last_archived_time
FROM pg_stat_archiver;

-- Taille de la base
SELECT pg_size_pretty(pg_database_size('retail_admin'));

-- Verrous
SELECT locktype, mode, granted
FROM pg_locks;
```

## 5. Conclusion

La supervision proposée permet de détecter les problèmes de disponibilité, de performance, de verrouillage, de stockage et d'archivage WAL.

Les seuils présentés sont des objectifs pédagogiques à adapter selon la charge réelle et les exigences de production.