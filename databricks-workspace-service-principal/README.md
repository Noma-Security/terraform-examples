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

4. **Apply the Terraform configuration**

```sh
terraform apply
```

5. **Check the outputs**
   
After applying the configuration, Terraform will output the service account client ID, secret, and workspace URL.

