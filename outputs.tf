###
#   Outputs wie IP-Adresse und DNS Name
#  

output "ip_vm" {
  value       = module.controlplane.ip_vm
  description = "The IP address of the server instance."
}

output "fqdn_vm" {
  value       = module.controlplane.fqdn_vm
  description = "The FQDN of the server instance."
}

output "description" {
  value       = module.controlplane.description
  description = "Description VM"
}

# Einfuehrungsseite(n)

locals {
  worker_01_ip   = module.worker-01.ip_vm
  worker_01_fqdn = module.worker-01.fqdn_vm
  worker_02_ip   = module.worker-02.ip_vm
  worker_02_fqdn = module.worker-02.fqdn_vm
}

output "README" {
  value = templatefile("INTRO.md", {
    ip             = module.controlplane.ip_vm,
    fqdn           = module.controlplane.fqdn_vm,
    worker_01_ip   = local.worker_01_ip,
    worker_01_fqdn = local.worker_01_fqdn,
    worker_02_ip   = local.worker_02_ip,
    worker_02_fqdn = local.worker_02_fqdn,
  })
}

