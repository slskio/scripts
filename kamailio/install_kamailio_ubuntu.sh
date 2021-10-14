#!/bin/sh
#Ubuntu 20.04

wget -O- http://deb.kamailio.org/kamailiodebkey.gpg | sudo apt-key add -

tee /etc/apt/sources.list.d/kamailio.list<<EOF
deb     http://deb.kamailio.org/kamailio55 focal main
deb-src http://deb.kamailio.org/kamailio55 focal main
EOF

apt update
apt -y install mariadb-server
apt -y install kamailio kamailio-mysql-modules
apt -y install kamailio-tls-modules

sed -i "s/^# DBENGINE.*/DBENGINE=MYSQL/" /etc/kamailio/kamctlrc
sed -i "s/^# DBHOST.*/DBHOST=localhost/" /etc/kamailio/kamctlrc
sed -i "s/^#CHARSET.*/CHARSET=\"latin1\"/" /etc/kamailio/kamctlrc

printf "y\ny\ny\n" | /usr/sbin/kamdbctl create

kamailio -V

wget https://raw.githubusercontent.com/slskio/scripts/main/kamailio/kamailio.cfg -O /tmp/kamailio.cfg
cp /tmp/kamailio.cfg /etc/kamailio/kamailio.cfg

systemctl restart kamailio
systemctl status kamailio
kamctl dispatcher show
