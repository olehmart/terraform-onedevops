# Terraform module: iam-service-account

The purpose of this module to create GCP IAM service account and grant project roles/IAM bindings.

### Variables:
```yaml
project_id: 
    description: GCP project ID
    required: true
config_path: 
    description: path to YAML file which contain resource configuration
    required: true
sleep_after_sa_creation:
    description: timeout in seconds to wait for IAM service account creation
    default: 10s
    required: false
```

### Resource configuration
Configuration for IAM service accounts should be placed in YAML config file and path to this file should be provided
to the module. The example configuration can be found here: [config_example.yaml](config_example.yaml)  
#### Format:
```yaml
name:
    description: name of IAM service account
    required: true
    value type: string; length must be between 6 and 30 characters; must start with a lower case letter, followed by 
    one or more lower case alphanumerical characters that can be separated by hyphens;

project_roles:
    description: list of project roles assigned to IAM service account
    required: true (if no roles should be provided, the value should be: [])
    value type: list
    
iam_roles:
    description: list of roles and members which should be assigned to the roles for IAM service account
    required: true (if no roles should be provided, the value should be: {})
    value type: map ("SELF" can be used to link to the same IAM service account which will be created)
```
Example of config file:
```yaml
---
service_account1:
  name: service-account1
  project_roles:
    - roles/bigquery.jobUser
    - roles/dataproc.worker
  iam_roles:
    roles/iam.serviceAccountTokenCreator:
      - SELF
service_account2:
  name: service-account2
  project_roles:
    - roles/bigquery.jobUser
  iam_roles:
    roles/iam.serviceAccountTokenCreator:
      - SELF
service_account3:
  name: service-account3
  project_roles: []
  iam_roles: {}

```
Example of running TF plan with example config:
```commandline
terraform plan -var=project_id=<PROJECT_ID> -var=config_path=./config_example.yaml

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # google_project_iam_member.project_iam_binding["service-account1:roles_bigquery.jobUser"] will be created
  + resource "google_project_iam_member" "project_iam_binding" {
      + etag    = (known after apply)
      + id      = (known after apply)
      + member  = "serviceAccount:service-account1@<PROJECT_ID>.iam.gserviceaccount.com"
      + project = "<PROJECT_ID>"
      + role    = "roles/bigquery.jobUser"
    }

  # google_project_iam_member.project_iam_binding["service-account1:roles_dataproc.worker"] will be created
  + resource "google_project_iam_member" "project_iam_binding" {
      + etag    = (known after apply)
      + id      = (known after apply)
      + member  = "serviceAccount:service-account1@<PROJECT_ID>.iam.gserviceaccount.com"
      + project = "<PROJECT_ID>"
      + role    = "roles/dataproc.worker"
    }

  # google_project_iam_member.project_iam_binding["service-account2:roles_bigquery.jobUser"] will be created
  + resource "google_project_iam_member" "project_iam_binding" {
      + etag    = (known after apply)
      + id      = (known after apply)
      + member  = "serviceAccount:service-account2@<PROJECT_ID>.iam.gserviceaccount.com"
      + project = "<PROJECT_ID>"
      + role    = "roles/bigquery.jobUser"
    }

  # google_service_account.service_account["service_account1"] will be created
  + resource "google_service_account" "service_account" {
      + account_id   = "service-account1"
      + disabled     = false
      + display_name = "service-account1"
      + email        = (known after apply)
      + id           = (known after apply)
      + name         = (known after apply)
      + project      = (known after apply)
      + unique_id    = (known after apply)
    }

  # google_service_account.service_account["service_account2"] will be created
  + resource "google_service_account" "service_account" {
      + account_id   = "service-account2"
      + disabled     = false
      + display_name = "service-account2"
      + email        = (known after apply)
      + id           = (known after apply)
      + name         = (known after apply)
      + project      = (known after apply)
      + unique_id    = (known after apply)
    }

  # google_service_account.service_account["service_account3"] will be created
  + resource "google_service_account" "service_account" {
      + account_id   = "service-account3"
      + disabled     = false
      + display_name = "service-account3"
      + email        = (known after apply)
      + id           = (known after apply)
      + name         = (known after apply)
      + project      = (known after apply)
      + unique_id    = (known after apply)
    }

  # google_service_account_iam_binding.sa_iam_binding["service-account1:roles_iam.serviceAccountTokenCreator"] will be created
  + resource "google_service_account_iam_binding" "sa_iam_binding" {
      + etag               = (known after apply)
      + id                 = (known after apply)
      + members            = [
          + "serviceAccount:service-account1@<PROJECT_ID>.iam.gserviceaccount.com",
        ]
      + role               = "roles/iam.serviceAccountTokenCreator"
      + service_account_id = "projects/<PROJECT_ID>/serviceAccounts/service-account1@<PROJECT_ID>.iam.gserviceaccount.com"
    }

  # google_service_account_iam_binding.sa_iam_binding["service-account2:roles_iam.serviceAccountTokenCreator"] will be created
  + resource "google_service_account_iam_binding" "sa_iam_binding" {
      + etag               = (known after apply)
      + id                 = (known after apply)
      + members            = [
          + "serviceAccount:service-account2@<PROJECT_ID>.iam.gserviceaccount.com",
        ]
      + role               = "roles/iam.serviceAccountTokenCreator"
      + service_account_id = "projects/<PROJECT_ID>/serviceAccounts/service-account2@<PROJECT_ID>.iam.gserviceaccount.com"
    }

  # time_sleep.wait_service_accounts will be created
  + resource "time_sleep" "wait_service_accounts" {
      + create_duration = "10s"
      + id              = (known after apply)
    }

Plan: 9 to add, 0 to change, 0 to destroy.
```
