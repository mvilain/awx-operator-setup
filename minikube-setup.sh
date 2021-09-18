#!/bin/bash
## minikube-setup.sh -- setup and demo a kubernetes cluster running awx
## done in minimum 4 core 16GB centos8 laptop

yum install -y git make yum-utils epel-release
yum install -y ansible
#yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
#yum install -y docker-ce docker-ce-cli containerd.io
#systemctl start docker
#systemctl enable docker
#curl -L https://github.com/docker/compose/releases/download/1.29.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
#chmod 755 /usr/local/bin/docker-compose

sudo yum module -y install virt
sudo yum install -y virt-install virt-viewer conntrack

sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
sudo chmod 755 kubectl
sudo mv kubectl /usr/local/bin/
[ -d ~/.kube/config ] && rmdir ~/.kube/config
kubectl version -o yaml

sudo curl -L https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
      -o /usr/local/bin/minikube
chmod 755 /usr/local/bin/minikube
minikube version

##--------------------------------------------------------------------------------
##
## a lot of this came from this episode of Jeff Geerling's Kubernetes 101 course, episode 7
## and the README.md page from https://github.com/ansible/awx-operator.git
##
## start a local minikube cluster and point minikube to it (other contexts might use docker's minikube)
## this works on rocky8 linux but not on MacOS with minikube or using the driver=docker
## 9/17/21 minikube 1.23.1 works while 1.23 had an rbac error
##
# minikube start --addons=ingress --install-addons=true --kubernetes-version=stable --memory=12g

minikube delete --all --purge
minikube config set driver virtualbox
minikube start --addons=ingress --install-addons=true --kubernetes-version=stable --memory=12g --cpus=6

minikube addons enable dashboard metric-server
# https://acloud.guru/forums/kubernetes-fundamental/discussion/-M3IUId85EifmxB9uV3l/minikube%20dashboard%20enable%20fails%20on%20MacOS%20Catalina
kubectl delete clusterrolebinding kubernetes-dashboard
minikube status
minikube addons list

## point kubectl to minikube's cluster
eval $(minikube -p minikube docker-env)

kubectl config view
kubectl cluster-info
