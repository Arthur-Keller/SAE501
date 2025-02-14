# Chemin du fichier
FILE="/etc/network/interfaces"

# Ligne à insérer
LINES="    up ip route add 10.0.0.0/8 via 192.168.58.1 dev eth1\n    up ip route add 192.168.56.0/22 via 192.168.58.1 dev eth1"

# Vérifiez si la ligne existe déjà pour éviter les doublons
if ! grep -q "up ip route add 10.0.0.0/8 via 192.168.58.1 dev eth1" "$FILE"; then
    # Ajout des lignes juste après "post-up ip route del default dev $IFACE || true"
    sed -i "/post-up ip route del default dev \$IFACE || true/a $LINES" "$FILE"
    echo "Les routes ont été ajoutées avec succès."
else
    echo "Les routes existent déjà dans le fichier."
fi

apt-get update -y && apt-get upgrade -y 
apt-get install -y xfce4 xfce4-goodies
apt-get install -y thunderbird thunderbird-l10n-fr
apt-get install -y firefox-esr firefox-esr-l10n-fr

# Configurer le clavier en français
sudo setxkbmap fr
sudo sed -i 's/XKBLAYOUT=\"\\w*\"/XKBLAYOUT=\"fr\"/g' /etc/default/keyboard

# Redémarrage pour appliquer la configuration du clavier
/vagrant/provision-client.sh
/vagrant/client-nfs.sh
sudo reboot