#!/bin/sh

# Add a .ssh dir not present in the box
sudo mkdir /root/.ssh
chmod 700 /root/.ssh

# Copy the ssh keys for acces without password
sudo cp -f .ssh/* /root/.ssh/

# Get the node-token from the server for install k3s worker
scp -o StrictHostKeyChecking=no root@192.168.56.110:/var/lib/rancher/k3s/server/node-token /tmp/node-token

# Add env var for setup the install of k3s
export INSTALL_K3S_EXEC="agent --server https://$1:6443 --token-file /tmp/node-token --node-ip=$2"

# DL and Install k3s
curl -sfL https://get.k3s.io | sh -
