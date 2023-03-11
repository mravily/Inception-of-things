#!/bin/sh

ssh-keygen -N ""  -f ./confs/id_rsa

vagrant up

vagrant ssh mravilyS -c "kubectl get all -o wide"