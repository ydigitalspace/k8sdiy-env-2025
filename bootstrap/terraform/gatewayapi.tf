# ==========================================
# Bootstrap Envoy Gateway
# ==========================================
resource "helm_release" "envoy_gateway" {
  count            = 1
  depends_on       = [kind_cluster.this]
  name             = "eg"
  namespace        = "envoy-gateway-system"
  repository       = "oci://docker.io/envoyproxy"
  chart            = "gateway-helm"
  create_namespace = true
}