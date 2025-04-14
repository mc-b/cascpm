
module "vms" {
  source = "git::https://github.com/mc-b/terraform-lerncloud-aws.git?ref=v2.0.0"
  #source = "git::https://github.com/mc-b/terraform-lerncloud-maas.git?ref=v2.0.0"
  #source = "git::https://github.com/mc-b/terraform-lerncloud-lernmaas.git?ref=v2.0.0"
  
  machines = {
    "controlplane-01" = {
      hostname    = "controlplane-${terraform.workspace}"
      description = "Kubernetes Control Plane Node"
      userdata    = templatefile("${path.root}/cloud-init-controlplane.yaml", {})
    },
    "worker-01" = {
      hostname = "worker1-${terraform.workspace}"
      userdata = templatefile("${path.root}/cloud-init-worker.yaml", {})
    },
    "worker-02" = {
      hostname = "worker2-${terraform.workspace}"
      userdata = templatefile("${path.root}/cloud-init-worker.yaml", {})
    }
  }

  description = "Kubernetes Nodes"
  memory      = 8
  cores       = 4
  storage     = 40

  ports = [22, 80, 443, 16443]

  url = var.url
  key = var.key
  vpn = var.vpn
}

