output "client_configuration" {
  value     = talos_machine_secrets.this.client_configuration
  sensitive = true
}

output "kube_config" {
  value     = talos_cluster_kubeconfig.this.kubernetes_client_configuration
  sensitive = true
}