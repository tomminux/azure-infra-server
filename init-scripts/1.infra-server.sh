#!/bin/bash

## ============================================================================
##
## 1.infra-server.sh Init Script
##
## Author:  Paolo Tomminux Arcagni - F5 
## Date:    November 2020
## Version: 1.0
## 
## This script can be used to initialize the configuration on the infra-server
## in F5 UDF Environment to adapt it to the environment itself and prepare it to
## execute needed stuff to operate demos. 
##
## Execute this script as "ubuntu" user on infra-server
##
##
##
##
## ============================================================================

## ..:: SSH Keys Initialization phase ::..
## ----------------------------------------------------------------------------

# -> Creating SSH keys for user "root" and "ubuntu" 

sudo ssh-keygen -b 2048 -t rsa
sudo sh -c 'cp /root/.ssh/id_rsa* /home/ubuntu/.ssh/.'
sudo chown ubuntu:ubuntu /home/ubuntu/.ssh/id*
sudo sh -c 'cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys'
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

## ..:: Base system and networking configuration ::..
## ----------------------------------------------------------------------------

#cat <<EOF > rc.local
##!/bin/bash
#ifconfig eth0:30 10.160.20.30/24 up
#
### ..:: Max Map Count for VM when runnign ELK in a Docker container ::..
#sysctl -w vm.max_map_count=262144
#
#exit 0
#EOF

# sudo chown root:root rc.local
# sudo mv rc.local /etc/.
# sudo chmod 755 /etc/rc.local
# sudo /etc/rc.local

#sudo reboot