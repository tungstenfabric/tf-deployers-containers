ARG CONTRAIL_REGISTRY
ARG CONTRAIL_DEPLOYERS_TAG
FROM ${CONTRAIL_REGISTRY}/contrail-deployers-base:${CONTRAIL_DEPLOYERS_TAG}

ARG CONTAINER_NAME

# If <source> is a directory, the entire contents of the directory are copied, including filesystem metadata.
# Note: The directory itself is not copied, just its contents.
COPY src /root/

RUN yum install -y python-ipaddress git sudo vim gcc sshpass openssl python-devel libffi-devel openssl-devel && \
    pip --no-cache-dir install --upgrade "Babel==2.8.0" "MarkupSafe==1.1.1" "PyYAML==5.3.1" "ansible==2.7.11" "bcrypt==3.1.7" \
    "certifi==2019.11.28" "cffi==1.12.3" "cryptography==2.8" "debtcollector==1.22.0" "enum34==1.1.9" "funcsigs==1.0.2" "idna==2.9" \
    "iso8601==0.1.12" "jinja2==2.11.1" "monotonic==1.5" "netaddr==0.7.19" "netifaces==0.10.9" "oslo_config==7.0.0" "oslo_utils==3.42.1" \
    "oslo.i18n==3.25.1" "paramiko==2.7.1" "pbr==5.4.4" "pycparser==2.19" "pycrypto==2.6.1" "pynacl==1.3.0" "pyparsing==2.4.6" \
    "pytz==2019.3" "requests==2.23.0" "rfc3986==1.3.2" "six==1.14.0" "stevedore==1.32.0" "urllib3==1.25.8" "wrapt==1.12.0"  && \
    /root/prepare.sh && \
    yum clean all -y && \
    rm -rf /var/cache/yum

ENTRYPOINT ["/bin/bash"]
