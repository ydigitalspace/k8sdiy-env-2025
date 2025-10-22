#!/usr/bin/env bash
set -euo pipefail
NAME="${NAME:-k8sdiy}"
echo "[kind-down] deleting cluster: $NAME"
kind delete cluster --name "$NAME" || true

