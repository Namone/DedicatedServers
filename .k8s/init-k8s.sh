#!/bin/bash
kubectl apply -f pv.yaml && kubectl apply -f pv-claims.yaml
