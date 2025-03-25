# ==========================================
# Construct KinD cluster
# ==========================================
resource "kind_cluster" "this" {
  name           = "preview-${random_string.suffix.result}"
  wait_for_ready = true
  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"
    node {
      role = "control-plane"
    }
    node {
      role = "worker"
    }
    node {
      role = "worker"
    }
    networking {
      kube_proxy_mode = "ipvs"
    }
  }
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# ==========================================
# Bootstrap Flux Operator
# ==========================================
resource "helm_release" "flux_operator" {
  count      = 1
  depends_on = [kind_cluster.this]

  name             = "flux-operator"
  namespace        = "flux-system"
  repository       = "oci://ghcr.io/controlplaneio-fluxcd/charts"
  chart            = "flux-operator"
  create_namespace = true
}

