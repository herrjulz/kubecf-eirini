#!/bin/bash

set -ex

main(){
   install-operator
   sleep 15
   install-kubecf
}

install-operator(){
  helm install --namespace cf-operator \
    --name cf-operator \
    --set "global.operator.watchNamespace=kubecf" \
    https://s3.amazonaws.com/cf-operators/release/helm-charts/cf-operator-v2.0.0-0.g0142d1e9.tgz
}

install-kubecf(){
  local cluster_secret bits_tls_key bits_tls_crt blobstore_password
  cluster_secret=$(kubectl -n default get secrets | grep $(kubectl config current-context | cut -d / -f 1) | awk '{print $1}')
  bits_tls_key="$(kubectl get secret "$cluster_secret" --namespace default -o jsonpath="{.data['tls\.key']}" | base64 --decode -)"
  bits_tls_crt="$(kubectl get secret "$cluster_secret" --namespace default -o jsonpath="{.data['tls\.crt']}" | base64 --decode -)"

  helm install ./helm \
   --name kubecf \
   --namespace kubecf \
   --values ./eirini-native-values.yml \
   --set "bits.secrets.BITS_TLS_KEY=${bits_tls_key}" \
   --set "bits.secrets.BITS_TLS_CRT=${bits_tls_crt}"
}

main
