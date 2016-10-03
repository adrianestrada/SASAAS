#!/bin/bash
cd /root/
mkdir .scripts
cd /root/.scripts
curl -O https://raw.githubusercontent.com/adrianestrada/SASAAS/master/Linux/updatewpcli.sh
chmod +x updatewpcli.sh
echo "0 0 * * 0 root /root/.scripts/updatewpcli.sh" >> /etc/crontab
