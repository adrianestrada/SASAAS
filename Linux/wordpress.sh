#!/bin/sh
read -p "Deseas Instalar el Servidor desde cero 1(Yes)/2(No) [ENTER]: " script
if [ $script = 1 ];
then
	# Configurando el core del servidor
	echo -n "Configurando el lenguaje a en_US.UTF-8"
	sudo locale-gen en_US.UTF-8
	#Agregamos el repositorio de MariaDB 10.1 para Debian 8
	echo -n "Instalando repositorio de MariaDB y actualizando el servidor"
	sudo apt-get install software-properties-common
	sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db
	sudo add-apt-repository 'deb [arch=amd64,i386] http://mirrors.accretive-networks.net/mariadb/repo/10.1/debian jessie main'
	sudo apt-get update && sudo apt-get -y upgrade
	#Instalamos herramientas básicas para wordpress
	echo -n "Instalando htop y extras"
	sudo apt-get install -y htop tree vim zsh git nginx-full mariadb-server 
	#Instalar php5 y sus plugins
	echo -n "Instalando PHP5 y plugins"
	sudo apt-get install -y php5 php5-mysqlnd php5-curl php5-gd php5-intl php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl
	# creando directorio donde estaran los vhosts y las configuraciones del nginx
	echo -n "Creando el directorio de los vhosts y configuraciones del Nginx"
	sudo mkdir -p /var/www/vhosts && sudo mkdir -p /etc/nginx/sites-enabled && sudo mkdir -p /etc/nginx/sites-available
	echo -n "Introduce el nombre del vhost para crear la carpeta y presiona [ENTER]"
	read nombre
	#Creamos las carpetas con el mobre del vhost
	echo -n "Creando carpetas y archvivos de nginx con el nombre del vhost"
	sudo mkdir -p /var/www/vhosts/$nombre/public && sudo mkdir /var/www/vhosts/$nombre/logs && sudo mkdir -p /var/www/vhosts/$nombre/env/wp-cli/bin/
	cd /etc/nginx/sites-available
	cat << EOF > $nombre.conf
server {
	listen     *:80 default_server;

	root /var/www/vhosts/"$nombre"/public;
	index index.php index.html index.htm;

	access_log /var/www/vhosts/"$nombre"/logs/nginx/access.log;
	error_log /var/www/vhosts/"$nombre"/logs/nginx/error.log warn;

	server_name $nombre;
	server_name www.$nombre;

	location / {
	try_files \$uri \$uri/ /index.php?\$args;
	}	

location ~ /(\.|wp-config.php|readme.html|license.txt|licencia.txt|xmlrpc.php) {
	return 404;
	}	

location ~ \.php$ {
	limit_req zone=noflood burst=15;
	try_files \$uri =404;
	fastcgi_pass 127.0.0.1:9000;
	fastcgi_index index.php;
	fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
	include fastcgi_params;
	}	

location ~ /\. {
	deny all;
	}
}
EOF
	#Instalar wp-cli para wordpress
	echo -n "Descargando wp-cli"
	cd /var/www/vhosts/$nombre/env/wp-cli/bin/
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	# Creamos el grupo logs para poder administrar nuestros logs de nginx
	sudo groupadd logs
	mkdir -p /var/www/vhost/$nombre/logs/nginx
	read -p "Introduce el nombre de usuario de la app [ENTER]: " user
	sudo useradd $user -Umd /home/$user -G logs,www-data -s /bin/zsh
	sudo chown $user.$user -R /var/www/vhosts/$nombre/
	sudo chown root.logs -R /var/www/vhosts/$nombre/logs/nginx
	cd /etc/php5/fpm/pool.d/
	netstat -atp tcp | grep -i "listen"
	        read -p "Escribe el puerto a usar por PHP5-FPM [Enter]: " puerto
		cat << EOF > $nombre.conf
		[$nombre]
		user = vinco
		group = vinco
		listen = 127.0.0.1:$puerto
		listen.owner = $user
		listen.group = $user
		listen.mode = 0640
		 
		pm = dynamic
		pm.max_children = 5
		pm.start_servers = 2
		pm.min_spare_servers = 1
		pm.max_spare_servers = 3
EOF
	service php5-fpm restart
	service nginx restart
	su -l $user -c '(umask 0077; mkdir .ssh) && (umask 0177; touch .ssh/authorized_keys)'
	su -l $user -c 'wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - | sh'
	sudo -u $user sed -i 's/ZSH_THEME=\"\(\w\+\)\"/ZSH_THEME="dst"/' /home/$user/.zshrc

	echo "umask 027" | su -l $user -c 'cat > .zprofile'
	echo "export SITE_DIR=/var/www/vhosts/$nombre" | su -l $user -c 'cat >> .zprofile'
	echo "echo '\n\033[1;36mPara referirte al directorio de tu proyecto utiliza la variable \$SITE_DIR\033[0m'" | su -l $user -c 'cat >> .zprofile'
	read -p "Deseas Instalar el WP-ClI 1(yes)/2(No) [ENTER]: " install
	if [ $install = 1 ];
	then
		#Instalar wp-cli para wordpress
		echo -n "Descargando wp-cli"
		sudo mkdir -p /var/www/vhosts/$nombre/env/wp-cli/bin/
		cd /var/www/vhosts/$nombre/env/wp-cli/bin/
		curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
		echo "source /var/www/vhosts/$nombre/env/" | su -l $user -c 'cat >> .zprofile'
	else
		echo -n "Fin del script"
	fi

elif [ $script = 2 ];
then
	read -p "Introduce el nombre del vhost para crear la carpeta y presiona [ENTER]: " nombre
	#Creamos las carpetas con el mobre del vhost
	echo -n "Creando carpetas y archvivos de nginx con el nombre del vhost"
	sudo mkdir -p /var/www/vhosts/$nombre/public && sudo mkdir /var/www/vhosts/$nombre/logs
	cd /etc/nginx/sites-available
cat << EOF > $nombre.conf
server {
        listen     *:80 default_server;
	root /var/www/vhosts/"$nombre"/public;
	index index.php index.html index.htm;

	access_log /var/www/vhosts/"$nombre"/logs/nginx/access.log;
	error_log /var/www/vhosts/"$nombre"/logs/nginx/error.log warn;

        server_name $nombre;
        server_name www.$nombre;

	location / {
        try_files \$uri \$uri/ /index.php?\$args;
									        }       
	location ~ /(\.|wp-config.php|readme.html|license.txt|licencia.txt|xmlrpc.php) {
	return 404;
	}       

	location ~ \.php$ {
	limit_req zone=noflood burst=15;
	try_files \$uri =404;
	fastcgi_pass 127.0.0.1:9000;
	fastcgi_index index.php;
	fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
	include fastcgi_params;
	}       

	location ~ /\. {
	deny all;
	}
}
EOF
 	mkdir -p /var/www/vhost/$nombre/logs/nginx
        read -p "Introduce el nombre de usuario de la app [ENTER]: " user
	sudo useradd $user -Umd /home/$user -G logs,www-data -s /bin/zsh
	sudo chown $user.$user -R /var/www/vhosts/$nombre/
	sudo chown root.logs -R /var/www/vhosts/$nombre/logs/nginx
	su -l $user -c '(umask 0077; mkdir .ssh) && (umask 0177; touch .ssh/authorized_keys)'
	su -l $user -c 'wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - | sh'
	sudo -u $user sed -i 's/ZSH_THEME=\"\(\w\+\)\"/ZSH_THEME="dst"/' /home/$user/.zshrc

	echo "umask 027" | su -l $user -c 'cat > .zprofile'
	echo "export SITE_DIR=/var/www/vhosts/$nombre" | su -l $user -c 'cat >> .zprofile'
	echo "echo '\n\033[1;36mPara referirte al directorio de tu proyecto utiliza la variable \$SITE_DIR\033[0m'" | su -l $user -c 'cat >> .zprofile'

	read -p "Deseas Instalar el WP-ClI 1(yes)/2(No) [ENTER]: " install
	if [ $install = 1 ];
	then
	#Instalar wp-cli para wordpress
	echo -n "Descargando wp-cli"
		sudo mkdir -p /var/www/vhosts/$nombre/env/wp-cli/bin/
		cd /var/www/vhosts/$nombre/env/wp-cli/bin/
		curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
		echo "source /var/www/vhosts/$nombre/env/" | su -l $user -c 'cat >> .zprofile'
	else
		echo -n "Fin del script"
	fi
fi
