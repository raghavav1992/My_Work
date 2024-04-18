#!/bin/bash

sudo /opt/hazelcast-3.12.8/bin/start.sh > /opt/hazelcast-3.12.8/logs/logs.out 2>&1 &
sleep 30

SSH_USER="<USERNAME>"
OTHER_SERVER_IP="<OTHER_SERVER_IP>"
SSH_KEY="<OTHER_SERVER_SSH_KEY>"

# Start apache2 service on the other server
ssh -i "$SSH_KEY" "$SSH_USER"@"$OTHER_SERVER_IP" 
sudo systemctl stop apache2.service
sudo service tomcat restart
sleep 10
sudo systemctl start apache2.service