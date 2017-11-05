Site de recettes de cuisine (partie BDD)
========================================

> Projet réalisé dans le cadre de l'UE de base de données et programmation web
> de la troisième année de licence d'informatique, avec Oracle SQL.

# Organisation

## Les modèles

Les modèles (les images) entité-association et logique relationnel sont rangés
dans le dossier [`images`](/images).

Le modèle logique relationnel est disponible en deux versions : une réalisée
avec JMerise et l'autre avec DBDesinger; cette dernière est trop large
pour être inclue dans le rapport et être lisible, mais je l'ai laissé ici
pour consultation.

J'ai également inclu le fichier [`jMerise.mcd`](/images/jMerise.mcd), qui est
justement mon fichier de travail de JMerise.

## Les contraintes

J'ai définis un certain nombre de contraintes dans le [rapport](#le-rapport)
directement, mais il faut également se baser sur le code SQL que j'ai produit,
car j'ai pu effectuer certains ajustements dans le code et oublié de répercuter
ces changements dans le rapport.

## Le rapport

Le rapport me permet de justifier comment je suis parvenu à ces modèles, et
liste un certain nombre de containtes que ces modèles devront respecter. Les
shémas y sont aussi inclus.

Le rapport se trouve dans le dossier [`report`](/report).

J'ai écrit un script shell pour générer mon rapport au format PDF qui s'appelle
[`report.pdf`](/report/report.pdf) à partir de mon fichier au format Markdown
[`report.md`](/report/report.md). Ce script shell nécessite `pandoc` et
s'appelle [`generate_report.sh`](/report/generate_report.sh).

## Les scripts SQL

Tout ce qui concerne les scripts SQL et PL/SQL sont rangés dans le dossier
[`scripts`](/scripts).

Comme il est assez embêtant de devoir à chaque fois se connecter à `sqlplus`
avec ses propres identifiants, j'ai créé un script shell qui me permet de s'y
connecter automatiquement, d'y passer un ou plusieurs fichiers à éxécuter
en argument (si aucun fichiers, ça affiche le prompt directement).

Je vous invite à regarder le script [`run.sh`](/scripts/run.sh), notament les
commentaires pour comprendre son fonctionnement.

Sinon voici ce que font les différents scripts :
  - [`create_tables.sql`](/scripts/create_tables.sql) : créer les différentes
    tables
  - [`delete_tables.sql`](/scripts/delete_tables.sql) : supprime les différentes
    tables
  - [`insert_datas.sql`](/scripts/insert_datas.sql) : insert les données pour
    pouvoir effectuer les tests dessus et réaliser les requêtes demandées.
  - [`reinsert_datas.sql`](/scripts/reinsert_datas.sql) : supprime toutes les
    tables, créer les tables et insert à nouveau les données. Pratique lorsque
    l'on souhaite modifier le script d'insertion et tester directement.
  - [`clear_tables.sql`](/scripts/clear_tables.sql) : supprime toutes les
    tables et les créé à nouveau. Cela a pour effet de les vider et d'être
    certain qu'elles possèdent la dernière architecture définie par le script
    de création.
  - [`show_tables.sql`](/scripts/show_tables.sql) : affiche toutes les tables
    créés, utile surtout au départ pour vérifier que toutes les tables se sont
    bien créées correctement
  - [`always_run.sql`](/scripts/always_run.sql) : script SQL lancé à chaque fois
    lors de l'utilisation de mon script shell avant de lancer un autre script.
    Je l'utilise pour avoir un meilleur format d'affichage (pour éviter d'avoir
    les en-têtes répétées une multitude de fois).
  - [`requetes_partie1.sql`](/scripts/requetes_partie1.sql) : toutes les
    requêtes SQL demandées pour la partie 1 du projet. A lancer après avoir créé
    les différentes tables et avoir inséré les données. (des justifications et
    précisions sont en commentaires dans le fichier, veuillez les consulter).
  - [`partie_plsql.sql`](/scripts/partie_plsql.sql) : toutes les fonctions,
    procédures, triggers, ... en PL/SQL.
