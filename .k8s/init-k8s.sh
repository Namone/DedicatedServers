#!/bin/bash
kubectl apply -f pv-efs.yaml && kubectl apply -f pv-efs-claims.yaml
