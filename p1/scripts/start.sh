#!/bin/sh

ssh-keygen -N ""  -f $PWD/confs/id_rsa

vagrant up

vagrant ssh mravilyS -c "kubectl get nodes -o wide"