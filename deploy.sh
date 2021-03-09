#! /usr/bin/env bash

if [ "$GITHUB_REF_SLUG" = "master" ]; then
    RELEASE_NAME=$REPOSITORY_NAME
else
    RELEASE_NAME="$REPOSITORY_NAME-$GITHUB_REF_SLUG"
fi

# Authenticate Azure
az login --service-principal --username $INPUT_CLIENT_ID --password $INPUT_CLIENT_SECRET --tenant $INPUT_TENANT_ID
az aks get-credentials -n $INPUT_CLUSTER_NAME -g tf-cluster

# Set Kubernetes context
kubectl config current-context

# Create Kubernetes namespace
kubectl create namespace $REPOSITORY_NAME --output yaml --dry-run=client | kubectl apply -f -

# Patch Container registiry secret to pull private images
kubectl patch serviceaccount default --namespace $REPOSITORY_NAME -p "{\"imagePullSecrets\": [{\"name\": \"acr-credentials\"}]}"

# Deploy
helm upgrade --install --wait --atomic --reset-values \
    ${RELEASE_NAME} \
    /app/helm/$INPUT_HELM_CHART \
    --namespace=$REPOSITORY_NAME \
    --set image=$INPUT_IMAGE \
    --set httpPort=$INPUT_HTTP_PORT \
    --set host=$INPUT_HOST \
    --set replicas=$INPUT_REPLICAS \
    --set environment=$INPUT_ENVIRONMENT


