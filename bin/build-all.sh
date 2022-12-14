#!/bin/sh

echo "Refreshing AWS access token..."
aws ecr get-login-password \
        --region us-west-2 | docker login \
        --username AWS \
        --password-stdin \262580537006.dkr.ecr.us-west-2.amazonaws.com/dedicated-servers

echo "Building, tagging, and pushing image for all supported games..."
# @TODO: make better.
GAME="barotrauma"
docker build -t $GAME --target $GAME-server . 
docker image tag $GAME 262580537006.dkr.ecr.us-west-2.amazonaws.com/dedicated-servers:$GAME
docker image push 262580537006.dkr.ecr.us-west-2.amazonaws.com/dedicated-servers:$GAME

GAME="zomboid"
docker build -t $GAME --target $GAME-server . 
docker image tag $GAME 262580537006.dkr.ecr.us-west-2.amazonaws.com/dedicated-servers:$GAME
docker image push 262580537006.dkr.ecr.us-west-2.amazonaws.com/dedicated-servers:$GAME

GAME="valheim"
docker build -t $GAME --target $GAME-server . 
docker image tag $GAME 262580537006.dkr.ecr.us-west-2.amazonaws.com/dedicated-servers:$GAME
docker image push 262580537006.dkr.ecr.us-west-2.amazonaws.com/dedicated-servers:$GAME


echo "Build finished!"