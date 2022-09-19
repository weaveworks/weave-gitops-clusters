#!/bin/bash
set -e

if [[ -z "$CLUSTER_NAME" ]]; then
    echo "Ensure CLUSTER_NAME has been set"
    exit 1
fi

if [[ -z "$CA_CERTIFICATE_DATA" ]]; then
    echo "Ensure CA_CERTIFICATE_DATA has been set to the path of the CA certificate"
    exit 1
fi

if [[ -z "$ENDPOINT" ]]; then
    echo "Ensure ENDPOINT has been set"
    exit 1
fi

if [[ -z "$TOKEN" ]]; then
    echo "Ensure TOKEN has been set"
    exit 1
fi

CONFIG=$(envsubst <<EOF | base64
apiVersion: v1
kind: Config
clusters:
- name: $CLUSTER_NAME
  cluster:
    server: https://$ENDPOINT
    certificate-authority-data: $CA_CERTIFICATE_DATA
users:
- name: $CLUSTER_NAME
  user:
    token: $TOKEN
contexts:
- name: $CLUSTER_NAME
  context:
    cluster: $CLUSTER_NAME
    user: $CLUSTER_NAME
current-context: $CLUSTER_NAME
EOF
)


envsubst <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: $CLUSTER_NAME-kubeconfig
  namespace: flux-system
data:
  value.yaml: $CONFIG
EOF
