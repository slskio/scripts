#!/bin/sh
#Ubuntu 20.04

apt -y install monit
cat <<EOF > /etc/monit/conf.d/kamailio
check process kamailio with pidfile /var/run/kamailio/kamailio.pid
  start program = "/usr/bin/systemctl start kamailio"
  stop program = "/usr/bin/systemctl stop kamailio"
  if 6 restarts within 6 cycles then timeout

check host kamailio_server with address 127.0.0.1
   if failed port 5060 type udp protocol sip
      with target "localhost:5060" and maxforward 6
   then alert
EOF

# Main monitrc configuration
cat <<EOF > /etc/monit/monitrc
set daemon 30             # check services at 30-sec intervals
set log /var/log/monit.log

set mailserver ${1:-localhost}
set alert ${2:-root@localhost}

set idfile /var/lib/monit/id
set statefile /var/lib/monit/state

set eventqueue
basedir /var/lib/monit/events # set the base directory where events will be stored
slots 100                     # optionally limit the queue size

set httpd port 2812 and
    use address localhost  # only accept connection from localhost (drop if you use M/Monit)
    allow localhost        # allow localhost to connect to the server and

include /etc/monit/conf.d/*
include /etc/monit/conf-enabled/*
EOF

systemctl restart monit
systemctl status monit

monit summary
