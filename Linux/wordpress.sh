#!/bin/bash

# Configurando el core del servidor
sudo locale-gen en_US.UTF-8
#Agregamos el repositorio de MariaDB 10.1 para Debian 8
sudo apt-get install software-properties-common
sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db
sudo add-apt-repository 'deb [arch=amd64,i386] http://mirrors.accretive-networks.net/mariadb/repo/10.1/debian jessie main'
sudo apt-get update && sudo apt-get -y upgrade
#Instalamos herramientas básicas para wordpress
sudo apt-get install -y htop tree vim zsh git nginx-full mariadb-server 
#Instalar php5 y sus plugins
sudo apt-get install -y php5 php5-mysqlnd php5-curl php5-gd php5-intl php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl
# creando directorio donde estaran los vhosts y las configuraciones del nginx 
sudo mkdir -p /var/www/vhosts && sudo mkdir -p /etc/nginx/sites-enabled && sudo mkdir -p /etc/nginx/sites-available
# Creamos el grupo logs para poder administrar nuestros logs de nginx
sudo groupadd logs
