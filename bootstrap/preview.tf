# ==========================================
# Bootstrap Kbot Application
# ==========================================
# Bootstrap Preview Environment
# ==========================================
resource "helm_release" "bootstrap_chart" {
  count      = 1
  depends_on = [helm_release.envoy_gateway]

  name             = "bootstrap-chart"
  namespace        = "flux-system"
  repository       = "oci://ghcr.io/den-vasyliev/charts/infra"
  chart            = "bootstrap-chart"
  version          = ">0.1.0"
}
