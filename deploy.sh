#!/bin/bash
set -euo pipefail

export KUBE_NAMESPACE=${ENVIRONMENT}
export KUBE_SERVER=${KUBE_SERVER}
export KUBE_TOKEN=${KUBE_TOKEN}
export VERSION=${VERSION}

if [[ ${KUBE_NAMESPACE} == *prod ]]
then
    export MIN_REPLICAS="2"
    export MAX_REPLICAS="6"
    export CLUSTER_NAME="acp-prod"
else
    export MIN_REPLICAS="1"
    export MAX_REPLICAS="3"
    export CLUSTER_NAME="acp-notprod"
fi

export KUBE_CERTIFICATE_AUTHORITY="https://raw.githubusercontent.com/UKHomeOffice/acp-ca/master/${CLUSTER_NAME}.crt"

cd kd || exit 1

kd --timeout 15m \
    -f deployment.yaml \
    -f autoscale.yaml
