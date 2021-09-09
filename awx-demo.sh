#!/bin/bash
## awx-demo.sh -- setup and demo a kubernetes cluster running awx
## done in minimum 4 core 16GB centos8 laptop
##--------------------------------------------------------------------------------

kubectl config set-context --current --namespace=ansible-uat
kubectl config view
kubectl cluster-info

## added nfs persistant volume in Rancher
## file is in scbtrm-awx.yaml

## install and deploy the awx-operator CRD (Custom Resource Definition) from git repo
## from https://raw.githubusercontent.com/ansible/awx-operator/0.13.0/deploy/awx-operator.yaml
kubectl apply -f awx-operator.yaml

kubectl describe deployment
kubectl get pods -w

## now deploy a simple nodeport instance of AWX
# kubectl apply -f awx-demo.yml
# watch kubectl get pods -l "app.kubernetes.io/managed-by=awx-operator"
# kubectl get secret awx-demo-admin-password -o jsonpath="{.data.password}" | base64 --decode

## use nginx for ingress controller
kubectl apply -f awx-nginx-ingress.yml

## if you watch the log with
# kubectl logs -f deployments/awx-operator
## ansible will report a failure on line 20 of this file:
## https://github.com/ansible/awx-operator/blob/devel/roles/installer/tasks/resources_configuration.yml
## and the awx-nginx pod fails to deploy. The awx-nginx-postgres pod is fine.

kubectl get pods -l "app.kubernetes.io/managed-by=awx-operator" -w
kubectl get secret awx-demo-admin-password -o jsonpath="{.data.password}" | base64 --decode
kubectl get nodes -o wide
kubectl get ing # or ingress

## monitor metrics required for HPA (Horizontal Pod Autoscaler)
#helm repo add bitnami https://charts.bitnami.com/bitnami
#helm install -f values/metrics-server.yml metrics-server bitnami/metrics-server
#kubectl top nodes

## https://httpd.apache.org/docs/2.4/programs/ab.html
## apache bench is installed on MacOS by default but needs httpd-tools for centos
#yum install -y httpd-tools

## external DNS provider to tie k8s cluster to external DNS provider
## https://github.com/kubernetes-sigs/external-dns
## cert-manager uses Let's Encrypt which can't authenticate in many ISP's NAT environments
#kubectl create namespace cert-manager
#kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.5.3/cert-manager.crds.yaml
#helm repo add jetstack https://charts.jetstack.io
#helm install cert-manager jetstack/cert-manager -n cert-manager --version v1.5.3

## cron jobs
## https://www.jeffgeerling.com/blog/2018/running-drupal-cron-jobs-kubernetes
## https://www.youtube.com/watch?v=O1iEBzY7-ok

## logging
## injest into ELK? external provider with robust architecture

## remove all stuff from minikube cluster
kubectl delete -f awx-nginx.yml
make undeploy
