#!/bin/bash

CONTEXT="arn:aws:eks:us-west-2:262580537006:cluster/DedicatedServers"
NAMESPACE="servers"

echo "Running Helm..."

helm upgrade -f ./values.yaml dedicated-server-deployment \
      --install \
      --cleanup-on-fail \
      . \
      --namespace $NAMESPACE \
      --kube-context=$CONTEXT