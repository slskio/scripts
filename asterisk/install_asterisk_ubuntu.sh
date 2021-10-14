#!/bin/sh
#Ubuntu 20.04

#Step 1: Install Build Dependencies
echo "############"
echo "Step 1: Install Build Dependencies"
echo "############"
add-apt-repository universe
apt -y install git curl wget libnewt-dev libssl-dev libncurses5-dev subversion libsqlite3-dev build-essential libjansson-dev libxml2-dev uuid-dev

#Step 2: Download and Install Asterisk
echo "############"
echo "Step 2: Download and Install Asterisk"
echo "############"
cd ~
wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-18-current.tar.gz
tar xvfz asterisk-18-current.tar.gz
cd asterisk-18*/contrib/scripts
./install_prereq install

#Step 3: Set Asterisk menu options
echo "############"
echo "Step 3: Set Asterisk menu options"
echo "############"
cd ~
cd asterisk-18*/
./configure
make menuselect.makeopts
menuselect/menuselect --enable CORE-SOUNDS-EN-ULAW --enable CORE-SOUNDS-EN-ALAW

#Step 4: Build and Install Asterisk
echo "############"
echo "#Step 4: Build and Install Asterisk"
echo "############"
make
make install
make samples
make config
ldconfig

#Step 5: Configure and Start Asterisk
echo "############"
echo "Step 5: Configure and Start Asterisk"
echo "############"
sleep 5
groupadd asterisk
useradd -r -d /var/lib/asterisk -g asterisk asterisk
usermod -aG audio,dialout asterisk
chown -R asterisk.asterisk /etc/asterisk /var/{lib,log,spool}/asterisk /usr/lib/asterisk

sed -i 's/#AST_USER="asterisk"/AST_USER="asterisk"/g' /etc/default/asterisk
sed -i 's/#AST_GROUP="asterisk"/AST_GROUP="asterisk"/g' /etc/default/asterisk
sed -i 's/;runuser = asterisk/runuser = asterisk/g' /etc/asterisk/asterisk.conf
sed -i 's/;rungroup = asterisk/rungroup = asterisk/g' /etc/asterisk/asterisk.conf

systemctl restart asterisk
systemctl enable asterisk

#Step 6: Custom configuration
echo "############"
echo "#Step 6: Custom configuration"
echo "############"
echo """
# Add the following line at the end of the [radius] section
vim /etc/asterisk/cdr.conf
[radius]
radiuscfg => /etc/radcli/radiusclient.conf

vim /etc/asterisk/cel.conf
[radius]
radiuscfg => /etc/radcli/radiusclient.conf

#disable pbx_ael.so
vim /etc/asterisk/moduled.conf
noload = pbx_ael.so
"""
