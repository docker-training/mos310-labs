#!/bin/bash

kubectl -n openstack get sts etcd-etcd -o jsonpath='{.spec.template.spec.containers[0].env[?(@.name=="ETCD_INITIAL_CLUSTER_STATE")].value}'

