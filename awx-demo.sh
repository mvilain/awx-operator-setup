#!/bin/bash
# awx-demo.sh -- setup and demo a kubernetes cluster running awx
# done in minimum 4 core 16GB centos8 laptop


yum install -y git make yum-utils epel-release
yum install -y ansible
# yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
# yum install -y docker-ce docker-ce-cli containerd.io
# systemctl start docker
# systemctl enable docker
# curl -L https://github.com/docker/compose/releases/download/1.29.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
# chmod 755 /usr/local/bin/docker-compose

sudo yum module -y install virt
sudo yum install -y virt-install virt-viewer conntrack

# [logout]
# [login]

sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
sudo chmod 755 kubectl
sudo mv kubectl /usr/local/bin/
[ -d ~/.kube/config ] && rmdir ~/.kube/config
kubectl version -o yaml

sudo curl -L https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
      -o /usr/local/bin/minikube
chmod 755 /usr/local/bin/minikube
minikube version

wget https://get.helm.sh/helm-v3.6.3-linux-amd64.tar.gz
tar -xzf helm-v3.6.3-linux-amd64.tar.gz
sudo chmod 755 linux-amd64/helm
sudo chown root linux-amd64/helm
sudo mv linux-amd64/helm /usr/local/bin/
helm version

minikube start --addons=ingress --cpus=4 --cni=flannel --install-addons=true \
    --kubernetes-version=stable --memory=12g
minikube status
minikube addons list

eval $(minikube -p minikube docker-env) # point kubectl to minikube's cluster
kubectl config view
kubectl cluster-info

kubectl get nodes -o wide
kubectl get pods -A

kubectl apply -f https://raw.githubusercontent.com/ansible/awx-operator/0.13.0/deploy/awx-operator.yaml
kubeclt describe deployment
watch kubectl get pods

kubectl create namespace awx
# kubectl config set-context --current --namespace awx
# kubectl config set-context --current --namespace ""

kubectl apply -f awx-demo.yml
watch kubectl get pods -n awx
# kubectl logs -f deployments/awx-operator

kubectl get secret awx-demo-admin-password -o jsonpath="{.data.password}" -n awx| base64 --decode

# use nginx for ingress controller
kubectl apply -f awx-nginx.yml
watch kubectl get pods -n awx -l "app.kubernetes.io/managed-by=awx-operator" # -w
kubectl get ing -n aws #ingress

# monitor metrics required for HPA (Horizontal Pod Autoscaler)
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install -f values/metrics-server.yml metrics-server bitnami/metrics-server
kubectl top nodes -n aws

# https://httpd.apache.org/docs/2.4/programs/ab.html
# apache bench is installed on MacOS by default but needs httpd-tools for centos
yum install -y httpd-tools

# external DNS provider to tie k8s cluster to external DNS provider
# https://github.com/kubernetes-sigs/external-dns
# cert-manager uses Let's Encrypt which can't authenticate in many ISP's NAT environments
kubectl create namespace cert-manager
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.1.0/cert-manager.crds.yaml
helm repo add jetstack https://charts.jetstack.io
helm install cert-manager jetstack/cert-manager -n cert-manager --version v1.1.0

# remove all stuff from minikube cluster
kubectl delete namespace awx # daemonsets,replicasets,services,deployments,pods,rc --all
kubectl get pods --no-headers=true --all-namespaces \
   | sed -r 's/(\S+)\s+(\S+).*/kubectl --namespace \1 delete pod \2/e'
