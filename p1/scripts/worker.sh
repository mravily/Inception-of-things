#!/bin/sh

sudo cp -f .ssh/* /root/.ssh/

scp -o StrictHostKeyChecking=no root@192.168.56.110:/var/lib/rancher/k3s/server/node-token /tmp/node-token

export INSTALL_K3S_EXEC="agent --server https://$1:6443 --token-file /tmp/node-token --node-ip=$2"

curl -sfL https://get.k3s.io | sh -
