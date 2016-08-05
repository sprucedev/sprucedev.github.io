#!/bin/bash
set -x
ec=0
rm -rf /etc/puppetlabs/puppet/secure || ec=1
rm -rf /var/lib/cloud || ec=1
rm -f /root/.ssh/id_rsa* || ec=1
exit $ec
