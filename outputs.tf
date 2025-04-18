
# Lokale Hilfsvariablen für Zugriff auf die einzelnen Maschinen aus der map
locals {
  controlplane_ip      = module.vms.ip_vm["controlplane-01"]
  controlplane_fqdn    = module.vms.fqdn_vm["controlplane-01"]
  controlplane_private = module.vms.fqdn_private["controlplane-01"]
  worker_01_ip         = module.vms.ip_vm["worker-01"]
  worker_01_fqdn       = module.vms.fqdn_vm["worker-01"]
  worker_01_private    = module.vms.fqdn_private["worker-01"]
  worker_02_ip         = module.vms.ip_vm["worker-02"]
  worker_02_fqdn       = module.vms.fqdn_vm["worker-02"]
  worker_02_private    = module.vms.fqdn_private["worker-02"]
}

# Generiere README aus INTRO.md Template
output "README" {
  value = templatefile("INTRO.md", {
    ip           = local.controlplane_ip,
    fqdn         = local.controlplane_fqdn,
    fqdn_private = local.controlplane_private,

    worker_01_ip      = local.worker_01_ip,
    worker_01_fqdn    = local.worker_01_fqdn,
    worker_01_private = local.worker_01_private,

    worker_02_ip      = local.worker_02_ip,
    worker_02_fqdn    = local.worker_02_fqdn,
    worker_02_private = local.worker_02_private,

  })
}

# Join Cluster Script
resource "local_file" "join_script" {
  content = templatefile("${path.module}/join.sh.tmpl", {
    controlplane = local.controlplane_private
    worker1      = local.worker_01_private
    worker2      = local.worker_02_private
  })

  filename        = "${path.module}/join.sh"
  file_permission = "0755"
}