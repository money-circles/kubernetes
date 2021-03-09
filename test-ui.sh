#! /usr/bin/env bash

set -e

RELEASE_NAME="enterprise"
IMAGE="lgazelle/enterprise:v1.0.2"
kubectl create namespace ${RELEASE_NAME} --output yaml --dry-run=client | kubectl apply -f -
kubectl patch serviceaccount default --namespace ${RELEASE_NAME} -p "{\"imagePullSecrets\": [{\"name\": \"acr-credentials\"}]}"

helm upgrade --install --atomic --reset-values\
    ${RELEASE_NAME} \
    money-circles/ui-service \
    --namespace=${RELEASE_NAME} \
    --set lgazelleEnvironment=production \
    --set image=${IMAGE} \
    --set httpPort=80 \
    --set domain=lgazelle.com \
    --set appKey=base64:XDJyFBel5W3Tl/H0t7vsa4bcOe+WhcD0pyLy1E1gIgM=
    