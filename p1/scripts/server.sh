#!/bin/sh

# Add a .ssh dir not present in the box
sudo mkdir /root/.ssh
chmod 700 /root/.ssh

cat .ssh/id_rsa.pub >> .ssh/authorized_keys

# Add env var for setup the install of k3s
export INSTALL_K3S_EXEC="--write-kubeconfig-mode=777 --tls-san $(hostname) --node-ip $1  --bind-address=$1 --advertise-address=$1 --cluster-init"

# Copy the ssh keys on root for authorize the scp connection from worker
sudo cp -f .ssh/* /root/.ssh/

# Install mandatory dependencies for k3s and start the cluster
curl -sfL https://get.k3s.io | sh -

