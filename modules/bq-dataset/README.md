# Terraform module: bq-datasets

The purpose of this module to create GCP BigQuery datasets, tables and set permissions for these resources.

### Variables:
```yaml
project_id: 
    description: GCP project ID
    required: true
config_path: 
    description: path to YAML file which contain resource configuration
    required: true
```

### Resource configuration
Configuration for BigQuery datasets should be placed in YAML config file and path to this file should be provided
to the module. The example configuration can be found here: [config_example.yaml](config_example.yaml)  
#### Format:
```yaml
resource_purpose: unique name for BigQuery dataset (used only internally for Terraform)
  dataset_id:
    description: BigQuery dataset ID 
    required: true
    value type: string; tetters, numbers, and underscores allowed;
    
  friendly_name:
    description: a user-friendly description of the dataset
    required: false
    value type: string
        
  description:
    description: descriptive name for the dataset
    required: false
    value type: string

  location:
    description: the geographic location where the dataset should reside
    required: true
    value type: string
    
  delete_contents_on_destroy:
    description: if set to true, delete all the tables in the dataset when destroying the resource; otherwise, destroying the resource will fail if tables are present.
    required: false
    default: true
    value type: string

  labels:
    description: the labels associated with this dataset
    required: false
    value type: map

  access:
    description: access configuration for dataset
    required: false
    value type: list of maps
      
      role:
        description: role name
        required: true
        value type: string

      user:
        description: IAM service account or group email
        required: true
        value type: string

  tables:
    description: tables configurations of dataset
    required: false
    value type: list of maps

      table_id:
        description: table ID
        required: true
        value type: string; unicode letters, marks, numbers, connectors, dashes or spaces allowed

      labels:
        description: the labels associated with this table
        required: false
        value type: map

      schema_file_path:
        description: path to JSON file with schema
        required: false
        value type: string

      deletion_protection:
        description: whether or not to allow Terraform to destroy the instance. Unless this field is set to false in Terraform state, a terraform destroy or terraform apply that would delete the instance will fail.
        required: false
        default: false
        value type: string
```
Example of config file:
```yaml
---
test1:
  dataset_id: test1
  friendly_name: test1
  description: "test dataset"
  location: US
  labels:
    class: 5
    provisioned_by: terraform
  access:
    - role: "roles/bigquery.metadataViewer"
      user: "864053391115-compute@developer.gserviceaccount.com"
  tables:
    - table_id: test-table1
      labels:
        table_class: 5
    - table_id: test-table2
      labels:
        table_class: 5
      schema_file_path: ./schemas/test_schema.json

test2:
  dataset_id: test2
  friendly_name: test2
  description: "test dataset2"
  location: US
  delete_contents_on_destroy: true
  kms_key_name: projects/<PROJECT_ID>/locations/us-central1/keyRings/example-ring/cryptoKeys/example-key
  labels:
    class: 3
    provisioned_by: terraform
  access:
    - role: "roles/bigquery.dataViewer"
      user: "tf-service-account@<PROJECT_ID>.iam.gserviceaccount.com"
  tables:
    - table_id: test-table1
      labels:
        table_class: 5
      schema_file_path: ./schemas/test_schema.json
      deletion_protection: true
```
Example of running TF plan with example config:
```commandline
terraform plan -var=project_id=<PROJECT_ID> -var=config_path=./config_example.yaml

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # google_bigquery_dataset.dataset["US:test1"] will be created
  + resource "google_bigquery_dataset" "dataset" {
      + creation_time              = (known after apply)
      + dataset_id                 = "test1"
      + delete_contents_on_destroy = true
      + description                = "test dataset"
      + etag                       = (known after apply)
      + friendly_name              = "test1"
      + id                         = (known after apply)
      + labels                     = {
          + "class"          = "5"
          + "provisioned_by" = "terraform"
        }
      + last_modified_time         = (known after apply)
      + location                   = "US"
      + project                    = "<PROJECT_ID>"
      + self_link                  = (known after apply)

      + access {
          + domain         = (known after apply)
          + group_by_email = (known after apply)
          + role           = (known after apply)
          + special_group  = (known after apply)
          + user_by_email  = (known after apply)

          + dataset {
              + target_types = (known after apply)

              + dataset {
                  + dataset_id = (known after apply)
                  + project_id = (known after apply)
                }
            }

          + view {
              + dataset_id = (known after apply)
              + project_id = (known after apply)
              + table_id   = (known after apply)
            }
        }

      + default_encryption_configuration {}
    }

  # google_bigquery_dataset.dataset["US:test2"] will be created
  + resource "google_bigquery_dataset" "dataset" {
      + creation_time              = (known after apply)
      + dataset_id                 = "test2"
      + delete_contents_on_destroy = true
      + description                = "test dataset2"
      + etag                       = (known after apply)
      + friendly_name              = "test2"
      + id                         = (known after apply)
      + labels                     = {
          + "class"          = "3"
          + "provisioned_by" = "terraform"
        }
      + last_modified_time         = (known after apply)
      + location                   = "US"
      + project                    = "<PROJECT_ID>"
      + self_link                  = (known after apply)

      + access {
          + domain         = (known after apply)
          + group_by_email = (known after apply)
          + role           = (known after apply)
          + special_group  = (known after apply)
          + user_by_email  = (known after apply)

          + dataset {
              + target_types = (known after apply)

              + dataset {
                  + dataset_id = (known after apply)
                  + project_id = (known after apply)
                }
            }

          + view {
              + dataset_id = (known after apply)
              + project_id = (known after apply)
              + table_id   = (known after apply)
            }
        }

      + default_encryption_configuration {
          + kms_key_name = "projects/<PROJECT_ID>/locations/us-central1/keyRings/example-ring/cryptoKeys/example-key"
        }
    }

  # google_bigquery_dataset_access.access["US:test1:864053391115-compute@developer.gserviceaccount.com:roles/bigquery.metadataViewer"] will be created
  + resource "google_bigquery_dataset_access" "access" {
      + api_updated_member = (known after apply)
      + dataset_id         = "test1"
      + id                 = (known after apply)
      + project            = "<PROJECT_ID>"
      + role               = "roles/bigquery.metadataViewer"
      + user_by_email      = "864053391115-compute@developer.gserviceaccount.com"
    }

  # google_bigquery_dataset_access.access["US:test1:<PROJECT_ID>@appspot.gserviceaccount.com:roles/bigquery.dataViewer"] will be created
  + resource "google_bigquery_dataset_access" "access" {
      + api_updated_member = (known after apply)
      + dataset_id         = "test1"
      + id                 = (known after apply)
      + project            = "<PROJECT_ID>"
      + role               = "roles/bigquery.dataViewer"
      + user_by_email      = "<PROJECT_ID>@appspot.gserviceaccount.com"
    }

  # google_bigquery_dataset_access.access["US:test2:tf-service-account@<PROJECT_ID>.iam.gserviceaccount.com:roles/bigquery.dataViewer"] will be created
  + resource "google_bigquery_dataset_access" "access" {
      + api_updated_member = (known after apply)
      + dataset_id         = "test2"
      + id                 = (known after apply)
      + project            = "<PROJECT_ID>"
      + role               = "roles/bigquery.dataViewer"
      + user_by_email      = "tf-service-account@<PROJECT_ID>.iam.gserviceaccount.com"
    }

  # google_bigquery_table.table["US:test1:test-table1"] will be created
  + resource "google_bigquery_table" "table" {
      + creation_time       = (known after apply)
      + dataset_id          = "test1"
      + deletion_protection = false
      + etag                = (known after apply)
      + expiration_time     = (known after apply)
      + id                  = (known after apply)
      + labels              = {
          + "table_class" = "5"
        }
      + last_modified_time  = (known after apply)
      + location            = (known after apply)
      + num_bytes           = (known after apply)
      + num_long_term_bytes = (known after apply)
      + num_rows            = (known after apply)
      + project             = "<PROJECT_ID>"
      + self_link           = (known after apply)
      + table_id            = "test-table1"
      + type                = (known after apply)
    }

  # google_bigquery_table.table["US:test1:test-table2"] will be created
  + resource "google_bigquery_table" "table" {
      + creation_time       = (known after apply)
      + dataset_id          = "test1"
      + deletion_protection = false
      + etag                = (known after apply)
      + expiration_time     = (known after apply)
      + id                  = (known after apply)
      + labels              = {
          + "table_class" = "5"
        }
      + last_modified_time  = (known after apply)
      + location            = (known after apply)
      + num_bytes           = (known after apply)
      + num_long_term_bytes = (known after apply)
      + num_rows            = (known after apply)
      + project             = "<PROJECT_ID>"
      + schema              = jsonencode(
            [
              + {
                  + description = "The Permalink"
                  + mode        = "NULLABLE"
                  + name        = "permalink"
                  + type        = "STRING"
                },
              + {
                  + description = "State where the head office is located"
                  + mode        = "NULLABLE"
                  + name        = "state"
                  + type        = "STRING"
                },
            ]
        )
      + self_link           = (known after apply)
      + table_id            = "test-table2"
      + type                = (known after apply)
    }

  # google_bigquery_table.table["US:test2:test-table1"] will be created
  + resource "google_bigquery_table" "table" {
      + creation_time       = (known after apply)
      + dataset_id          = "test2"
      + deletion_protection = true
      + etag                = (known after apply)
      + expiration_time     = (known after apply)
      + id                  = (known after apply)
      + labels              = {
          + "table_class" = "5"
        }
      + last_modified_time  = (known after apply)
      + location            = (known after apply)
      + num_bytes           = (known after apply)
      + num_long_term_bytes = (known after apply)
      + num_rows            = (known after apply)
      + project             = "<PROJECT_ID>"
      + schema              = jsonencode(
            [
              + {
                  + description = "The Permalink"
                  + mode        = "NULLABLE"
                  + name        = "permalink"
                  + type        = "STRING"
                },
              + {
                  + description = "State where the head office is located"
                  + mode        = "NULLABLE"
                  + name        = "state"
                  + type        = "STRING"
                },
            ]
        )
      + self_link           = (known after apply)
      + table_id            = "test-table1"
      + type                = (known after apply)
    }

Plan: 8 to add, 0 to change, 0 to destroy.
```
