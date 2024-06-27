# README

## Overview

This Terraform module sets up a Databricks service principal with appropriate permissions and secrets. It configures both account-level and workspace-level resources, providing outputs for the service principal client ID, secret, and workspace URL.

## Prerequisites

- Terraform installed on your local machine.
- Databricks account and workspace.
- Databricks account service principal client ID and secret.

## Files

- `main.tf`: Main Terraform configuration file.
- `outputs.tf`: Defines the outputs of the Terraform module.
- `provider.tf`: Configures the Databricks providers.
- `variables.tf`: Defines the variables used in the Terraform configuration.
- `versions.tf`: Specifies the required Terraform providers.

## Usage

1. **Clone the repository**

```sh
git clone <repository-url>
cd <repository-directory>
```

2. **Initialize Terraform**

```sh
terraform init
```

3. **Create a terraform.tfvars file with the following variables:**

```hcl
databricks_account_id      = "<your-databricks-account-id>"
databricks_service_account_name = "<your-service-account-name>"
databricks_client_id       = "<your-databricks-client-id>"
databricks_client_secret   = "<your-databricks-client-secret>"
databricks_workspace_id    = "<your-databricks-workspace-id>"
```

4. **Copy Access Control Resources**
    - In case of provisioning any of the following resource types using Terraform: **Models**, **Connections**, **Serving Endpoints** or **External Locations**
      - Copy the below Access Control resources to any of the above mentioned resource type definitions
      - Make sure to adjust resource names to avoid conflicts

5. **Apply the Terraform configuration**

```sh
terraform apply
```

6. **Check the outputs**
   
After applying the configuration, Terraform will output the service account client ID, secret, and workspace URL.

<br>

## Access Control Resource Definitions
```
# Please note, the following snippet should be applied to any registered model you have running.
# You should copy the example view_all_mlflow_models below to any existing registered model resource definition you have (make sure to adjust it's name to avoid conflicts).

# ========= Registered Models ==============

# resource "databricks_mlflow_model" "my_example_model" {
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
# You should copy the example ml_serving_endpoint_usage below to any existing serving endpoint resource definition you have (make sure to adjust it's name to avoid conflicts).

# ========= Serving Endpoints ==============

# resource "databricks_model_serving" "my_example_serving_endpoint" {
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
# You should copy the example connections_usage below to any existing connection resource definition you have (make sure to adjust it's name to avoid conflicts).

# ============== Connections ===============

# resource "databricks_connection" "my_example_connection" {
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
# You should copy the example external_locations_usage below to any existing external location resource definition you have (make sure to adjust it's name to avoid conflicts).

# ============= External Locations ============

# resource "databricks_external_location" "my_example_external_location" {
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
# You should copy the example registered_model_usage below to any existing registered model resource definition you have (make sure to adjust it's name to avoid conflicts).

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

```