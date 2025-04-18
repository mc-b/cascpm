
# Define which provider to use per workspace
locals {
  module_sources = {
    multipass = "git::https://github.com/mc-b/terraform-lerncloud-multipass.git?ref=v2.0.0"
    aws       = "git::https://github.com/mc-b/terraform-lerncloud-aws.git?ref=v2.0.0"
    azure     = "git::https://github.com/mc-b/terraform-lerncloud-azure.git?ref=v2.0.0"
    gcp       = "git::https://github.com/mc-b/terraform-lerncloud-gcp.git?ref=v2.0.0"
    maas      = "git::https://github.com/mc-b/terraform-lerncloud-maas.git?ref=v2.0.0"
    lernmaas  = "git::https://github.com/mc-b/terraform-lerncloud-lernmaas.git?ref=v2.0.0"
    # fallback default
    default = "git::https://github.com/mc-b/terraform-lerncloud-multipass.git?ref=v2.0.0"
  }
}

# Determine source based on workspace
locals {
  selected_source = lookup(local.module_sources, terraform.workspace, local.module_sources["default"])
}

# K8s Cluster
module "vms" {
  source = local.selected_source

  machines = {
    "controlplane-01" = {
      hostname    = "control-${terraform.workspace}"
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

  # MAAS: URL MAAS, Azure: Resource Group, Google: Project-Id
  url = var.url
  # MAAS: API-Key, Azure: Subscription-Id
  key = var.key
  # MAAS: optionales WireGuard VPN
  vpn = var.vpn
}

# Join Cluster
resource "null_resource" "join_cluster" {
  depends_on = [module.vms, local_file.join_script]

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = <<EOT
      echo "[+] Warte auf SSH-Verfügbarkeit auf der Controlplane..."
      for i in {1..10}; do
        ssh -o BatchMode=yes -o ConnectTimeout=5 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/lerncloud ubuntu@${tostring(local.controlplane_fqdn)} "echo 'SSH OK'" && break || echo "SSH noch nicht verfügbar, versuche erneut..." && sleep 5
      done
      echo "[+] SSH Verbindung steht, kopiere join.sh..."
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/lerncloud join.sh ubuntu@${tostring(local.controlplane_fqdn)}:join.sh
    EOT
  }
}


