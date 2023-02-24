#!/bin/sh

# Add a .ssh dir not present in the box
sudo mkdir /root/.ssh
chmod 700 /root/.ssh

cat .ssh/id_rsa.pub >> .ssh/authorized_keys

# Copy the ssh keys for acces without password
sudo cp -f .ssh/* /root/.ssh/

# Get the node-token from the server for install k3s worker
scp -o StrictHostKeyChecking=no root@$1:/var/lib/rancher/k3s/server/node-token /tmp/node-token

# Add env var for setup the install of k3s
export INSTALL_K3S_EXEC="agent --server https://$1:6443 --token-file /tmp/node-token --node-ip=$2"

# DL and Install k3s
curl -sfL https://get.k3s.io | sh -
