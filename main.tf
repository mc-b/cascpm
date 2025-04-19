
# K8s Cluster
module "vms" {
  source = local.selected_source

  machines = {
    "controlplane-01" = {
      hostname    = "control"
      description = "Kubernetes Control Plane Node"
      userdata = templatefile("${path.root}/cloud-init-controlplane.yaml", {
        INSTALL_CERT_MANAGER = "no"
        INSTALL_KUBEVIRT     = "no"
        INSTALL_LONGHORN     = "no"
        INSTALL_ISTIO        = "no"
        INSTALL_KNATIVE      = "no"
      })
    },
    "worker-01" = {
      hostname = "worker1"
      userdata = templatefile("${path.root}/cloud-init-worker.yaml", {})
    },
    "worker-02" = {
      hostname = "worker2"
      userdata = templatefile("${path.root}/cloud-init-worker.yaml", {})
    }
  }

  description = "Kubernetes Nodes"
  memory      = 8
  cores       = 4
  storage     = 40

  ports = [22, 80, 443, 16443]

  # MAAS: URL MAAS, Azure: Resource Group, Google: Project-Id
  url = var.url
  # MAAS: API-Key, Azure: Subscription-Id
  key = var.key
  # MAAS: optionales WireGuard VPN
  vpn = var.vpn
}



