#!/bin/bash

NODE_NAME=$1

kubectl drain --delete-local-data --ignore-daemonsets $NODE_NAME && kubectl uncordon $NODE_NAME