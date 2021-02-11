# Usage

## ..:: azure-infra-server ::..
Bash scripts and Ansible playbook to automate the creation of a Infrastructure Server in F5 UDF Environment

Connect to az-infra-server with user buntu 

    git clone https://github.com/tomminux/azure-infra-server.git

    cd azure-infra-server/
    bash init-scripts/1.infra-server.sh 

    cd ~/azure-infra-server/ansible/playbooks/files/docker-files/
    openssl req -newkey rsa:4096 -nodes -sha256 -keyout registry.key -x509 -days 3650 -out registry.crt

Check the host inventory file

    vim ~/f5-udf-infra-server/ansible/inventory/hosts

We are now ready to execute the Ansible Playbook to configure everything we need:

    cd ~/azure-infra-server/ansible
    ansible-playbook playbooks/infra-server.yaml

Once the playbook is finishied installing and configuring, please remember to logout and log in again to infra-server using ssh

    exit

and after you have re-sshed into the box, you should be able to succesfully run

    k9s

to see your k3s cluster running.

## ..:: BIG-IP CIS / Security Onboarding ::..

Create a new BIG-IP, with AWS License

    Hostname: bigip-security
    Instance Type: c4.4xlarge 
    vCPUs: 16
    Memory: 30 GiB
    Disk Size: 105 GiB

In my UDF Blueprint, this UDF is on 10.1.1.5 and you should immediately bind two other networks so that you have:

    mgmt: 10.1.1.5
    external vlan on interface 1.1: 10.1.10.5
    internal vlan on interface 1.2: 10.1.20.5

Connect to the web shell of the just created and booted BIG-IP and issue the following command

    tmsh modify auth user admin password Default1234!

Thank go back to the CLI of infra-server and run

    runf5cli f5 login --authentication-provider bigip --host 10.1.1.5 --user admin
    runf5cli f5 config set-defaults --disable-ssl-warnings true

Install the full ATC Package (DO, AS3 and TS)

    runf5cli f5 bigip extension do install
    runf5cli f5 bigip extension as3 install
    runf5cli f5 bigip extension ts install

Now go and check the DO json configuration file for bigip-security

    vim ~/dockerhost-storage/f5-cli/f5-cli/do/bigip-security-do.json
    
then apply it:

    runf5cli f5 bigip extension do create --declaration do/bigip-security-do.json

Follow instraction here: 
[Calico BIG-IP Configuration](https://clouddocs.f5.com/containers/latest/userguide/calico-config.html?highlight=calico) 
to configure Calico on BIG-IP (on k3s we have aleady done it with the previous Ansible Playbook)

Verify that Calico is working correctly executing these command on BIG-IP bash:

    imish
    show bgp neighbors
    show ip route

## ..:: UDF-SERVICES Configuration ::..

We are now ready to execute the second playbook to deply UDF-Services on k3s, 
with CIS on BIG-IP acting as the main ingress controller for these services

Connect to infra-server and issue:

    cd ~/f5-udf-infra-server/ansible
    ansible-playbook playbooks/udf-services.yaml

This should automatically deploy
- 2 namespaces
  - ingress-services (to host the bigip-k3s-controller)
  - udf-services 
- BIG-IP Controller
- Gitlab
- Grafana
- Prometheus

You can verify that everything is runnning with

    k9s

On BIG-IP you shoud have now two more partitions
- k3s
- udf-services

and a number of Virtual Servers running in the udf-services partition