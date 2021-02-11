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

## ..:: Ubuntu distibution update to latest software releases ::..
## ----------------------------------------------------------------------------

DEBIAN_FRONTEND=noninteractive
sudo apt update 
sudo apt upgrade -y
sudo apt autoremove

## ..:: Base system and networking configuration ::..
## ----------------------------------------------------------------------------

sudo sh -c 'echo "infra-server" > /etc/hostname'

cat <<EOF > rc.local
#!/bin/bash
ifconfig eth0:30 10.160.20.30/24 up

## ..:: Max Map Count for VM when runnign ELK in a Docker container ::..
sysctl -w vm.max_map_count=262144

exit 0
EOF

sudo chown root:root rc.local
sudo mv rc.local /etc/.
sudo chmod 755 /etc/rc.local
sudo /etc/rc.local

sudo apt install -y apt-transport-https ca-certificates curl software-properties-common 

## --> DNSMASQ Installation and configuration
sudo apt install dnsmasq -y

sudo systemctl disable systemd-resolved
sudo systemctl stop systemd-resolved
sudo sh -c 'echo "10.160.20.20 az-infra-server" >> /etc/hosts'
sudo rm /etc/resolv.conf

sudo sh -c 'cat <<EOF > /etc/resolv.conf
search multicloud-demo.com
nameserver 10.160.20.20
nameserver 168.63.129.16
nameserver 8.8.8.8
EOF'

sudo systemctl enable dnsmasq
sudo systemctl restart dnsmasq

cat <<EOF >> /home/ubuntu/.bashrc
alias ka='kubectl apply -f'
alias kd='kubectl delete -f'
alias kg='kubectl get'
alias kgp='kubectl get pods -A'
alias kl='kubectl logs'
alias kdpod='kubectl describe pod'
alias kdsvc='kubectl describe service'
alias kdvs='kubectl describe vs'

alias 3k9s='k9s --kubeconfig /home/ubuntu/.kube/config-k3s -A'
alias 8k9s='k9s --kubeconfig /home/ubuntu/.kube/config-k8s -A'
EOF

sudo reboot