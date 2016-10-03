#!/bin/sh
WPROUTE="/root/.scripts/"
VHOSTS="/var/www/vhosts/"
read -p "Deseas Instalar el script 1(Yes)/2(No) [ENTER]: " script

if [ $script = 1 ];
then
	cd /root/
	mkdir .scripts
	cd /root/.scripts
	curl -O https://raw.githubusercontent.com/adrianestrada/SASAAS/master/Linux/updatewpcli.sh
	chmod +x updatewpcli.sh
	echo "0 0 * * 0 root /root/.scripts/updatewpcli.sh" >> /etc/crontab
	echo -n "Script instalado correctamente"
elif [ $script = 2 ];
then
	read -p "Deseas Actualizar el WP-Cli 1(yes)/2(No) [ENTER]: " update
	if [ $update = 1 ];
	then
		cd $WPROUTE
		curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
		find $VHOSTS -name "wp-cli*" -type d -exec cp $WPROUTE/wp-cli.phar {}/bin/ \;
	else
		echo -n "Fin del script"
	fi
fi
