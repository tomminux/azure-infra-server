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

alias runf5cli='docker run --rm -it -v /home/ubuntu/dockerhost-storage/f5-cli/.f5_cli:/root/.f5_cli -v /home/ubuntu/dockerhost-storage/f5-cli/f5-cli/:/f5-cli f5devcentral/f5-cli:latest'