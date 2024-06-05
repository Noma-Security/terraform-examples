locals {
  workspace_url = "https://${var.databricks_workspace_id}.cloud.databricks.com"
}

# ========= Account level =========

resource "databricks_service_principal" "nomasec_sa" {
  provider     = databricks.accounts
  display_name = var.databricks_service_account_name
  workspace_access = true
}

resource "databricks_service_principal_secret" "nomasec_sa_secret" {
  provider             = databricks.accounts
  service_principal_id = databricks_service_principal.nomasec_sa.id
}

# ========= Workspace level =========

resource "databricks_permission_assignment" "add_user" {
  provider     = databricks.workspace

  principal_id = databricks_service_principal.nomasec_sa.id
  permissions  = ["USER"]
}


resource "databricks_permissions" "root_permission" {
  provider = databricks.workspace
  # workspace_file_path = "/"
  directory_path = "/"
  # workspace_file_id = data.databricks_directory.root.object_id
  
  # directory_path = "/"
  access_control {
    
    # service_principal_name = databricks_service_principal.nomasec_sa.display_name
    service_principal_name = databricks_service_principal.nomasec_sa.application_id
    # user_name = var.databricks_service_account_name
    permission_level = "CAN_READ"
  }
  
  depends_on = [ databricks_permission_assignment.add_user ]
}