###
#   Kubernetes Umgebung
#

module "master" {

  #source     = "./terraform-lerncloud-module"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-multipass"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-maas"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-lernmaas"  
  source     = "git::https://github.com/mc-b/terraform-lerncloud-aws"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-azure" 
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-proxmox"    

  module      = "cascpm-${var.host_no}-${terraform.workspace}"
  description = "CAS Cloud and Platform Manager Mit Cloud-Expertise die Digitalisierung mitgestalten"
  userdata    = "cloud-init-cascpm.yaml"

  cores   = 4
  memory  = 8
  storage = 32
  # SSH, Kubernetes, NFS
  ports      = [ 22, 80, 16443, 25000 ]

  # MAAS Server Access Info
  url = var.url
  key = var.key
  vpn = var.vpn
}



