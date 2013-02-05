#!/bin/bash

# Install ganglia
# TODO: Remove this once the AMI has ganglia by default

GANGLIA_PACKAGES="ganglia ganglia-web ganglia-gmond ganglia-gmetad"

if ! rpm --quiet -q $GANGLIA_PACKAGES; then
  yum install -q -y $GANGLIA_PACKAGES;
fi
for node in $SLAVES $OTHER_MASTERS; do
  ssh -t -t $SSH_OPTS root@$node "if ! rpm --quiet -q $GANGLIA_PACKAGES; then yum install -q -y $GANGLIA_PACKAGES; fi" & sleep 0.3
done
wait