#!/bin/bash
WPROUTE="/root/.scripts/"
VHOSTS="/var/www/vhosts/"
echo -n "Deseas Instalar el script y/n [ENTER]: "
read script
if [$script = y]; then
	cd /root/
	mkdir .scripts
	cd /root/.scripts 
	curl -O https://raw.githubusercontent.com/adrianestrada/SASAAS/master/Linux/updatewpcli.sh
	chmod +x updatewpcli.sh
	echo "0 0 * * 0 root /root/.scripts/updatewpcli.sh" >> /etc/crontab
if [$script = n]
	echo -n "Deseas Actualizar el WP-Cli y/n [ENTER]"
	read update
	if [$read = y]; then
		cd $WPROUTE
		curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
		find $VHOSTS -name "wp-cli*" -type d -exec cp $WPROUTE/wp-cli.phar {}/bin/ \;
	else
fi
