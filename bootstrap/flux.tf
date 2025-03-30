# ==========================================
# Bootstrap Flux Operator
# ==========================================
resource "helm_release" "flux_operator" {
  depends_on = [kind_cluster.this]

  count = var.flux_enable ? 1 : 0

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
  depends_on = [helm_release.flux_operator]
  count = var.flux_enable ? 1 : 0

  name       = "flux-instance"
  namespace  = "flux-system"
  repository = "oci://ghcr.io/controlplaneio-fluxcd/charts"
  chart      = "flux-instance"
  set {
    name  = "distribution.version"
    value = "=2.5.x"
  }
}