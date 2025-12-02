#!/bin/bash -e

function install_k3s {
  curl -sfL https://get.k3s.io | \
    INSTALL_K3S_SYMLINK="force" \
    INSTALL_K3S_EXEC="--disable servicelb,traefik --kube-proxy-arg proxy-mode=ipvs --kube-proxy-arg ipvs-strict-arp --write-kubeconfig-mode=644" \
    sh -
  sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/k3s.yaml
}

function setup_dns {
  kubectl apply -f coredns/coredns-cm.yaml
  sleep 3
  kubectl -n kube-system get cm coredns -o yaml | sed 's#forward . /etc/resolv.conf#import /etc/coredns/custom/*.forward#' | kubectl replace -f -
  sleep 3
  kubectl -n kube-system delete po -l k8s-app=kube-dns
  sleep 3
}

function print_token {
  TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)
  echo TOKEN = "$TOKEN"
}

function setup_agent {
  if [ -z "$1" ]; then
    echo "ERROR: Need token as argument 2 to connect the agent"
    exit 1
  fi
  curl -sfL https://get.k3s.io | K3S_URL=https://pi.home:6443 K3S_TOKEN="$1" sh -
}

if [[ "$1" == "master" ]]; then
  install_k3s
  setup_dns
  print_token
elif [[ "$1" == "agent" ]]; then
  setup_agent $2
elif [[ "$1" == "dns_only" ]]; then
  setup_dns
else
  echo ERROR: Arguments needs to be \'master\' or \'agent "TOKEN"\' or \'dns_only\'
fi
