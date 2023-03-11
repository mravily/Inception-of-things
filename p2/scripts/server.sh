#!/bin/sh

cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys

# Add env var for setup the install of k3s
export INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --tls-san $(hostname) --node-ip $1  --bind-address=$1 --advertise-address=$1"

# Copy the ssh keys on root for authorize the scp connection from worker
sudo cp -f .ssh/* /root/.ssh/

# Install mandatory dependencies for k3s and start the cluster
curl -sfL https://get.k3s.io | sh -

cp -R /vagrant/confs/. /var/lib/rancher/k3s/server/manifests/
       
sleep 10

kubectl wait deploy/app-one --for condition=available --timeout=120s
kubectl wait deploy/app-two --for condition=available --timeout=120s
kubectl wait deploy/app-three --for condition=available --timeout=120s