#!/bin/bash -e

curl -sfL https://get.k3s.io | \
  INSTALL_K3S_SYMLINK="force" \
  INSTALL_K3S_EXEC="--disable servicelb,traefik --kube-proxy-arg proxy-mode=ipvs --kube-proxy-arg ipvs-strict-arp" \
  sh -
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/k3s.yaml
kubectl apply -f coredns/coredns-cm.yaml
kubectl -n kube-system get cm coredns -o yaml | sed 's#forward . /etc/resolv.conf#import /etc/coredns/custom/*.forward#' | kubectl replace -f -
kubectl -n kube-system delete po -l k8s-app=kube-dns
