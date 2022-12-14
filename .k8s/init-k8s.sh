#!/bin/bash
kubectl apply -f templates/pv.yaml && kubectl apply -f templates/pv-claims.yaml
