#!/bin/bash

set -x

main(){
   helm-del-eirini
   helm-del-bits
   helm-del-kubecf
   helm-del-cf-operator
}

helm-del-eirini(){
  helm delete --purge eirini-native 
}

helm-del-bits(){
  helm delete --purge bits
}

helm-del-kubecf(){
  helm delete --purge kubecf
  kubectl delete namespace kubecf
}

helm-del-cf-operator(){
  helm delete --purge cf-operator
  kubectl get customresourcedefinitions,validatingwebhookconfigurations,mutatingwebhookconfigurations --output name | xargs kubectl delete
  kubectl delete namespace cf-operator 
}

main
