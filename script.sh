#! /bin/bash
apt-get update
# Instalacion de apache
apt-get install -y apache2
cp /vagrant/index.php /var/www/html
apt-get install -y php libapache2-mod-php php-mysql
# Instalacion  de las utilidades dconf
apt-get -y install debconf-utils
# instalacion de la contraseña root
DB_ROOT_PASSWD=julioasir
debconf-set-selections <<< "mysql-server mysql-server/root_password password $DB_ROOT_PASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DB_ROOT_PASSWD"
#instalacion de mysql
apt-get install -y mysql-server
#clonar el repositorio de la aplicacion web
apt-get install -y git
rm -f /var/www/html/index.html
cd /tmp
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git
cp iaw-practica-lamp/src/. /var/www/html/ -R
cd /var/www/html
chown www-data:www-data * -R 
mysql -u root -p$DB_ROOT_PASSWD < /tmp/iaw-practica-lamp/db/database.sql
