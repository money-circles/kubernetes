#! /usr/bin/env bash

set -e

REPO_NAME="lgazelle-nginx"
RELEASE_NAME="nginx-deployment"
IMAGE="lgazelle/nginx@sha256:c0647bfd9bbd8382152c8dd8c9d7d95aa875da94cc7126014ef521d5bd8647f8"
kubectl create namespace ${RELEASE_NAME} --output yaml --dry-run=client | kubectl apply -f -
kubectl patch serviceaccount default --namespace ${RELEASE_NAME} -p "{\"imagePullSecrets\": [{\"name\": \"acr-credentials\"}]}"

helm upgrade --install --reset-values\
    ${RELEASE_NAME} \
    ./charts/lgazelle-microservice \
    --namespace=${RELEASE_NAME} \
    --set lgazelleEnvironment=production \
    --set image=${IMAGE} \
    --set httpPort=80 \
    --set replicas=3 \
    --set domain=lgazelle.com
    

    
