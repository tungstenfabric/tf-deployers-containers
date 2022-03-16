#!/bin/bash -e

cd /root

[ -d contrail-ansible-deployer ] || git clone https://github.com/tungstenfabric/tf-ansible-deployer -b master contrail-ansible-deployer
[ -d contrail-kolla-ansible ] || git clone https://github.com/tungstenfabric/tf-kolla-ansible -b master contrail-kolla-ansible

source /etc/os-release
if [[ "$ID" == 'rhel' && "${PLATFORM_ID//*:/}" == 'el8' ]] ; then
    sed -i  '/ansible_connection: local/a \      ansible_python_interpreter: /usr/bin/python3' contrail-ansible-deployer/inventory/hosts
fi
