#!/bin/bash -e

cd /root

[ -d contrail-ansible-deployer ] || git clone https://github.com/tungstenfabric/tf-ansible-deployer -b master contrail-ansible-deployer
[ -d contrail-kolla-ansible ] || git clone https://github.com/Juniper/contrail-kolla-ansible -b master contrail-kolla-ansible
