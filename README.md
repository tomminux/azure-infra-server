# Usage

## ..:: azure-infra-server ::..
Bash scripts and Ansible playbook to automate the creation of a Linux Ubuntu Server ini Azure VNET to manage Kubernetes cluster (vanilla and/or AKS) with kubectl and k9s and to host a private docker registry running in a docker container.

Connect to az-infra-server with user "ubuntu"

    git clone https://github.com/tomminux/azure-infra-server.git

    cd azure-infra-server/
    bash init-scripts/1.infra-server.sh 

Put registry's certificates (they have to be signed by a public CA if you want to use AKS) here:

    cd ~/azure-infra-server/ansible/playbooks/files/docker-files/

If you would like to use self-signed certificates, please generate them with opensssl 
 
    openssl req -newkey rsa:4096 -nodes -sha256 -keyout registry.key -x509 -days 3650 -out registry.crt

and when you are going to use this private registry with you vanilla k8s, you'll neet to modify each node to authorize the connection to a private registry with a specific FQDN, please see (official docs for Docker)[https://docs.docker.com/registry/insecure/#use-self-signed-certificates]

Check the host inventory file

    vim ~/azure-infra-server/ansible/inventory/hosts

We are now ready to execute the Ansible Playbook to configure everything we need:

    cd ~/azure-infra-server/ansible
    ansible-playbook playbooks/infra-server.yaml

Once the playbook is finishied installing and configuring, please remember to logout and log in again to infra-server using ssh

    exit

and after you have re-sshed into the box, you should be able to succesfully run

    k9s
    kubectl

