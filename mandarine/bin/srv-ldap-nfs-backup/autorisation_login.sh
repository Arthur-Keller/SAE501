#!/bin/bash

# Récupérer les paramètres PAM
USER=$1

# Configuration LDAP
LDAP_SERVER="ldap://192.168.57.4"
BASE_DN="dc=mandarine,dc=iut"
BIND_DN="cn=admin,dc=mandarine,dc=iut"
BIND_PW="admin"

# Récupération du GID de l'utilisateur
GID=$(ldapsearch -x -LLL -H "$LDAP_SERVER" -D "$BIND_DN" -w "$BIND_PW" -b "$BASE_DN" "(uid=$USER)" | grep "gidNumber" | awk '{print $2}')
NAME=$(hostname)

# Vérification des OU autorisés
if [[ "$GID" == "100" && "$NAME" == "clientInfo" ]]; then
    exit 0  # Autoriser l'accès
elif [[ "$GID" == "200" && "$NAME" == "clientAdmin" ]]; then
    exit 0  # Autoriser l'accès
else
    exit 1  # Refuser l'accès
fi
