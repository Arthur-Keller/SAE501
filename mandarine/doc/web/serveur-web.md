# Documentation pour le serveur web

## Objectif
Configurer un serveur web Apache2 avec une page d'accueil personnalisée et un hôte virtuel dédié sur une machine virtuelle Debian, intégrée dans l’infrastructure réseau.

## Contexte
Le serveur web est hébergé sur la machine virtuelle nommée `srv-mail`, qui partage également le rôle de serveur mail. Nous utilisons **Rainloop**, une interface de gestion de boîte mail via le web, et un hôte virtuel pour l’accès HTTP.

## Configuration réseau et machine virtuelle

### Machine virtuelle
- **Nom de la machine** : `srv-mail`
- **Adresse IP** : `10.192.0.3` (réseau public configuré)
- **Passerelle** : `Douglas01`, qui agit comme un bridge entre l’ordinateur physique et la machine virtuelle.

### Vagrantfile
Le fichier `Vagrantfile` utilisé pour générer et configurer la machine virtuelle est disponible ici :  
[srv-mail](../../bin/srv-mail/Vagrantfile).

## Configuration réseau

### Ajout des routes
Pour permettre la communication avec d'autres machines et l'accès à Internet, ajoutez les routes suivantes :

```bash
ip r add 10.0.0.0/8 via 10.192.0.254 dev eth1
ip r add 192.168.56.0/22 via 10.192.0.254 dev eth1
```

- **10.0.0.0/8** : Couvre l'ensemble du réseau public configuré.
- **192.168.56.0/22** : Permet d'accéder aux sous-réseaux privés.
- **10.192.0.254** : Adresse IP de la passerelle.

### Configuration DNS
Pour utiliser le serveur DNS interne, mettez à jour le fichier `/etc/resolv.conf` avec les adresses des serveurs DNS locaux.

```bash
cat << EOF > /etc/resolv.conf
nameserver 10.192.0.2
nameserver 10.192.0.6
EOF
```

## Installation et configuration d'Apache2

### Installation d'Apache2
Installez le serveur web Apache2 avec la commande suivante :

```bash
apt install apache2 -y
```

### Création de la page d'accueil
Créez une page d'accueil simple pour tester le serveur web. Le fichier HTML sera placé dans le répertoire `/var/www/web`.

1. Créez le répertoire pour le site web :

   ```bash
   mkdir -p /var/www/web
   ```

2. Créez le fichier `index.html` avec le contenu suivant :

   ```bash
   cat << EOF > /var/www/web/index.html
   <h1>Bienvenue chez Mandarine</h1>
   EOF
   ```

### Configuration de l'hôte virtuel
Ajoutez un fichier de configuration pour l'hôte virtuel dans `/etc/apache2/sites-available`.

1. Créez le fichier `web.mandarine.iut.conf` :

   ```bash
   cat << EOF > /etc/apache2/sites-available/web.mandarine.iut.conf
   <VirtualHost *:80>
       ServerName web.mandarine.iut
       DocumentRoot /var/www/web

       <Directory /var/www/web>
           Options Indexes FollowSymLinks
           AllowOverride All
           Require all granted
       </Directory>

       ErrorLog ${APACHE_LOG_DIR}/web_error.log
       CustomLog ${APACHE_LOG_DIR}/web_access.log combined
   </VirtualHost>
   EOF
   ```

2. Activez le site avec la commande suivante :

   ```bash
   sudo a2ensite web.mandarine.iut.conf
   ```

3. Désactivez éventuellement le site par défaut (facultatif) :

   ```bash
   sudo a2dissite 000-default.conf
   ```

### Redémarrage du serveur Apache
Rechargez la configuration d'Apache pour appliquer les modifications.

```bash
sudo systemctl reload apache2
```

Vérifiez que le service Apache est actif :

```bash
systemctl status apache2
```

## Vérification
1. **Accès au site web** :  
   Depuis un navigateur, accédez à l’adresse suivante :  
   [http://web.mandarine.iut](http://web.mandarine.iut). Vous devriez voir la page d'accueil avec le message *"Bienvenue chez Mandarine"*.