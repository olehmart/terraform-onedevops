# Terraform module: gcs-bucket

The purpose of this module to create GCS buckets and grant access to it.

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
Configuration for GCS buckets should be placed in YAML config file and path to this file should be provided
to the module. The example configuration can be found here: [config_example.yaml](config_example.yaml)  
#### Format:
```yaml
resource_purpose: unique name for IAM service account (used only internally for Terraform)
    name:
      description: GCS bucket name
      required: true
      value type: string; bucket names must contain 3-63 characters. names containing dots can contain up to 
                  222 characters, but each dot-separated component can be no longer than 63 characters;
    
    location:
      description: GCS bucket location
      required: true
      value type: string
        
    force_destroy:
      description: when deleting a bucket, this boolean option will delete all contained objects. 
                   If you try to delete a bucket that contains objects, Terraform will fail that run
      required: false
      value type: bool
      default value: true
    
    storage_class:
      description: the Storage Class of the new bucket. Supported values include STANDARD, MULTI_REGIONAL, REGIONAL, 
                   NEARLINE, COLDLINE, ARCHIVE.
      required: false
      value type: string
      default value: STANDARD

    versioning_enabled:
      description: whether bucket versioning is enabled
      required: false
      value type: bool
      default value: false

    labels:
      description: the labels associated with this GCS bucket
      required: false
      value type: map

    logging: 
      description: logging configuration
      required: false
      value type: map
    
      log_bucket:
        description: GCS bucket name for logging
        required: false
        value type: string

      log_object_prefix:
        description: the object prefix for log objects. If it's not provided, by default GCS sets this to this bucket's name.
        required: false
        value type: string

    encryption:
      description: encryptiong configuration
      required: false
      value type: map
      
      default_kms_key_name:
        description: KMS key ID
        required: false
        value type: string

    access:
      description: access configuration for GCS bucket
      required: false
      value type: list of maps

      role:
        description: IAM role name
        required: true
        value type: string
      
      members:
        description: list of members to assign the role. Each member name should start with member type(serviceAccount, user, group)
        required: true
        value type: list
```
Example of config file:
```yaml
---
bucket1:
  name: onedevops-test-bucket1
  location: US
  force_destroy: true
  storage_class: STANDARD
  versioning_enabled: false
  labels:
    provisioned_by: terraform
    class: 3
  logging:
    log_bucket: onedevops-log-bucket
    log_object_prefix: /state/
  encryption:
    default_kms_key_name: projects/<PROJECT_ID>/locations/us-central1/keyRings/example-ring/cryptoKeys/example-key'
  access:
    - role: "roles/storage.legacyBucketReader"
      members:
        - serviceAccount:<PROJECT_ID>@appspot.gserviceaccount.com
        - serviceAccount:864053391115-compute@developer.gserviceaccount.com
    - role: "roles/storage.admin"
      members:
        - tf-service-account@<PROJECT_ID>.iam.gserviceaccount.com
bucket2:
  name: onedevops-test-bucket2
  location: US
  force_destroy: true
  labels:
    provisioned_by: terraform
    class: 3
  access:
    - role: "roles/storage.legacyBucketReader"
      members:
        - serviceAccount:<PROJECT_ID>@appspot.gserviceaccount.com
        - serviceAccount:864053391115-compute@developer.gserviceaccount.com
```
Example of running TF plan with example config:
```commandline
terraform plan -var=project_id=<PROJECT_ID> -var=config_path=./config_example.yaml

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # google_storage_bucket.bucket["US:onedevops-test-bucket1"] will be created
  + resource "google_storage_bucket" "bucket" {
      + force_destroy               = true
      + id                          = (known after apply)
      + labels                      = {
          + "class"          = "3"
          + "provisioned_by" = "terraform"
        }
      + location                    = "US"
      + name                        = "onedevops-test-bucket1"
      + project                     = "<PROJECT_ID>"
      + self_link                   = (known after apply)
      + storage_class               = "STANDARD"
      + uniform_bucket_level_access = (known after apply)
      + url                         = (known after apply)

      + encryption {
          + default_kms_key_name = "projects/<PROJECT_ID>/locations/us-central1/keyRings/example-ring/cryptoKeys/example-key'"
        }

      + logging {
          + log_bucket        = "onedevops-log-bucket"
          + log_object_prefix = (known after apply)
        }

      + versioning {
          + enabled = false
        }
    }

  # google_storage_bucket.bucket["US:onedevops-test-bucket2"] will be created
  + resource "google_storage_bucket" "bucket" {
      + force_destroy               = true
      + id                          = (known after apply)
      + labels                      = {
          + "class"          = "3"
          + "provisioned_by" = "terraform"
        }
      + location                    = "US"
      + name                        = "onedevops-test-bucket2"
      + project                     = "<PROJECT_ID>"
      + self_link                   = (known after apply)
      + storage_class               = "STANDARD"
      + uniform_bucket_level_access = (known after apply)
      + url                         = (known after apply)

      + encryption {}

      + logging {
          + log_object_prefix = (known after apply)
        }

      + versioning {
          + enabled = false
        }
    }

  # google_storage_bucket_iam_binding.binding["US:onedevops-test-bucket1:roles/storage.admin"] will be created
  + resource "google_storage_bucket_iam_binding" "binding" {
      + bucket  = "onedevops-test-bucket1"
      + etag    = (known after apply)
      + id      = (known after apply)
      + members = [
          + "tf-service-account@<PROJECT_ID>.iam.gserviceaccount.com",
        ]
      + role    = "roles/storage.admin"
    }

  # google_storage_bucket_iam_binding.binding["US:onedevops-test-bucket1:roles/storage.legacyBucketReader"] will be created
  + resource "google_storage_bucket_iam_binding" "binding" {
      + bucket  = "onedevops-test-bucket1"
      + etag    = (known after apply)
      + id      = (known after apply)
      + members = [
          + "serviceAccount:864053391115-compute@developer.gserviceaccount.com",
          + "serviceAccount:<PROJECT_ID>@appspot.gserviceaccount.com",
        ]
      + role    = "roles/storage.legacyBucketReader"
    }

  # google_storage_bucket_iam_binding.binding["US:onedevops-test-bucket2:roles/storage.legacyBucketReader"] will be created
  + resource "google_storage_bucket_iam_binding" "binding" {
      + bucket  = "onedevops-test-bucket2"
      + etag    = (known after apply)
      + id      = (known after apply)
      + members = [
          + "serviceAccount:864053391115-compute@developer.gserviceaccount.com",
          + "serviceAccount:<PROJECT_ID>@appspot.gserviceaccount.com",
        ]
      + role    = "roles/storage.legacyBucketReader"
    }

Plan: 5 to add, 0 to change, 0 to destroy.
```
