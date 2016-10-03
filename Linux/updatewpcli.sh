#!/bin/bash
WPROUTE="/root/.scripts/"
VHOSTS="/var/www/vhosts/"
cd $WPROUTE
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
find $VHOSTS -name "wp-cli*" -type d -exec cp $WPROUTE/wp-cli.phar {}/bin/ \;
