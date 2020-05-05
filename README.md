# Building containers

All containers or individual container can be built in a same way as main containers in contrail-container-builder repository.

This repository doesn’t have scripts to prepare docker registry so user should specify CONTRAIL_REGISTRY with correct value for ‘docker push’ command. By default IP of default interface (detected by default route) with port 5000 is used.

CONTRAIL_DEPLOYERS_TAG (or CONTRAIL_VERSION if first is absent) is used as a tag for new images. ‘5.0’ is by default for now.

Container folder contains Dockerfile that is used for build process. The Dockerfile contains RUN directive with commands that install all needed packages for deployer’s run. Deployers' sources used for building container are automatically cloned during build process, unless some pre-git-cloned sources are copied into 'src' folder before the build which allows using local copies of deployer's repos.

In all folders Dockerfile must contain COPY directive. It must copy all content from ‘src’ folder to image’s ‘/root’ folder of creating container. The ‘src’ folder must contain ‘prepare.sh’ script that is called by Dockerfile after COPY procedure by RUN directive. This script should check presence of snapshotted repositories and clone them if needed. If the ‘src’ folder contains pre-cloned repositories then ‘prepare.sh’ shouldn’t clone them.

# Using contrail-deployers-containers

'containers' folder contains definitions for various deployers that can be used to deploy Contrail.

Each deployer is packed into container as a snapshot to some point of time/state of original repository. User can run any deployer’s container and use saved state to run deployment:
```docker run -it --network host CONTAINER_IMAGE```
where CONTAINER_IMAGE is a name with tag or image ID. When container is run user can exec deployer's specific commands as described in documentation of the deployer - run ansible, helm or whatever. The process is not different from standard run when deployer's code is cloned locally.
