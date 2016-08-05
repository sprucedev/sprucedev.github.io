FROM centos:7

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/puppetlabs/bin:/opt/puppetlabs/puppet/bin/

RUN rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm

RUN yum install -y \
      @core \
      cloud-init dnf \
      git puppet mcollective facter
RUN yum clean all

RUN /opt/puppetlabs/puppet/bin/gem install --verbose --no-ri --no-rdoc r10k:2.3.0 hiera-eyaml:2.1.0

RUN mkdir -p /etc/puppetlabs/facter/facts.d

### HIERA EYAML PUB KEY ###
RUN mkdir -p /etc/puppetlabs/puppet/secure/keys
COPY keys/public_key.pkcs7.pem /etc/puppetlabs/puppet/secure/keys/public_key.pkcs7.pem

### SSH PUB KEY FOR INFRA CHECKOUT ###
RUN mkdir -p /root/.ssh
RUN chmod 700 /root/.ssh
COPY keys/id_rsa.pub /root/.ssh/id_rsa.pub

### MANAGE KNOWN HOSTS ###
RUN echo 'github.com,192.30.253.113 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==' > /root/.ssh/known_hosts

### PUPPET CONFIGS ###
RUN mkdir -p /etc/puppetlabs/r10k
COPY conf/r10k.yaml /etc/puppetlabs/r10k/r10k.yaml
COPY conf/hiera.yaml /etc/puppetlabs/puppet/hiera.yaml

### INFRA SETUP ###
COPY script/spruce-infra-setup.sh /usr/local/bin/spruce-infra-setup.sh
RUN chmod +x /usr/local/bin/spruce-infra-setup.sh

### INFRA CLEANUP ###
COPY script/spruce-infra-cleanup.sh /usr/local/bin/spruce-infra-cleanup.sh
RUN chmod +x /usr/local/bin/spruce-infra-cleanup.sh

### REMOVE CLOUD INIT SEED ###
RUN rm -rf /var/lib/cloud/instance/*
RUN rm -rf /var/lib/cloud/seed/nocloud-net/{user,meta}-data

### DOCKER SPECIFICS ###
RUN mkdir -p /var/lib/cloud/seed/nocloud-net/
COPY cloud-init.yaml /var/lib/cloud/seed/nocloud-net/user-data
RUN echo '{"instance-id": "d-1", hostname: "d-1"}' > /var/lib/cloud/seed/nocloud-net/meta-data

COPY script/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
