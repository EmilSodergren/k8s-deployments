#!/bin/bash -e

curl -sfL https://get.k3s.io | \
  K3S_KUBECONFIG_MODE="644" \
  INSTALL_K3S_SYMLINK="force" \
  INSTALL_K3S_EXEC="--disable servicelb" \
  sh -
kubectl apply -f coredns/coredns-cm.yaml
sudo systemctl start k3s
echo "Edit the configmap:"
echo "    kubectl -n kube-system edit cm coredns -o yaml"
echo "Change line 21, . /etc/resolve.conf to:   import /etc/coredns/custom/*.forward"
echo "    kubectl -n kube-system delete po -l k8s-app=kube-dns"
