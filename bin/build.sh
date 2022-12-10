#!/bin/sh

echo "Refreshing AWS access token..."
aws ecr get-login-password \
        --region us-west-2 | docker login \
        --username AWS \
        --password-stdin \262580537006.dkr.ecr.us-west-2.amazonaws.com/dedicated-servers

echo "Building, tagging, and pushing image..."
docker build -t barotrauma:latest --target barotrauma-server .
docker image tag barotrauma:latest 262580537006.dkr.ecr.us-west-2.amazonaws.com/dedicated-servers:barotrauma
docker image push 262580537006.dkr.ecr.us-west-2.amazonaws.com/dedicated-servers:barotrauma

echo "Build finished!"