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
# ==========================================
# Bootstrap Flux Instance
# ==========================================
resource "helm_release" "flux_instance" {
  count      = 1
  depends_on = [helm_release.flux_operator]

  name       = "flux"
  namespace  = "flux-system"
  repository = "oci://ghcr.io/controlplaneio-fluxcd/charts"
  chart      = "flux-instance"
  set {
    name  = "distribution.version"
    value = "=2.5.x"
  }
}