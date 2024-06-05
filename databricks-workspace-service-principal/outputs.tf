output "service_account_client_id" {
  value = databricks_service_principal.nomasec_sa.application_id
}

output "service_account_secret" {
  value     = databricks_service_principal_secret.nomasec_sa_secret.secret
  sensitive = true
}

output "workspace_url" {
  value     = local.workspace_url
}