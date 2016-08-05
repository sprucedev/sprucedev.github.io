#!/bin/bash
set -x
set -e
/opt/puppetlabs/puppet/bin/r10k deploy environment -p master
puppet_ec=0
/opt/puppetlabs/puppet/bin/puppet apply --test --execute 'include "role::${role}"' || puppet_ec=$?
if [[ $puppet_ec -eq 0 ]] || [[ $puppet_ec -eq 2 ]]; then
  echo "Puppet succeeded"
else
  exit $puppet_ec
fi
