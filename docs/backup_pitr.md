# Sauvegarde, restauration et archivage WAL — RetailOps

## 1. Objectif

L'objectif est de garantir la disponibilité et la récupération des données PostgreSQL en cas de panne, de perte de données ou d'erreur humaine.

Le projet utilise une sauvegarde logique avec `pg_dump`, une restauration avec `pg_restore` et un archivage des journaux WAL.

## 2. Sauvegarde logique avec pg_dump

Une sauvegarde de la base `retail_admin` a été réalisée au format personnalisé PostgreSQL.

Commande utilisée :

```bash
docker compose exec -T db pg_dump -U postgres -d retail_admin -Fc > backups/retail_admin.dump
```

Résultat : le fichier `backups/retail_admin.dump` a été créé avec une taille d'environ 127 Ko.

## 3. Test de restauration avec pg_restore

Une base distincte nommée `retail_restore_check` a été créée afin de vérifier la sauvegarde sans modifier la base originale.

Création :

```bash
docker compose exec db createdb -U postgres retail_restore_check
```

Restauration :

```bash
docker compose exec -T db pg_restore -U postgres -d retail_restore_check < backups/retail_admin.dump
```

La comparaison des nombres de lignes a donné les résultats suivants :

| Table | Base originale | Base restaurée |
|---|---:|---:|
| customers | 300 | 300 |
| products | 80 | 80 |
| orders | 5 000 | 5 000 |
| order_items | 9 989 | 9 989 |

Le test confirme que les données des quatre tables ont été restaurées avec les mêmes nombres de lignes.

La preuve est disponible dans `evidence/restore_comparison.txt`.

## 4. Configuration de l'archivage WAL

L'archivage WAL (Write-Ahead Logging) permet de conserver les journaux des modifications effectuées dans PostgreSQL.

Les paramètres configurés sont :

```sql
SHOW archive_mode;
SHOW archive_command;
SHOW wal_level;
```

Configuration appliquée :

- `archive_mode = on`
- `wal_level = replica`
- `archive_command` : copie les fichiers WAL terminés dans `/var/lib/postgresql/data/wal_archive/`.

Le répertoire d'archivage est situé dans le volume persistant PostgreSQL et appartient à l'utilisateur système `postgres`.

## 5. Vérification de l'archivage WAL

La fonction `pg_switch_wal()` a été utilisée pour déclencher le passage au fichier WAL suivant.

Résultat observé dans `pg_stat_archiver` :

| Indicateur | Résultat |
|---|---:|
| archived_count | 2 |
| failed_count | 0 |
| Fichiers WAL présents | 2 |
| Taille totale approximative | 32 Mo |

Les deux fichiers WAL archivés ont été vérifiés dans le répertoire `wal_archive`.

La preuve est disponible dans `evidence/wal_archiver_status.txt`.

## 6. Principe de récupération PITR

Le PITR (Point-In-Time Recovery) permet de restaurer une base PostgreSQL à un instant précis.

Le principe général est le suivant :

1. Disposer d'une sauvegarde physique de base compatible avec PITR.
2. Restaurer cette sauvegarde dans un environnement de récupération.
3. Fournir les fichiers WAL archivés nécessaires.
4. Configurer une cible de récupération, par exemple une date et une heure.
5. Laisser PostgreSQL rejouer les journaux WAL jusqu'à cette cible.

**Limite du test réalisé :** le projet a validé la sauvegarde logique, la restauration logique et l'archivage WAL. Une restauration PITR complète n'a pas encore été exécutée. Elle nécessite une sauvegarde physique de base, par exemple avec `pg_basebackup`, ainsi que les fichiers WAL correspondants.

## 7. Objectifs RPO et RTO

Les objectifs suivants sont proposés pour cet environnement pédagogique :

| Indicateur | Objectif | Signification |
|---|---:|---|
| RPO | 15 minutes | Perte maximale de données visée |
| RTO | 1 heure | Durée maximale visée pour rétablir le service |

Ces valeurs sont des objectifs théoriques et ne constituent pas des garanties mesurées.

## 8. Conclusion

Les tests réalisés démontrent le fonctionnement de la sauvegarde logique, de la restauration dans une base distincte et de l'archivage WAL.

Ces mécanismes constituent une première base pour assurer la protection et la récupération des données. Une procédure PITR complète devra être testée avant toute utilisation en production.