# Practica-01-LAMP_STACK
###### Vamos a instalar la pila LAMP en la maquina virtual Ubuntuserver 18.04
## 1. Instalacion de PhpMyAdmin.
Tenemos que instalar composer

```` sudo apt install composer ````

Ahora tenemos que clonar el repositorio y moverlo al directorio /html.

````sudo git clone https://github.com/phpmyadmin/phpmyadmin.git ````

```` sudo mv /home/USER/composer.phar /etc/var/www/html/phpmyadmin ````

Con la actualizacion del nuevo ubutu 18.04 si dejamos esto tal cual dara error en dos de sus reposiorios por eso tenemos que editar el archivo composer.json que es donde se encuentran las directivas y eliminamos los dos primeros archivos de la seccion *required-dev*

````sudo nano composer.json````

Actualizamos composer para que actualize los datos 

````php composer.phar update````

Por defecto los permisos se encuentran como root lo cual no se puede acceder desde otra maquina:

````sudo chown www-data:www-data phpmyadmin/ -R````

## 2. Instalación de Adminer.
###### Adminer es una alternativa a PhpMyAdmin pero esta comrimido en solo un archivo .php

Descargamos el archivo y clonamos el archivo dentro de el directorio /html y cambioamos tambien los permisos 

````sudo git clone https://github.com/vrana/adminer/releases/tag/v4.6.3/adminer-4.6.3-en.php.git ````

````sudo chown www-data:www-data adminer/ -R````

## 3. Instalacion de GoAccess
Añadimos los repositorios 

````echo "deb http://deb.goaccess.io/ $(lsb_release -cs) main" | sudo tee -a /etc/apt/sources.list.d/goaccess.list````

lo descargamos e instalamos:

````wget -O - https://deb.goaccess.io/gnugpg.key | sudo apt-key add -````

``sudo apt-get update``

``sudo apt-get install goaccess``

Para que se muestre la información del log en tiempo real en el terminal en modo texto.

``goaccess /var/log/apache2/access.log -c``

# 4. Control de acceso a un directorio con .htaccess
Dentro del directorio ``/var/www/html`` creamos un directorio llamado stats donde se podrán consultar los informes generados con goaccess.

``mkdir /var/www/html/stats``

Lanzamos el proceso para que se ejecute en segundo plano

``sudo goaccess /var/log/apache2/access.log -o /var/www/html/stats/index.html --log-format=COMBINED --real-time-html &`` 

Creamos un directoio seguro

``sudo htpasswd -c /home/usuario/.htpasswd usuario``

Creamos el archivo .htaccess

``sudo /var/www/html/stats/.htaccess``

Dentro de .htaccess debe contener el siguiente texto:

``AuthType Basic
AuthName "Restricted Content"
AuthUserFile /home/usuario/.htpasswd
Require valid-user``

Dentro del archivo de configuracion Apache añadimos las etiquetas de <VirtualHost *:80> y </VirtualHost>.

``sudo nano /etc/apache2/sites-enabled/000-default.conf``

``<Directory "/var/www/html/stats">

  Options Indexes FollowSymLinks
  
  AllowOverride All
  
  Require all granted
</Directory>``

Reiniciamos Apache para que se apliquen los cambios.

``sudo /etc/init.d/apache2 restart`` ò ``sudo systemctl restart apache2`` 


