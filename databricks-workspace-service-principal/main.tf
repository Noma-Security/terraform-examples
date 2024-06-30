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
  directory_path = "/"
  
  access_control {
    service_principal_name = databricks_service_principal.nomasec_sa.application_id
    permission_level = "CAN_READ"
  }
  
  depends_on = [ databricks_permission_assignment.add_user ]
}

# ========= Jobs ==========
#
# data "databricks_jobs" "this" {}
#
# resource "databricks_permissions" "view_all_jobs" {
#   for_each = data.databricks_jobs.this.ids
#   job_id   = each.value
#
#   access_control {
#     service_principal_name = databricks_service_principal.nomasec_sa.application_id
#     permission_level       = "CAN_VIEW"
#   }
# }
#
# ========= Clusters ==========
#
# data "databricks_clusters" "this" {}
#
# resource "databricks_permissions" "view_all_clusters" {
#   for_each = toset(data.databricks_clusters.this.ids)
#   cluster_id = each.value
#
#   access_control {
#     service_principal_name = databricks_service_principal.nomasec_sa.application_id
#     permission_level       = "CAN_ATTACH_TO"
#   }
# }
#
# ========= Pipelines ==========
#
# data "databricks_pipelines" "this" {}
#
# resource "databricks_permissions" "view_all_pipelines" {
#   for_each = toset(data.databricks_pipelines.this.ids)
#   pipeline_id = each.value
#
#   access_control {
#     service_principal_name = databricks_service_principal.nomasec_sa.application_id
#     permission_level       = "CAN_VIEW"
#   }
# }
