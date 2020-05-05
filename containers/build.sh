#!/bin/bash
# Builds containers. Takes CONTRAIL_REGISTRY, CONTRAIL_DEPLOYERS_TAG, LINUX_DISTR, LINUX_DISTR_VER from environment.
# Parameters:
# path: relative path (from this directory) to module(s) for selective build. Example: ./build.sh kolla-ansible-deployer
#   if it's omitted then script will build all
#   "all" as argument means build all. It's needed if you want to build all and pass some docker opts (see below).
#   "list" will list all relative paths for build in right order. It's needed for automation. Example: ./build.sh list | grep -v "^INFO:"
# opts: extra parameters to pass to docker. If you want to pass docker opts you have to specify 'all' as first param (see 'path' argument above)

my_file="$(readlink -e "$0")"
my_dir="$(dirname $my_file)"
source "$my_dir/../parse-env.sh"

path="$1"
shift
opts="$@"

echo "INFO: Target platform: $LINUX_DISTR:$LINUX_DISTR_VER"
echo "INFO: Contrail registry: $CONTRAIL_REGISTRY"
echo "INFO: Contrail registry push (0=no,1=yes): $CONTRAIL_REGISTRY_PUSH"
echo "INFO: Base container for deployers: $DEPLOYERS_BASE_CONTAINER"
echo "INFO: Contrail deployers tag: $CONTRAIL_DEPLOYERS_TAG"
echo "INFO: Keep log files: $CONTRAIL_KEEP_LOG_FILES"

if [ -n "$opts" ]; then
  echo "INFO: Options: $opts"
fi

docker_ver=$(sudo docker -v | awk -F' ' '{print $3}' | sed 's/,//g')
echo "INFO: Docker version: $docker_ver"

was_errors=0
op='build'

function append_log_file() {
  local logfile=$1
  local always_echo=${2:-'false'}
  local line=''
  while read line ; do
    if [[ "${CONTRAIL_KEEP_LOG_FILES,,}" != 'true' || "$always_echo" != 'false' ]] ; then
      echo "$line" | tee -a $logfile
    else
      echo "$line" >> $logfile
    fi
  done
}

function process_container() {
  local dir=${1%/}
  local docker_file=$2
  if [[ $op == 'list' ]]; then
    echo "${dir#"./"}"
    return
  fi
  local container_name=`echo ${dir#"./"} | tr "/" "-"`
  local container_name="contrail-${container_name}"
  local logfile="build-${container_name}.log"
  echo "INFO: Building $container_name" | append_log_file $logfile true

  tag="${CONTRAIL_DEPLOYERS_TAG}"
  local build_arg_opts=''
  if [[ "$docker_ver" < '17.06' ]] ; then
    # old docker can't use ARG-s before FROM:
    # comment all ARG-s before FROM
    cat ${docker_file} | awk '{if(ncmt!=1 && $1=="ARG"){print("#"$0)}else{print($0)}; if($1=="FROM"){ncmt=1}}' > ${docker_file}.nofromargs
    # and then change FROM-s that uses ARG-s
    sed -i \
      -e "s|^FROM \${DEPLOYERS_BASE_CONTAINER}|FROM ${DEPLOYERS_BASE_CONTAINER}|" \
      -e "s|^FROM \${CONTRAIL_REGISTRY}/\([^:]*\):\${CONTRAIL_DEPLOYERS_TAG}|FROM ${CONTRAIL_REGISTRY}/\1:${tag}|" \
      -e "s|^FROM \$LINUX_DISTR:\$LINUX_DISTR_VER|FROM $LINUX_DISTR:$LINUX_DISTR_VER|" \
      ${docker_file}.nofromargs
    docker_file="${docker_file}.nofromargs"
  fi
  build_arg_opts+=" --build-arg CONTRAIL_REGISTRY=${CONTRAIL_REGISTRY}"
  build_arg_opts+=" --build-arg CONTRAIL_DEPLOYERS_TAG=${tag}"
  build_arg_opts+=" --build-arg DEPLOYERS_BASE_CONTAINER=${DEPLOYERS_BASE_CONTAINER}"
  build_arg_opts+=" --build-arg LINUX_DISTR_VER=${LINUX_DISTR_VER}"
  build_arg_opts+=" --build-arg LINUX_DISTR=${LINUX_DISTR}"
  build_arg_opts+=" --build-arg CONTAINER_NAME=${container_name}"

  sudo docker build --network host -t ${CONTRAIL_REGISTRY}'/'${container_name}:${tag} \
    ${build_arg_opts} -f $docker_file ${opts} $dir 2>&1 | append_log_file $logfile
  was_errors=${PIPESTATUS[0]}
  if [ $was_errors -eq 0 -a $CONTRAIL_REGISTRY_PUSH -eq 1 ] ; then
    sudo docker push ${CONTRAIL_REGISTRY}'/'${container_name}:${tag} 2>&1 | append_log_file $logfile
    was_errors=${PIPESTATUS[0]}
  fi
  if [ $was_errors -eq 0 ]; then
    if [[ "${CONTRAIL_KEEP_LOG_FILES,,}" != 'true' ]] ; then
      rm -f $logfile
    fi
    echo "INFO: Building $container_name finished successfully" | append_log_file $logfile true
  else
    echo "ERROR: Building $container_name failed" | append_log_file $logfile true
  fi
}

function process_dir() {
  local dir=${1%/}
  local docker_file="$dir/Dockerfile"
  if [[ -f "$docker_file" ]] ; then
    process_container "$dir" "$docker_file"
    return
  fi
  for d in $(ls -d $dir/*/ 2>/dev/null); do
    if [[ $d != "./" && $d == */deployers-base* ]]; then
      process_dir $d
    fi
  done
  for d in $(ls -d $dir/*/ 2>/dev/null); do
    if [[ $d != "./" && $d == */base* ]]; then
      process_dir $d
    fi
  done
  for d in $(ls -d $dir/*/ 2>/dev/null); do
    if [[ $d != "./" && $d != *base* ]]; then
      process_dir $d
    fi
  done
}

if [[ $path == 'list' ]] ; then
  op='list'
  path="."
fi

if [ -z $path ] || [ $path = 'all' ]; then
  path="."
fi

echo "INFO: starting build from $my_dir with relative path $path"
pushd $my_dir &>/dev/null

process_dir $path

popd &>/dev/null

if [ $was_errors -ne 0 ]; then
  logs=$(ls -l $my_dir/*.log)
  echo -e "ERROR: Failed to build some containers, see log files:\n$logs" >&2
  exit 1
fi
