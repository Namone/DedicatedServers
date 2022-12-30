#!/bin/sh

GAME=$1
echo "Refreshing AWS access token..."
aws ecr get-login-password \
        --region us-west-2 | docker login \
        --username AWS \
        --password-stdin \262580537006.dkr.ecr.us-west-2.amazonaws.com/$GAME-server

echo "Building, tagging, and pushing image for $GAME..."
docker build -t $GAME --target $GAME-server . 
docker image tag $GAME 262580537006.dkr.ecr.us-west-2.amazonaws.com/$GAME-server:16
docker image push 262580537006.dkr.ecr.us-west-2.amazonaws.com/$GAME-server:16
echo "Build finished for $GAME!"