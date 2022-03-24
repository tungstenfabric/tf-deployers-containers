ARG DEPLOYERS_BASE_CONTAINER
FROM ${DEPLOYERS_BASE_CONTAINER}

RUN \
    yum update -y -x "redhat-release*" && \
    curl https://bootstrap.pypa.io/pip/3.6/get-pip.py | python3 - 'pip==20.1' && \
    curl https://bootstrap.pypa.io/pip/2.7/get-pip.py | python2 - 'pip==20.1' && \
    yum clean all -y && \
    rm -rf /var/cache/yum

ENV PS1="\033[1m($(printenv CONTAINER_NAME))\033[m\017[$(id -un)@$(hostname -s) $(pwd)]$ "

CMD ["/usr/bin/tail","-f","/dev/null"]
