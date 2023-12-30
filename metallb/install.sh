# create namespace
# helm repo add metallb https://metallb.github.io/metallb
helm install -n metallb-system metallb metallb/metallb
sleep 3
k apply -f metallb.yaml
