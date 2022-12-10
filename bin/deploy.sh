#!/bin/bash

GAME=$1

CONTEXT="arn:aws:eks:us-west-2:262580537006:cluster/DedicatedServers"
NAMESPACE=$1

echo "Running Helm..."

helm upgrade -f ./values.yaml dedicated-server-deployment \
      --set env.SELECTED_GAME=$1 \
      --install \
      --cleanup-on-fail \
      . \
      --namespace $NAMESPACE \
      --kube-context=$CONTEXT