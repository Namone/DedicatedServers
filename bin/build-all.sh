#!/bin/sh

echo "Refreshing AWS access token..."
aws ecr get-login-password \
        --region us-west-2 | docker login \
        --username AWS \
        --password-stdin \262580537006.dkr.ecr.us-west-2.amazonaws.com/zomboid-server

echo "Building, tagging, and pushing image for all supported games..."

GAME="zomboid"
docker build -t $GAME --target $GAME-server . 
docker image tag $GAME 262580537006.dkr.ecr.us-west-2.amazonaws.com/$GAME-server:11
docker image push 262580537006.dkr.ecr.us-west-2.amazonaws.com/$GAME-server:11

GAME="valheim"
docker build -t $GAME --target $GAME-server . 
docker image tag $GAME 262580537006.dkr.ecr.us-west-2.amazonaws.com/$GAME-server:14
docker image push 262580537006.dkr.ecr.us-west-2.amazonaws.com/$GAME-server:14

echo "Build finished!"