resource "kubernetes_namespace_v1" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

# -----------------------
# PROMETHEUS (minimal)
# -----------------------
resource "helm_release" "prometheus" {
  name       = "prometheus"
  namespace  = kubernetes_namespace_v1.monitoring.metadata[0].name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = "25.8.0"

  timeout = 600

  values = [<<EOF
alertmanager:
  enabled: false

kube-state-metrics:
  enabled: false

prometheus-node-exporter:
  enabled: false

pushgateway:
  enabled: false

server:
  persistentVolume:
    enabled: false
  resources:
    requests:
      memory: 256Mi
      cpu: 100m
    limits:
      memory: 512Mi
      cpu: 300m
EOF
  ]
}

# -----------------------
# GRAFANA (minimal)
# -----------------------
resource "helm_release" "grafana" {
  name       = "grafana"
  namespace  = kubernetes_namespace_v1.monitoring.metadata[0].name
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "7.3.7"

  timeout = 600

  values = [<<EOF
adminPassword: admin123

persistence:
  enabled: false

resources:
  requests:
    memory: 40Mi
    cpu: 30m
  limits:
    memory: 80Mi
    cpu: 50m
EOF
  ]
}
