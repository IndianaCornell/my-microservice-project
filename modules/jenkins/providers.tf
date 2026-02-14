provider "kubernetes" {
  host                   = var.eks_cluster_endpoint
  token                  = var.eks_cluster_token
  cluster_ca_certificate = base64decode(var.eks_cluster_ca_certificate)
}


provider "helm" {
  kubernetes = {
    host                   = var.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(var.eks_cluster_ca_certificate)
    token                  = var.eks_cluster_token
  }
}

