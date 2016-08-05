#!/bin/bash
set +x
set +e

cloud-init init
cloud-init modules --mode init
cloud-init modules --mode config
cloud-init modules --mode final

"$@"
