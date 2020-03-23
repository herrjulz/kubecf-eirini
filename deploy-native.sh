#!/bin/bash

set -ex

main(){
   # install-operator
   # sleep 15
   install-kubecf $1
}

install-operator(){
  helm3 install --namespace cf-operator \
    cf-operator \
    --set "global.operator.watchNamespace=kubecf" \
   https://s3.amazonaws.com/cf-operators/release/helm-charts/cf-operator-3.3.0%2B0.gf32b521e.tgz
}

install-kubecf(){
  local cluster_secret bits_tls_key bits_tls_crt blobstore_password
  cluster_secret=$(kubectl -n default get secrets | grep $(kubectl config current-context | cut -d / -f 1) | awk '{print $1}')
  bits_tls_key="$(kubectl get secret "$cluster_secret" --namespace default -o jsonpath="{.data['tls\.key']}" | base64 --decode -)"
  bits_tls_crt="$(kubectl get secret "$cluster_secret" --namespace default -o jsonpath="{.data['tls\.crt']}" | base64 --decode -)"

  helm3 install kubecf ./helm \
   --namespace kubecf \
   --values $1 \
   --set "bits.secrets.BITS_TLS_KEY=${bits_tls_key}" \
   --set "bits.secrets.BITS_TLS_CRT=${bits_tls_crt}"
}

main $1
