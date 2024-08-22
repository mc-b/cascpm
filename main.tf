###
#   Kubernetes Umgebung
#

module "controlplane" {

  source = "./aws"

  module      = "cascpm-${var.host_no}-${terraform.workspace}"
  description = "CAS Cloud and Platform Manager Mit Cloud-Expertise die Digitalisierung mitgestalten"
  userdata    = "cloud-init-cascpm.yaml"

  cores   = 4
  memory  = 8
  storage = 32
  # SSH, Kubernetes, NFS
  ports = [22, 8080, 30080, 31883, 16443, 25000]

  # MAAS Server Access Info
  url = var.url
  key = var.key
  vpn = var.vpn
}

module "worker-01" {
  source = "./aws"

  module      = "cascpm-${var.host_no+1}-${terraform.workspace}"
  description = "Kubernetes Worker"
  userdata    = "cloud-init-cascpm-worker.yaml"

  cores   = 4
  memory  = 8
  storage = 32
  ports   = [22, 8080, 30080, 16443, 25000]

  url = var.url
  key = var.key
  vpn = var.vpn
}

module "worker-02" {
  source = "./aws"

  module      = "cascpm-${var.host_no+2}-${terraform.workspace}"
  description = "Kubernetes Worker"
  userdata    = "cloud-init-cascpm-worker.yaml"

  cores   = 4
  memory  = 8
  storage = 32
  ports   = [22, 8080, 30080, 16443, 25000]

  url = var.url
  key = var.key
  vpn = var.vpn
}


