# Create consul namespace
resource "kubernetes_namespace" "consul" {
  metadata {
    name = "consul"
  }
}

# Create Consul deployment
resource "helm_release" "consul" {
  name       = "consul"
  repository = "https://helm.releases.hashicorp.com"
  version    = var.consul_chart_version
  chart      = "consul"
  namespace  = "consul"

  values = [
    templatefile("${path.module}/helm/consul-v1.yaml", {})
  ]

  depends_on = [module.eks.eks_managed_node_groups,
                kubernetes_namespace.consul,
                module.vpc
                ]
}