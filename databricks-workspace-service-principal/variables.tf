variable "databricks_account_id" {
  description = "Databricks account ID"
  type        = string
}

variable "databricks_service_account_name" {
  description = "The name of the service account to create"
  type        = string
  default = "nomasec-sa"
}

variable "databricks_client_id" {
  description = "The Databricks account service principal client ID (For the Terraform Provider)"
  type        = string
}

variable "databricks_client_secret" {
  description = "The Databricks account service principal client secret (For the Terraform Provider)"
  type        = string
  sensitive   = true
}

variable "databricks_workspace_id" {
  description = "The Databricks workspace ID"
  type        = string
}