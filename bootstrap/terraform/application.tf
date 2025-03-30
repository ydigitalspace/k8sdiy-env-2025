# ==========================================
# Bootstrap Kbot Application
# ==========================================
resource "helm_release" "kbot_app" {
  depends_on = [helm_release.envoy_gateway]
  name       = "kbot"
  namespace  = "default"
  repository = "oci://ghcr.io/den-vasyliev/charts"
  chart      = "helm"
  version    = "2.1.0"
  set {
    name  = "gateway.hostname"
    value = "quietly-just-ferret.ngrok-free.app"
  }
  set {
    name  = "gateway.path"
    value = "/prod"
  }

}