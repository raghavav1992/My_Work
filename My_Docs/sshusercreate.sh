#!/bin/bash
sudo adduser $1
echo "User added as $1"
sudo adduser $1 sudo
echo "Given the sudo permission to $1"
sudo mkdir /home/$1/.ssh/
echo "Created the user folder name is $1"
sudo chmod 0700 /home/$1/.ssh/
echo "Changed the permission to 0700"
sudo -- sh -c "echo '$2' > /home/$1/.ssh/authorized_keys"
echo "Stored the ssh key"
sudo chown -R $1:$1 /home/$1/.ssh/
echo "Changed the owner of foler $1  to $1"
echo "Done"