#!/usr/bin/env bash
set -euo pipefail

NAME="${NAME:-k8sdiy}"
IMAGE="${IMAGE:-kindest/node:v1.30.4}"

echo "[kind-up] creating cluster: $NAME ($IMAGE)"
if kind get clusters | grep -qx "$NAME"; then
  echo "[kind-up] cluster '$NAME' already exists, skipping create"
else
  kind create cluster --name "$NAME" --image "$IMAGE"
fi

echo "[kind-up] exporting kubeconfig (local file, gitignored)"
kind export kubeconfig --name "$NAME" > kubeconfig.yaml

echo "[kind-up] waiting for core components..."
kubectl --context "kind-$NAME" wait --for=condition=Ready nodes --all --timeout=90s
kubectl --context "kind-$NAME" -n kube-system wait --for=condition=Available deploy/coredns --timeout=120s || true

echo "[kind-up] cluster-info:"
kubectl --context "kind-$NAME" cluster-info
kubectl --context "kind-$NAME" get nodes -o wide
