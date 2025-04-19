
resource "local_file" "join_script" {
  count = terraform.workspace != "lernmaas" ? 1 : 0

  content = terraform.workspace != "lernmaas" ? templatefile("${path.module}/join.sh.tmpl", {
    controlplane = local.controlplane_private
    worker1      = local.worker_01_private
    worker2      = local.worker_02_private
  }) : ""

  filename        = "${path.module}/join.sh"
  file_permission = "0755"
}

# Join Cluster

locals {
  is_lernmaas = terraform.workspace == "lernmaas"
}

resource "null_resource" "join_cluster" {
  count = local.is_lernmaas ? 0 : 1

  depends_on = [local_file.join_script]

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]

    command = <<EOT
%{if !local.is_lernmaas}
  echo "[+] Warte auf SSH-Verfügbarkeit auf der Controlplane..."
  sleep 60
  for i in {1..120}; do
    ssh -o BatchMode=yes -o ConnectTimeout=5 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/lerncloud ubuntu@${local.controlplane_fqdn} "echo 'SSH OK'" && break || echo "SSH noch nicht verfügbar, versuche erneut..." && sleep 10
  done
  echo "[+] SSH Verbindung steht, kopiere join.sh..."
  scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/lerncloud join.sh ubuntu@${local.controlplane_fqdn}:join.sh
%{else}
  echo "Skip join_cluster because workspace is lernmaas"
%{endif}
EOT
  }
}

