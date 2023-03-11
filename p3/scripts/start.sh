#!/bin/sh

ssh-keygen -N ""  -f $PWD/confs/id_rsa

vagrant up