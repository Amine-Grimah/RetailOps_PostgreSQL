# RetailOps — Administration d'une base de données PostgreSQL

## 1. Présentation du projet

RetailOps est un projet pédagogique d'administration d'une base de données PostgreSQL dans un environnement Docker.

L'objectif est de mettre en place une infrastructure de base de données, importer un jeu de données commercial, gérer les utilisateurs et les permissions, sécuriser les connexions, réaliser des opérations de maintenance, tester les sauvegardes et analyser les performances SQL.

**Technologies utilisées :**
- PostgreSQL 17
- Docker et Docker Compose
- SQL
- pgAudit
- SSL/TLS
- Visual Studio Code

## 2. Architecture du projet

```text
RetailOps_PostgreSQL/
│
├── backups/
│   └── retail_admin.dump
│
├── config/
│   └── ssl/
│
├── dataset/
│   ├── customers.csv
│   ├── products.csv
│   ├── orders.csv
│   └── order_items.csv
│
├── docs/
│   ├── rgpd.md
│   └── supervision.md
│
├── evidence/
│   ├── data_quality_report.txt
│   ├── pg_hba_rules.txt
│   ├── ssl_server_config.txt
│   ├── ssl_connection_test.txt
│   ├── pgaudit_test.txt
│   ├── vacuum_analyze.txt
│   ├── tablespaces.txt
│   ├── restore_comparison.txt
│   ├── wal_archiver_status.txt
│   ├── perf_before.txt
│   └── perf_after.txt
│
├── sql/
│   └── projet/
│       ├── 01_schema.sql
│       ├── 02_import.sql
│       ├── 03_controls.sql
│       ├── 04_roles.sql
│       └── 05_transactions.sql
│
├── .env
├── compose.yaml
└── README.md
```

## 3. Prérequis

Avant de commencer, installer :
- Docker Desktop
- Docker Compose
- Visual Studio Code

Vérifier les installations :

```bash
docker --version
docker compose version
```

## 4. Configuration de l'environnement

Le projet utilise un fichier `.env` pour définir les paramètres de connexion PostgreSQL.

Exemple de configuration :

```env
POSTGRES_DB=retail_admin
POSTGRES_USER=postgres
POSTGRES_PASSWORD=YOUR_STRONG_PASSWORD
```

Le fichier `.env` contient des informations sensibles. Il ne doit pas être publié dans un dépôt Git.

## 5. Démarrage de PostgreSQL

Depuis le répertoire du projet :

```bash
docker compose up -d
```

Vérifier l'état du conteneur :

```bash
docker compose ps
```

Vérifier la disponibilité de PostgreSQL :

```bash
docker compose exec db pg_isready -U postgres -d retail_admin
```

Le serveur PostgreSQL utilise le port 5433 sur la machine hôte et le port 5432 dans le conteneur.

## 6. Création et alimentation de la base

Les scripts SQL doivent être exécutés dans l'ordre suivant :

### 6.1 Création du schéma et des tables

```bash
docker compose exec -T db psql -U postgres -d retail_admin < sql/projet/01_schema.sql
```

### 6.2 Importation des données CSV

```bash
docker compose exec -T db psql -U postgres -d retail_admin < sql/projet/02_import.sql
```

### 6.3 Contrôle de la qualité des données

```bash
docker compose exec -T db psql -U postgres -d retail_admin < sql/projet/03_controls.sql
```

Le schéma `retail` contient quatre tables :
- customers
- products
- orders
- order_items

**Données importées :**

| Table | Nombre de lignes |
|---|---:|
| customers | 300 |
| products | 80 |
| orders | 5 000 |
| order_items | 9 989 |
| **Total** | **15 369** |

## 7. Gestion des utilisateurs et sécurité

Le script `04_roles.sql` permet de créer les rôles et les utilisateurs de connexion.

Les rôles principaux sont :
- `retail_ro` : accès en lecture seule.
- `retail_rw` : accès en lecture et écriture.
- `analyst_login` : utilisateur destiné à l'analyse des données.
- `app_login` : utilisateur destiné à l'application.

Les mécanismes de sécurité mis en place comprennent :
- Authentification SCRAM-SHA-256.
- Configuration des règles `pg_hba.conf`.
- Connexions sécurisées SSL/TLS.
- Journalisation des opérations avec pgAudit.

## 8. Audit et conformité RGPD

L'extension pgAudit est utilisée pour journaliser les opérations de lecture, d'écriture, de définition et de gestion des rôles.

La documentation RGPD est disponible dans :

`docs/rgpd.md`

Elle présente les catégories de données, les finalités de traitement, les accès, les mesures de sécurité et les principes de conservation.

## 9. Transactions et maintenance

Le script `05_transactions.sql` présente des exemples de transactions avec :
- BEGIN
- COMMIT
- ROLLBACK

Des tests de verrouillage ont également été réalisés avec deux sessions PostgreSQL et les vues `pg_stat_activity` et `pg_locks`.

La maintenance comprend l'utilisation de :

```sql
VACUUM (VERBOSE, ANALYZE) retail.customers;
```

Les tablespaces par défaut ont également été examinés.

## 10. Sauvegarde et restauration

Une sauvegarde logique au format personnalisé a été créée avec :

```bash
docker compose exec -T db pg_dump -U postgres -d retail_admin -Fc > backups/retail_admin.dump
```

Une base de vérification distincte a été créée :

```bash
docker compose exec db createdb -U postgres retail_restore_check
```

Restauration :

```bash
docker compose exec -T db pg_restore -U postgres -d retail_restore_check < backups/retail_admin.dump
```

La comparaison des nombres de lignes a confirmé la restauration des quatre tables.

L'archivage WAL a également été activé et testé. Les statistiques sont disponibles dans `pg_stat_archiver`.

**Remarque :** l'archivage WAL a été testé séparément de la sauvegarde logique. Une récupération PITR complète nécessite une sauvegarde physique de base compatible et les fichiers WAL correspondants.

## 11. Analyse des performances

Une analyse des performances a été réalisée avec :

```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM retail.orders
WHERE customer_id = 100;
```

Un index a ensuite été créé :

```sql
CREATE INDEX idx_orders_customer_id
ON retail.orders(customer_id);
```

**Résultats mesurés :**

| Indicateur | Avant index | Après index |
|---|---:|---:|
| Plan | Seq Scan | Bitmap Heap Scan |
| Temps d'exécution | 1,785 ms | 1,261 ms |
| Lignes retournées | 21 | 21 |

Les preuves sont disponibles dans :
- `evidence/perf_before.txt`
- `evidence/perf_after.txt`

## 12. Supervision

La documentation de supervision est disponible dans `docs/supervision.md`.

Elle présente les principaux indicateurs à surveiller :
- Disponibilité PostgreSQL.
- Nombre de connexions actives.
- Requêtes longues.
- Verrous.
- Taille de la base.
- Archivage WAL.
- Utilisation du stockage.

Deux seuils d'alerte sont proposés : le taux de connexions et les échecs d'archivage WAL.

## 13. Arrêt de l'environnement

Pour arrêter les conteneurs sans supprimer les données persistantes :

```bash
docker compose down
```

Pour redémarrer :

```bash
docker compose up -d
```

**Attention :** ne pas utiliser `docker compose down -v` sans nécessité, car cette commande supprime également le volume PostgreSQL et donc les données persistantes.

## 14. Conclusion

Ce projet a permis de mettre en pratique les principales opérations d'administration d'une base PostgreSQL : installation, configuration, importation, gestion des accès, sécurisation, audit, maintenance, sauvegarde, restauration, archivage WAL, analyse des performances et supervision.

L'environnement constitue une plateforme pédagogique permettant de reproduire les manipulations et de comprendre les mécanismes fondamentaux de l'administration PostgreSQL.