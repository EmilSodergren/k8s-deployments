#!/bin/bash

curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" INSTALL_K3S_SYMLINK="force" \
  INSTALL_K3S_SKIP_ENABLE="true" sh - -- --disable servicelb
kubectl apply _f coredns/coredns-cm.yaml
sudo systemctl start k3s
