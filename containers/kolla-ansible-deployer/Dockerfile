ARG CONTRAIL_REGISTRY
ARG CONTRAIL_DEPLOYERS_TAG
FROM ${CONTRAIL_REGISTRY}/contrail-deployers-base:${CONTRAIL_DEPLOYERS_TAG}

ARG CONTAINER_NAME

# If <source> is a directory, the entire contents of the directory are copied, including filesystem metadata.
# Note: The directory itself is not copied, just its contents.
COPY src /root/

RUN \
    source /etc/os-release && \
    if [[ "$ID" == 'rhel' && "${PLATFORM_ID//*:/}" == 'el8' ]] ; then \
        SSHPASS_RPM_NAME=sshpass-1.06-9.el8.x86_64.rpm && \
        wget https://archives.fedoraproject.org/pub/archive/epel/8.4/Everything/x86_64/Packages/s/${SSHPASS_RPM_NAME} && \
        rpm -Uvh --nodeps --replacepkgs ${SSHPASS_RPM_NAME} ; \
    else \
        yum install -y sshpass; \
    fi && \
    yum install -y python2-ipaddress git sudo vim gcc openssl python2-devel python3-devel libffi-devel openssl-devel && \
    python2 -m pip --no-cache-dir install --upgrade "Babel==2.9.1" "MarkupSafe==1.1.1" "PyYAML==5.4" "ansible==2.7.11" "bcrypt==3.1.7" \
    "certifi==2019.11.28" "cffi==1.12.3" "cryptography==2.8" "debtcollector==1.22.0" "enum34==1.1.9" "funcsigs==1.0.2" "idna==2.9" \
    "iso8601==0.1.12" "jinja2==2.11.1" "monotonic==1.5" "netaddr==0.7.19" "netifaces==0.10.9" "oslo_config==7.0.0" "oslo_utils==3.42.1" \
    "oslo.i18n==3.25.1" "paramiko==2.7.1" "pbr==5.4.4" "pycparser==2.19" "pycrypto==2.6.1" "pynacl==1.3.0" "pyparsing==2.4.6" \
    "pytz==2019.3" "requests==2.23.0" "rfc3986==1.3.2" "six==1.14.0" "stevedore==1.32.0" "urllib3==1.25.8" "wrapt==1.12.0"  && \
    python3 -m pip --no-cache-dir install --upgrade "Babel==2.9.1" "MarkupSafe==1.1.1" "PyYAML==5.4" "ansible==2.7.11" "bcrypt==3.1.7" \
    "certifi==2019.11.28" "cffi==1.12.3" "cryptography==2.8" "debtcollector==1.22.0" "enum34==1.1.9" "funcsigs==1.0.2" "idna==2.9" \
    "iso8601==0.1.12" "jinja2==2.11.1" "monotonic==1.5" "netaddr==0.7.19" "netifaces==0.10.9" "oslo_config==7.0.0" "oslo_utils==3.42.1" \
    "oslo.i18n==3.25.1" "paramiko==2.7.1" "pbr==5.4.4" "pycparser==2.19" "pycrypto==2.6.1" "pynacl==1.3.0" "pyparsing==2.4.6" \
    "pytz==2019.3" "requests==2.23.0" "rfc3986==1.3.2" "six==1.14.0" "stevedore==1.32.0" "urllib3==1.25.8" "wrapt==1.12.0"  && \
    /root/prepare.sh && \
    sed -i "s/enabled = .*/enabled = 0/g" /etc/yum.repos.d/contrail.repo && \
    sed -i "s/enabled = .*/enabled = 0/g" /etc/yum.repos.d/tpc-source.repo && \
    yum clean all -y && \
    rm -rf /var/cache/yum

ENTRYPOINT ["/bin/bash"]
