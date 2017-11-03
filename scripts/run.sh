#!/bin/sh

# Script créé par Ludovic Muller
#
# Ce qu'il faut faire avant de lancer ce script
#  - configurer une variable ORACLE_PASSWD dans le .bashrc, .bash_profile ou
#    tout simplement dans le terminal avant de lancer ce script avec :
#    export ORACLE_PASSWD=MotDePasseDeMaBaseOracle
#    (en remplaçant bien évidemment par votre mot de passe Oracle ;p)
#  - s'assurer que le nom d'utilisateur courant est bien le même que celui de
#    la base Oracle en question
#
# En cas de difficultés, il est possible de modifier directement les deux
# variables ci-dessous avec les bonnes valeur (mais ne diffusez pas ce script
# par la suite sans retirer vos identifiants)

# configuration des variables (si besoin)
DB_USER="$USER"
DB_PASSWORD="$ORACLE_PASSWD"

# lance `sqlplus`
DB_CMD="sqlplus -s $DB_USER/$DB_PASSWORD @always_run.sql"
if [ "$#" -eq 0 ]; then
  # dans le cas sans fichier passé en argument, on lance un prompt directement
  echo "Entrez vos commandes SQL, puis valider avec Entrée (exit pour quitter) :"
  eval "$DB_CMD"
else
  # On lance simplement tous les fichiers passés en argument s'il y en a
  # sans laisser de prompt pour l'utilisateur
  while [ "$#" -ne 0 ]; do
    if [ -f "$1" ]; then
      echo " => Exécution du fichier '$1'..."
      echo "@$1" | eval "$DB_CMD"
    else
      echo " => /!\ Le fichier '$1' est inexistant !"
    fi
    shift
  done;
  echo " => Fin des exécutions."
fi

exit 0
