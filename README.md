# Pi deployments
This repo contains the deployments on my pi.

## Install K3S
 `curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=latest INSTALL_K3S_SYMLINK=force INSTALL_K3S_SKIP_START=true
K3S_KUBECONFIG_MODE=644 INSTALL_K3S_EXEC="--disable coredns --disable traefik" sh -`

`cp coredns-custom.yaml /var/lib/rancher/k3s/server/manifests/`

`sudo systemctl start k3s`

`kubectl apply -f coredns/`

`kubectl -n kube-system kill po coredns-<TAB>`
