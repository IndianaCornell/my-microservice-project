variable "name" {
  description = "Назва Helm-релізу"
  type        = string
  default     = "argo-cd"
}

variable "namespace" {
  description = "K8s namespace для Argo CD"
  type        = string
  default     = "argo-cd"
}

variable "chart_version" {
  description = "Версія Argo CD чарта"
  type        = string
  default     = "5.46.4"
}

variable "eks_cluster_endpoint" {}
variable "eks_cluster_ca_certificate" {}
variable "eks_cluster_token" {}
