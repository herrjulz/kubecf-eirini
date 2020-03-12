#!/bin/bash

set -ex

readonly username=$(kubectl get configmap bits -n kubecf -oyaml | grep -E "signing_users:.*" -A 2 - | awk -F: '/username:/{print $2}' | awk '{$1=$1};1')
readonly password=$(kubectl get configmap bits -n kubecf -oyaml | grep -E "signing_users:.*" -A 2 - | awk -F: '/password:/{print $2}' | awk '{$1=$1};1')

kubectl create secret docker-registry registry-secret-name \
    --docker-server="https://registry.${CLUSTER_INGRESS_HOSTNAME}:443" \
    --docker-username="$username" \
    --docker-password="$password" \
    -n eirini --dry-run -o yaml |
    kubectl apply -f -
