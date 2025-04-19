
# Lokale Hilfsvariablen für Zugriff auf die einzelnen Maschinen aus der map
locals {
  controlplane_ip      = terraform.workspace != "lernmaas" ? try(module.vms.ip_vm["controlplane-01"], null) : null
  controlplane_fqdn    = terraform.workspace != "lernmaas" ? try(module.vms.fqdn_vm["controlplane-01"], null) : null
  controlplane_private = terraform.workspace != "lernmaas" ? try(module.vms.fqdn_private["controlplane-01"], null) : null
  worker_01_ip         = terraform.workspace != "lernmaas" ? try(module.vms.ip_vm["worker-01"], null) : null
  worker_01_fqdn       = terraform.workspace != "lernmaas" ? try(module.vms.fqdn_vm["worker-01"], null) : null
  worker_01_private    = terraform.workspace != "lernmaas" ? try(module.vms.fqdn_private["worker-01"], null) : null
  worker_02_ip         = terraform.workspace != "lernmaas" ? try(module.vms.ip_vm["worker-02"], null) : null
  worker_02_fqdn       = terraform.workspace != "lernmaas" ? try(module.vms.fqdn_vm["worker-02"], null) : null
  worker_02_private    = terraform.workspace != "lernmaas" ? try(module.vms.fqdn_private["worker-02"], null) : null
}

# Generiere README aus INTRO.md Template
output "README" {
  value = terraform.workspace != "lernmaas" ? templatefile("INTRO.md", {
    ip           = local.controlplane_ip,
    fqdn         = local.controlplane_fqdn,
    fqdn_private = local.controlplane_private,

    worker_01_ip      = local.worker_01_ip,
    worker_01_fqdn    = local.worker_01_fqdn,
    worker_01_private = local.worker_01_private,

    worker_02_ip      = local.worker_02_ip,
    worker_02_fqdn    = local.worker_02_fqdn,
    worker_02_private = local.worker_02_private,
  }) : null
}


