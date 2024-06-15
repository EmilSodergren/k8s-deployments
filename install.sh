#!/bin/bash -e

if [ "$1" == "master" ]; then
  curl -sfL https://get.k3s.io | \
    INSTALL_K3S_SYMLINK="force" \
    INSTALL_K3S_EXEC="--disable servicelb,traefik --kube-proxy-arg proxy-mode=ipvs --kube-proxy-arg ipvs-strict-arp --write-kubeconfig-mode=644" \
    sh -
  sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/k3s.yaml
  kubectl apply -f coredns/coredns-cm.yaml
  sleep 3
  kubectl -n kube-system get cm coredns -o yaml | sed 's#forward . /etc/resolv.conf#import /etc/coredns/custom/*.forward#' | kubectl replace -f -
  sleep 3
  kubectl -n kube-system delete po -l k8s-app=kube-dns
  sleep 3
  TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)
  echo TOKEN = "$TOKEN"

elif [ "$1" == "agent" ]; then
  if [ -z "$2" ]; then
    echo "ERROR: Need token as argument 2 to connect the agent"
    exit 1
  fi
  curl -sfL https://get.k3s.io | K3S_URL=https://pi.home:6443 K3S_TOKEN="$2" sh -

else
  echo ERROR: Arguments needs to be \'master\' or \'agent "TOKEN"\'
fi
