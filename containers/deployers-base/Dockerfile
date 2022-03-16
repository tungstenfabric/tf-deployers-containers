ARG DEPLOYERS_BASE_CONTAINER
FROM ${DEPLOYERS_BASE_CONTAINER}

RUN \
    source /etc/os-release && \
    if [[ "$ID" == 'rhel' && "${PLATFORM_ID//*:/}" == 'el8' ]] ; then \
        curl https://bootstrap.pypa.io/pip/3.6/get-pip.py | python3 - 'pip==20.1' ; \
    else \
        curl https://bootstrap.pypa.io/pip/2.7/get-pip.py | python2 - 'pip==20.1' ; \
    fi && \
    yum update -y -x "redhat-release*" && \
    yum clean all -y && \
    rm -rf /var/cache/yum

ENV PS1="\033[1m($(printenv CONTAINER_NAME))\033[m\017[$(id -un)@$(hostname -s) $(pwd)]$ "

CMD ["/usr/bin/tail","-f","/dev/null"]
