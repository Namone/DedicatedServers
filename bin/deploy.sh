#!/bin/bash

CONTEXT="arn:aws:eks:us-west-2:961406424767:cluster/cloud2_dev"
NAMESPACE="barotrauma"

# Inject secrets for Larry deployment.
SECRET=$(aws secretsmanager get-secret-value --secret-id dev/Larry/App)
APP_KEY=$(echo $SECRET | jq --raw-output '.SecretString' | jq -r .APP_KEY)

echo "Running Helm..."

helm3 upgrade -f ./values.yaml larry-deployment \
      --set env.APP_KEY=$APP_KEY \
      --set env.AUTH0_API_IDENTIFIER=$AUTH0_API_IDENTIFIER \
      --set env.AUTH0_CLIENT_ID=$AUTH0_CLIENT_ID \
      --set env.AUTH0_CLIENT_SECRET=$AUTH0_CLIENT_SECRET \
      --set env.AUTH0_DOMAIN=$AUTH0_DOMAIN \
      --set env.AUTH0_MANAGEMENT_SECRET=$AUTH0_MANAGEMENT_SECRET \
      --set env.AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
      --set env.AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
      --set env.BLUETENT_AUTHORIZER_API_KEY=$BLUETENT_AUTHORIZER_API_KEY \
      --set env.BLUETENT_AUTHORIZER_URL=$BLUETENT_AUTHORIZER_URL \
      --set env.CLOUDFRONT_DISTRIBUTION_ID=$CLOUDFRONT_DISTRIBUTION_ID \
      --set env.REDIS_HOSTNAME=$REDIS_HOSTNAME \
      --set env.REDIS_HOST=$REDIS_HOSTNAME \
      --set env.REDIS_PASSWORD=$REDIS_PASSWORD \
      --set env.DB_PASSWORD=$DB_PASSWORD \
      --install \
      --cleanup-on-fail \
      . \
      --namespace $NAMESPACE \
      --kube-context=$CONTEXT