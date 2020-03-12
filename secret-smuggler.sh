#!/bin/bash

set -ex

kubectl get secret --namespace kubecf kubecf.var-cc-bridge-cc-uploader --export -o yaml | kubectl apply -n eirini -f -
kubectl get secret --namespace kubecf kubecf.var-eirini-tls-client-cert --export -o yaml | kubectl apply -n eirini -f -

