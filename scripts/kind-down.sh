#!/usr/bin/env bash
set -euo pipefail
NAME="${NAME:-k8sdiy}"
OUT="${1:-cluster-state.yaml}"
echo "[kind-snapshot] exporting cluster resources to $OUT"
kubectl --context "kind-$NAME" get all -A -o yaml > "$OUT"
echo "[kind-snapshot] done (gitignored)"
