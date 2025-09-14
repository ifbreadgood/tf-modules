resource "talos_machine_secrets" "this" {}

locals {
  config_patches = [
    file("patch/no-cni-proxy.yaml"),
    file("patch/local-mount.yaml"),
    file("patch/unrestricted-namespace.yaml"),
    file("patch/name-server.yaml"),
    file("patch/authentication.yaml"),
    file("patch/single-node.yaml")
  ]
  cluster_endpoint = "https://${var.controller_endpoint}:6443"
}

data "talos_machine_configuration" "controller" {
  cluster_name     = var.cluster_name
  machine_type     = "controlplane"
  cluster_endpoint = local.cluster_endpoint
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  talos_version    = var.talos_version
  config_patches   = local.config_patches
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
}

resource "talos_machine_configuration_apply" "controller" {
  for_each                    = var.controller_ips
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controller.machine_configuration
  node                        = each.value
  timeouts = {
    create = "10s"
    update = "10s"
  }
}

data "talos_machine_configuration" "worker" {
  count                    = length(var.worker_ips) == 0 ? 0 : 1
  cluster_name     = var.cluster_name
  machine_type     = "worker"
  cluster_endpoint = local.cluster_endpoint
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  talos_version    = var.talos_version
  config_patches   = local.config_patches
}

resource "talos_machine_configuration_apply" "worker" {
  for_each                    = var.worker_ips
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.0.machine_configuration
  node                        = each.value
}

resource "talos_machine_bootstrap" "this" {
  depends_on           = [talos_machine_configuration_apply.controller]
  node                 = var.controller_endpoint
  client_configuration = talos_machine_secrets.this.client_configuration
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on           = [talos_machine_bootstrap.this]
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = var.controller_endpoint
}

resource "local_file" "kube_config" {
  filename             = var.kube_config_destination
  content              = talos_cluster_kubeconfig.this.kubeconfig_raw
  file_permission      = "0600"
  directory_permission = "0700"
}