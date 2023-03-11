# P1

The objective of part 1 is to configure two VMs with K3S, one of these VMs will be a K3S server, with all the dependencies to manage the cluster, and a second VM will be used as a K3S agent, normally the agent is used for the application workload, in our case we are not installing any application inside.

## Launch project

```bash
sh scripts/start.sh
```

## Vagrantfile and Scripts

The whole Vagrant file and the VM configuration scripts are commented, you can find more explanations in the Resources section.

## Ressources

[Official Vagrant Docs](https://developer.hashicorp.com/vagrant/docs)

[Official K3S Docs](https://docs.k3s.io/)
