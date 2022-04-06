#!/bin/bash

node=$1
claims=$(kubectl -n openstack get pv -o jsonpath="{.items[?(@.spec.nodeAffinity.required.nodeSelectorTerms[0].matchExpressions[0].values[0] == '${node}')].spec.claimRef.name}")
for i in $claims; do echo $i; done
