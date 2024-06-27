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

data "databricks_jobs" "this" {}

resource "databricks_permissions" "view_all_jobs" {
  for_each = data.databricks_jobs.this.ids
  job_id   = each.value

  access_control {
    service_principal_name = databricks_service_principal.nomasec_sa.application_id
    permission_level       = "CAN_VIEW"
  }
}

# ========= Clusters ==========

data "databricks_clusters" "this" {}

resource "databricks_permissions" "view_all_clusters" {
  for_each = toset(data.databricks_clusters.this.ids)
  cluster_id = each.value

  access_control {
    service_principal_name = databricks_service_principal.nomasec_sa.application_id
    permission_level       = "CAN_ATTACH_TO"
  }
}

# ========= Pipelines ==========

data "databricks_pipelines" "this" {}

resource "databricks_permissions" "view_all_pipelines" {
  for_each = toset(data.databricks_pipelines.this.ids)
  pipeline_id = each.value

  access_control {
    service_principal_name = databricks_service_principal.nomasec_sa.application_id
    permission_level       = "CAN_VIEW"
  }
}


# Please note, the following snippet should be applied to any registered model you have running.
# You should add view_all_mlflow_models to any existing registered model resource definition you have.

# ========= Registered Models ==============

# resource "databricks_mlflow_model" "this" {
#   name = "My MLflow Model"
#
#   description = "My MLflow model description"
#
#   tags {
#     key   = "key1"
#     value = "value1"
#   }
#   tags {
#     key   = "key2"
#     value = "value2"
#   }
# }
#
# resource "databricks_permissions" "view_all_mlflow_models" {
#   registered_model_id = databricks_mlflow_model.this.registered_model_id
#
#   access_control {
#     service_principal_name = databricks_service_principal.nomasec_sa.application_id
#     permission_level       = "CAN_READ"
#   }
# }

# Please note, the following snippet should be applied to any serving endpoint you have running.
# You should add ml_serving_endpoint_usage to any existing serving endpoint resource definition you have.

# ========= Serving Endpoints ==============

# resource "databricks_model_serving" "this" {
#   name = "ads-serving-endpoint-3"
#   config {
#     served_entities {
#       name                  = "prod_model"
#       entity_name           = "test2"
#       entity_version        = "1"
#       workload_size         = "Small"
#       scale_to_zero_enabled = true
#     }
#   }
# }
#
# resource "databricks_permissions" "ml_serving_endpoint_usage" {
#   serving_endpoint_id = databricks_model_serving.this.serving_endpoint_id
#
#   access_control {
#     service_principal_name = databricks_service_principal.nomasec_sa.application_id
#     permission_level = "CAN_VIEW"
#   }
# }

# Please note, the following snippet should be applied to any connection you have running.
# You should add connections_usage to any existing connection resource definition you have.

# ============== Connections ===============

# resource "databricks_connection" "mysql" {
#   name            = "mysql_connection"
#   connection_type = "MYSQL"
#   comment         = "this is a connection to mysql db"
#   options = {
#     host     = "test.mysql.database.azure.com"
#     port     = "3306"
#     user     = "user"
#     password = "password"
#   }
#   properties = {
#     purpose = "testing"
#   }
# }
#
# resource "databricks_grants" "connections_usage" {
#   foreign_connection = databricks_connection.mysql.name
#   grant {
#     principal  = databricks_service_principal.nomasec_sa.application_id
#     privileges = ["USE_CONNECTION"]
#   }
# }

# Please note, the following snippet should be applied to any external location you have running.
# You should add external_locations_usage to any existing external location resource definition you have.

# ============= External Locations ============

# resource "databricks_external_location" "some" {
#   name            = "external"
#   url             = "s3://${aws_s3_bucket.external.id}/some"
#   credential_name = databricks_storage_credential.external.id
#   comment         = "Managed by TF"
# }
#
# resource "databricks_grants" "external_locations_usage" {
#   external_location = databricks_external_location.some.id
#   grant {
#     principal  = databricks_service_principal.nomasec_sa.application_id
#     privileges = ["READ_FILES"]
#   }
# }

# Please note, the following snippet should be applied to any unity catalog registered model you have running.
# You should add registered_model_usage to any existing registered model resource definition you have.

# ====== Unity Catalog - Registered Model =======

# resource "databricks_registered_model" "this" {
#   name         = "my_model"
#   catalog_name = "main"
#   schema_name  = "default"
# }
#
# resource "databricks_grants" "registered_model_usage" {
#   model = databricks_registered_model.full_name
#   grant {
#     principal  = databricks_service_principal.nomasec_sa.application_id
#     privileges = ["APPLY_TAG", "EXECUTE"]
#   }
# }
