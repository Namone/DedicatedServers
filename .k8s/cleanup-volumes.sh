#!/bin/bash
kubectl patch pv ebs-vol -p '{"metadata":{"finalizers":null}}' 
kubectl delete pv ebs-vol
kubectl patch volumeattachments.storage.k8s.io csi-3a87f9f3dc9347533ebaf8175babd2d88bc953f39ab890a9316b88de47f5a83d -p '{"metadata":{"finalizers":[]}}' --type=merge
kubectl delete volumeattachments.storage.k8s.io csi-3a87f9f3dc9347533ebaf8175babd2d88bc953f39ab890a9316b88de47f5a83d

kubectl delete pvc -n servers ebs-claim