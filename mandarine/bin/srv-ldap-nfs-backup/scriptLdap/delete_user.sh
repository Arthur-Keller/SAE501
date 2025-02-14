#!/bin/bash

LDAP_SERVER="ldap://192.168.57.4"
BASE_DN="dc=mandarine,dc=iut"
BIND_DN="cn=admin,dc=mandarine,dc=iut"
BIND_PASSWORD="admin"


read -p "Entrez l'UID (prenom.nom) de l'utilisateur à supprimer : " USER_UID

USER_DN=$(ldapsearch -x -LLL -H "$LDAP_SERVER" -D "$BIND_DN" -w "$BIND_PASSWORD" -b "$BASE_DN" "(uid=$USER_UID)" dn | grep "^dn: " | sed 's/^dn: //')

if [ -z "$USER_DN" ]; then
  echo "Utilisateur avec UID '$USER_UID' introuvable."
  exit 1
fi

echo "Utilisateur trouvé : $USER_DN"

read -p "Voulez-vous vraiment supprimer cet utilisateur ? (oui/non) : " CONFIRMATION
if [[ "$CONFIRMATION" != "oui" ]]; then
  echo "Suppression annulée."
  exit 0
fi

ldapdelete -x -H "$LDAP_SERVER" -D "$BIND_DN" -w "$BIND_PASSWORD" "$USER_DN"

if [ $? -eq 0 ]; then
  echo "Utilisateur '$USER_UID' supprimé avec succès."
else
  echo "Erreur lors de la suppression de l'utilisateur '$USER_UID'."
  exit 1
fi