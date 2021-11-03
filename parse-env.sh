#!/bin/bash
# Internal script for parsing common.env. Run by other executable scripts

env_dir="${BASH_SOURCE%/*}"
[ -d "$env_dir" ] || env_dir="$PWD"
env_file="$env_dir/common.env"
if [ -f $env_file ]; then
  source $env_file
  export ENV_FILE="$env_file"
fi

# build platform info
export LINUX_ID=$(awk -F"=" '/^ID=/{print $2}' /etc/os-release | tr -d '"')
if [[ "$linux_id" == 'centos' ]] ; then
  # ver id is taken from available versions from docker.io
  linux_ver_id=`cat /etc/redhat-release | awk '{print($4)}'`
else
  # for ubuntu ver id matchs 14.04, 16.04
  # for rhel ver id matchs 7.9, 8.4
  linux_ver_id=$(awk -F"=" '/^VERSION_ID=/{print $2}' /etc/os-release | tr -d '"')
fi
export LINUX_VER_ID=$linux_ver_id

export LINUX_DISTR=${LINUX_DISTR:-centos}
export LINUX_DISTR_VER=${LINUX_DISTR_VER:-'7.5.1804'}

default_interface=`ip route show | grep "default via" | awk '{print $5}'`
host_ip=`ip address show dev $default_interface | head -3 | tail -1 | tr "/" " " | awk '{print $2}'`
export CONTRAIL_REGISTRY=${CONTRAIL_REGISTRY:-"$host_ip:5000"}
export CONTRAIL_REGISTRY_PUSH=${CONTRAIL_REGISTRY_PUSH:-'1'}
export CONTRAIL_DEPLOYERS_TAG=${CONTRAIL_DEPLOYERS_TAG:-${CONTRAIL_VERSION:-'5.0'}}
export DEPLOYERS_BASE_CONTAINER=${DEPLOYERS_BASE_CONTAINER:-"$LINUX_DISTR:$LINUX_DISTR_VER"}
export CONTRAIL_KEEP_LOG_FILES=${CONTRAIL_KEEP_LOG_FILES:-'false'}
