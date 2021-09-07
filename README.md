# awx-operator in a kubernetes cluster

Based on [AWX Operator modue](https://github.com/ansible/awx-operator)

with lots of help from [Jeff Geerling's Kubernetes 101 Episode 7](https://www.youtube.com/watch?v=Q7G6DBaIJ1c&ab_channel=JeffGeerling)

## Articles on on containers and a cheat-sheet

- https://www.capitalone.com/tech/cloud/what-is-a-container/
- https://www.capitalone.com/tech/cloud/container-runtime/
- https://wizardzines.com/zines/containers/

## Tips

    kubectl get nodes -o wide # shows IP address for node w/ IP address
    kubectl get pods -A       # shows all pods with their port info

## Demo of actual implementation of awx-operator

The demo file awx-operator.cast can be viewed using the python3 module 
[asciinema](https://github.com/asciinema/asciinema.git). To install it,
do the following:

    git clone https://github.com/asciinema/asciinema.git
    cd asciinema
    python3 -m asciinema --version
    python3 -m asciinema asciinema play ../awx-operator.cast

## Installing helm

    wget https://get.helm.sh/helm-v3.6.3-linux-amd64.tar.gz
    tar -xzf helm-v3.6.3-linux-amd64.tar.gz
    sudo chmod 755 linux-amd64/helm
    sudo chown root linux-amd64/helm
    sudo mv linux-amd64/helm /usr/local/bin/
    helm version

