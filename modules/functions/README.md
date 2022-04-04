# Terraform module: funuctions

The purpose of this module to create GCP Cloud Functions.

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
Configuration for cloud functions should be placed in YAML config file and path to this file should be provided
to the module. The example configuration can be found here:(config_example.yaml)  
#### Format:
```yaml
resource_purpose: (used only internally for Terraform)
    name:
      description: name of GCP cloud function
      required: true
      value type: string; length must be between 6 and 30 characters; must start with a lower case letter, followed by 
        one or more lower case alphanumerical characters that can be separated by hyphens;
    
    runtime: Runtime for cloud function execution
    memmory: Amount of memmory needed for function
    location: Location for storage bucket creation
```
```yaml
---
function1:
  name: function1
  src: ../../src/app1
  entry_point: hello_world
  runtime: python3
  memory: 128
  trigger_http: true
    
function2:
  name: function2
  src: ../../src/app2
  entry_point: hello_world1
  runtime: python3
  memory: 128
  trigger_http: true
```
Example of running TF plan with example config:
```commandline
terraform plan -var=project_id=<PROJECT_ID> -var=config_path=./config_example.yaml

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

form will perform the following actions:

  # google_cloudfunctions_function.function["function1:python3:function1:hello_world:true:128"] will be created
  + resource "google_cloudfunctions_function" "function" {
      + available_memory_mb           = 128
      + description                   = "function1"
      + entry_point                   = "hello_world"
      + https_trigger_url             = (known after apply)
      + id                            = (known after apply)
      + ingress_settings              = "ALLOW_ALL"
      + max_instances                 = 0
      + name                          = "function1"
      + project                       = (known after apply)
      + region                        = (known after apply)
      + runtime                       = "python3"
      + service_account_email         = (known after apply)
      + source_archive_bucket         = "function1"
      + source_archive_object         = "function1"
      + timeout                       = 60
      + trigger_http                  = true
      + vpc_connector_egress_settings = (known after apply)

      + event_trigger {
          + event_type = (known after apply)
          + resource   = (known after apply)

          + failure_policy {
              + retry = (known after apply)
            }
        }
    }

  # google_cloudfunctions_function.function["function2:python3:function2:hello_world1:true:128"] will be created
  + resource "google_cloudfunctions_function" "function" {
      + available_memory_mb           = 128
      + description                   = "function2"
      + entry_point                   = "hello_world1"
      + https_trigger_url             = (known after apply)
      + id                            = (known after apply)
      + ingress_settings              = "ALLOW_ALL"
      + max_instances                 = 0
      + name                          = "function2"
      + project                       = (known after apply)
      + region                        = (known after apply)
      + runtime                       = "python3"
      + service_account_email         = (known after apply)
      + source_archive_bucket         = "function2"
      + source_archive_object         = "function2"
      + timeout                       = 60
      + trigger_http                  = true
      + vpc_connector_egress_settings = (known after apply)

      + event_trigger {
          + event_type = (known after apply)
          + resource   = (known after apply)

          + failure_policy {
              + retry = (known after apply)
            }
        }
    }

  # google_cloudfunctions_function_iam_member.invoker["function1"] will be created
  + resource "google_cloudfunctions_function_iam_member" "invoker" {
      + cloud_function = "function1"
      + etag           = (known after apply)
      + id             = (known after apply)
      + member         = "allUsers"
      + project        = "verdant-victory-344817"
      + region         = "us-central1"
      + role           = "roles/cloudfunctions.invoker"
    }

  # google_cloudfunctions_function_iam_member.invoker["function2"] will be created
  + resource "google_cloudfunctions_function_iam_member" "invoker" {
      + cloud_function = "function2"
      + etag           = (known after apply)
      + id             = (known after apply)
      + member         = "allUsers"
      + project        = "verdant-victory-344817"
      + region         = "us-central1"
      + role           = "roles/cloudfunctions.invoker"
    }

  # google_storage_bucket.bucket["function1"] will be created
  + resource "google_storage_bucket" "bucket" {
      + force_destroy               = false
      + id                          = (known after apply)
      + location                    = "FUNCTION1"
      + name                        = "function1"
      + project                     = (known after apply)
      + self_link                   = (known after apply)
      + storage_class               = "STANDARD"
      + uniform_bucket_level_access = (known after apply)
      + url                         = (known after apply)
    }

  # google_storage_bucket.bucket["function2"] will be created
  + resource "google_storage_bucket" "bucket" {
      + force_destroy               = false
      + id                          = (known after apply)
      + location                    = "FUNCTION2"
      + name                        = "function2"
      + project                     = (known after apply)
      + self_link                   = (known after apply)
      + storage_class               = "STANDARD"
      + uniform_bucket_level_access = (known after apply)
      + url                         = (known after apply)
    }

  # google_storage_bucket_object.archive["../../src/app1:function1"] will be created
  + resource "google_storage_bucket_object" "archive" {
      + bucket         = "function1"
      + content_type   = (known after apply)
      + crc32c         = (known after apply)
      + detect_md5hash = "different hash"
      + id             = (known after apply)
      + kms_key_name   = (known after apply)
      + md5hash        = (known after apply)
      + media_link     = (known after apply)
      + name           = "function1.zip}"
      + output_name    = (known after apply)
      + self_link      = (known after apply)
      + source         = "../../src/app1"
      + storage_class  = (known after apply)
    }

  # google_storage_bucket_object.archive["../../src/app2:function2"] will be created
  + resource "google_storage_bucket_object" "archive" {
      + bucket         = "function2"
      + content_type   = (known after apply)
      + crc32c         = (known after apply)
      + detect_md5hash = "different hash"
      + id             = (known after apply)
      + kms_key_name   = (known after apply)
      + md5hash        = (known after apply)
      + media_link     = (known after apply)
      + name           = "function2.zip}"
      + output_name    = (known after apply)
      + self_link      = (known after apply)
      + source         = "../../src/app2"
      + storage_class  = (known after apply)
    }

Plan: 8 to add, 0 to change, 0 to destroy.
```
