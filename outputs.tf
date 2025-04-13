
output "ips" {
  value = module.vms.ip_vm
}

output "fqdn_names" {
  value = module.vms.fqdn_vm
}

output "fqdn_private" {
  description = "Interne DNS-Namen der AWS-VMs"
  value       = module.vms.fqdn_private
}

# Lokale Hilfsvariablen für Zugriff auf die einzelnen Maschinen aus der map
locals {
  controlplane_ip   = module.vms.ip_vm["controlplane-01"]
  controlplane_fqdn = module.vms.fqdn_vm["controlplane-01"]
  worker_01_ip      = module.vms.ip_vm["worker-01"]
  worker_01_fqdn    = module.vms.fqdn_vm["worker-01"]
  worker_02_ip      = module.vms.ip_vm["worker-02"]
  worker_02_fqdn    = module.vms.fqdn_vm["worker-02"]
}

# Generiere README aus INTRO.md Template
output "README" {
  value = templatefile("INTRO.md", {
    ip             = local.controlplane_ip,
    fqdn           = local.controlplane_fqdn,
    worker_01_ip   = local.worker_01_ip,
    worker_01_fqdn = local.worker_01_fqdn,
    worker_02_ip   = local.worker_02_ip,
    worker_02_fqdn = local.worker_02_fqdn,
  })
}