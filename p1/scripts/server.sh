#!/bin/sh

export INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --tls-san $(hostname) --node-ip $1  --bind-address=$1 --advertise-address=$1 --cluster-init"

# Install mandatory dependencies for k3s and start the cluster
curl -sfL https://get.k3s.io | sh -

