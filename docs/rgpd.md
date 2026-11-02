# Documentation RGPD — Projet RetailOps

## 1. Présentation du projet

Le projet RetailOps consiste à administrer une base de données PostgreSQL destinée à gérer les activités commerciales d'une entreprise fictive de vente au détail.

La base contient des informations relatives aux clients, aux produits, aux commandes et aux lignes de commande.

L'objectif est de garantir la sécurité, la confidentialité, la disponibilité et la traçabilité des données.

## 2. Données personnelles traitées

La table `retail.customers` contient des données personnelles concernant les clients :

| Donnée | Description | Nature |
|---|---|---|
| customer_id | Identifiant du client | Identifiant |
| full_name | Nom complet | Donnée personnelle |
| email | Adresse électronique | Donnée personnelle |
| region | Région du client | Donnée de localisation |
| created_at | Date de création du client | Donnée temporelle |

Les autres tables (`products`, `orders` et `order_items`) contiennent principalement des informations relatives aux produits et aux transactions commerciales. Les commandes peuvent toutefois être reliées à un client grâce à `customer_id`.
## 3. Finalités du traitement

Les données sont utilisées dans le cadre des activités de gestion commerciale :

- Identifier les clients.
- Consulter l'historique des commandes.
- Assurer le suivi des ventes.
- Réaliser des analyses commerciales et statistiques.
- Produire des indicateurs de performance.

Les données ne doivent pas être utilisées à des fins incompatibles avec ces objectifs.

## 4. Gestion des accès et sécurité

L'accès aux données est limité selon le principe du moindre privilège.

Deux rôles fonctionnels ont été créés :

| Rôle | Permissions |
|---|---|
| `retail_ro` | Lecture des données |
| `retail_rw` | Lecture, insertion, modification et suppression |

Les comptes `analyst_login` et `app_login` héritent respectivement de ces rôles.

Les mesures de sécurité mises en place sont :

- Authentification des utilisateurs avec SCRAM-SHA-256.
- Contrôle des connexions avec `pg_hba.conf`.
- Chiffrement des communications avec SSL/TLS.
- Journalisation des opérations avec pgAudit.
- Protection des clés privées et des mots de passe.
- Sauvegarde de la base de données.

## 5. Conservation et suppression des données

Dans un environnement réel, une durée de conservation doit être définie pour chaque catégorie de données selon sa finalité et les obligations légales applicables.

À la fin de la durée prévue, les données doivent être supprimées ou anonymisées lorsque cela est approprié.

Dans le cadre de ce projet pédagogique, les données sont synthétiques et aucune suppression arbitraire n'est effectuée.
## 6. Droits des personnes

Dans un contexte réel, les personnes concernées disposent notamment des droits suivants, conformément au RGPD :

- Droit d'accès à leurs données personnelles.
- Droit de rectification des informations incorrectes.
- Droit à l'effacement, lorsque les conditions légales sont réunies.
- Droit à la limitation du traitement.
- Droit d'opposition, selon les conditions applicables.

Les demandes doivent être traitées par une personne habilitée et documentées.

## 7. Gestion des incidents et protection des sauvegardes

En cas d'incident de sécurité, une procédure doit permettre :

- D'identifier et de qualifier l'incident.
- De limiter rapidement ses conséquences.
- De préserver les journaux et les preuves techniques.
- D'évaluer les risques pour les personnes concernées.
- De notifier l'autorité compétente et les personnes concernées lorsque la réglementation l'exige.

Les sauvegardes doivent être protégées contre les accès non autorisés. Leur accès doit être limité aux administrateurs habilités et leur restauration doit être testée régulièrement.

## 8. Limites du projet

Ce projet est un environnement pédagogique utilisant des données synthétiques. Il démontre plusieurs mécanismes techniques de sécurité et de traçabilité, mais ne constitue pas à lui seul une certification de conformité au RGPD.

Une mise en production nécessiterait notamment une analyse juridique, une politique de conservation documentée, des procédures opérationnelles et une gestion formalisée des droits des personnes.