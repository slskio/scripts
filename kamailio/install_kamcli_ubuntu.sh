#!/bin/sh
#Ubuntu 20.04

apt install python3 python3-pip python3-setuptools python3-dev libmariadb-dev sngrep dos2unix

cd /usr/local/src/
git clone https://github.com/kamailio/kamcli.git

cd kamcli
pip3 install -r requirements/requirements.txt
pip3 install mysqlclient
pip3 install .

kamcli config install
