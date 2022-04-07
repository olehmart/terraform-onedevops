# Terraform module: cloud-funuctions

The purpose of this module to create GCP Cloud Functions and access to it.

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
    
  region:
    description: region name
    required: true
    value type: string
  
  bucket:
    description: configuration for source code
    required: true
    value type: map
    
    name: 
      description: name of the bucket where cloud function code will be placed
      required: true
      value type: string
      
    path: 
      description: path inside of the bucket where cloud function code will be placed
      required: false
      value type: string; (if provided, must end with "/")
      
  entrypoint:
    description: Name of the function that will be executed when the Google Cloud Function is triggered
    required: false
    value type: string
    
  runtime:
    description: The runtime in which the function is going to run. Eg. "nodejs10", "nodejs12", "nodejs14", "python37", 
                 "python38", "python39", "dotnet3", "go113", "java11", "ruby27", etc
    required: true
    value type: string

  available_memory_mb:
    description: Memory (in MB), available to the function
    required: false
    value type: string

  trigger_http:
    description: Boolean variable. Any HTTP request (of a supported type) to the endpoint will trigger function execution
    required: false
    value type: bool

  description:
    description: Description of the function
    required: false
    value type: string

  ingress_settings:
    description: String value that controls what traffic can reach the function. Allowed values are ALLOW_ALL, 
                 ALLOW_INTERNAL_AND_GCLB and ALLOW_INTERNAL_ONLY
    required: false
    value type: string

  labels:
    description: labels for the resource
    required: false
    value type: map

  environment_variables:
    description: environment variables for cloud function
    required: false
    value type: map

  service_account_email:
    description: If provided, the self-provided service account to run the function with
    required: false
    value type: string

  event_trigger:
    description: A source that fires events in response to a condition in another service
    required: false
    value type: map

    event_type:
      description: The type of event to observe
      required: true
      value type: string

    resource:
      description: The name or partial URI of the resource from which to observe events
      required: true
      value type: string

    failure_policy:
      description: Specifies policy for failed executions
      required: false
      value type: string
      
  timeout:
    description: Timeout (in seconds) for the function. Default value is 60 seconds
    required: false
    value type: string

  vpc_connector:
    description: The VPC Network Connector that this cloud function can connect to
    required: false
    value type: string

  vpc_connector_egress_settings:
    description: The egress settings for the connector, controlling what traffic is diverted through it.
                 Allowed values are ALL_TRAFFIC and PRIVATE_RANGES_ONLY
    required: false
    value type: string

  min_instances:
    description: The limit on the maximum number of function instances that may coexist at a given time
    required: false
    value type: string

  max_instances:
    description: The limit on the minimum number of function instances that may coexist at a given time
    required: false
    value type: string
```
```yaml
---
function1:
  name: function1
  region: us-central1
  entrypoint: hello_world1
  runtime: python37
  service_account_email:  tf-service-account@<PROJECT_ID>.iam.gserviceaccount.com
  available_memory_mb: 128
  trigger_http: true
  description: "creating function1"
  ingress_settings: "ALLOW_ALL"
  labels:
    provisioned_by: terraform
  environment_variables:
    env: dev
  timeout: 20
  bucket:
    name: bucket1-226
    path: "cloud-functions/"
  access:
    - role: "roles/cloudfunctions.invoker"
      members:
        - serviceAccount:864053391115-compute@developer.gserviceaccount.com
function2:
  name: function2
  region: us-central1
  entrypoint: hello_world2
  runtime: python37
  service_account_email:  tf-service-account@<PROJECT_ID>.iam.gserviceaccount.com
  available_memory_mb: 128
  trigger_http: true
  description: "creating function1"
  ingress_settings: "ALLOW_ALL"
  labels:
    provisioned_by: terraform
  environment_variables:
     env: dev2
  event_trigger:
    event_type: "google.pubsub.topic.publish"
    resource: "projects/my-project/topics/my-topic"
    failure_policy: false
  timeout: 20
  bucket:
    name: bucket2-226
  access:
    - role: roles/cloudfunctions.invoker
      members:
        - serviceAccount:864053391115-compute@developer.gserviceaccount.com
       

```
Example of running TF plan with example config:
```commandline
terraform plan -var=project_id=<PROJECT_ID> -var=config_path=./config_example.yaml

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

Terraform will perform the following actions:

  # data.archive_file.source["function1"] will be read during apply
  # (config refers to values not yet known)
 <= data "archive_file" "source"  {
      + id                  = (known after apply)
      + output_base64sha256 = (known after apply)
      + output_md5          = (known after apply)
      + output_path         = (known after apply)
      + output_sha          = (known after apply)
      + output_size         = (known after apply)
      + source_dir          = "src/function1"
      + type                = "zip"
    }

  # data.archive_file.source["function2"] will be read during apply
  # (config refers to values not yet known)
 <= data "archive_file" "source"  {
      + id                  = (known after apply)
      + output_base64sha256 = (known after apply)
      + output_md5          = (known after apply)
      + output_path         = (known after apply)
      + output_sha          = (known after apply)
      + output_size         = (known after apply)
      + source_dir          = "src/function2"
      + type                = "zip"
    }

  # google_cloudfunctions_function.function["function1"] will be created
  + resource "google_cloudfunctions_function" "function" {
      + available_memory_mb           = 128
      + description                   = "creating function1"
      + entry_point                   = "hello_world1"
      + https_trigger_url             = (known after apply)
      + id                            = (known after apply)
      + ingress_settings              = "ALLOW_ALL"
      + labels                        = {
          + "provisioned_by" = "terraform"
        }
      + max_instances                 = 0
      + name                          = "function1"
      + project                       = "<PROJECT_ID>"
      + region                        = "us-central1"
      + runtime                       = "python37"
      + service_account_email         = "tf-service-account@<PROJECT_ID>.iam.gserviceaccount.com"
      + source_archive_bucket         = "bucket1-226"
      + source_archive_object         = (known after apply)
      + timeout                       = 20
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

  # google_cloudfunctions_function.function["function2"] will be created
  + resource "google_cloudfunctions_function" "function" {
      + available_memory_mb           = 128
      + description                   = "creating function1"
      + entry_point                   = "hello_world2"
      + https_trigger_url             = (known after apply)
      + id                            = (known after apply)
      + ingress_settings              = "ALLOW_ALL"
      + labels                        = {
          + "owned_by"       = "epam"
          + "provisioned_by" = "terraform"
        }
      + max_instances                 = 0
      + name                          = "function2"
      + project                       = "<PROJECT_ID>"
      + region                        = "us-central1"
      + runtime                       = "python37"
      + service_account_email         = "tf-service-account@<PROJECT_ID>.iam.gserviceaccount.com"
      + source_archive_bucket         = "bucket2-226"
      + source_archive_object         = (known after apply)
      + timeout                       = 20
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

  # google_cloudfunctions_function_iam_binding.binding["function1:us-central1:roles/cloudfunctions.invoker"] will be created
  + resource "google_cloudfunctions_function_iam_binding" "binding" {
      + cloud_function = "function1"
      + etag           = (known after apply)
      + id             = (known after apply)
      + members        = [
          + "serviceAccount:864053391115-compute@developer.gserviceaccount.com",
        ]
      + project        = "<PROJECT_ID>"
      + region         = "us-central1"
      + role           = "roles/cloudfunctions.invoker"
    }

  # google_cloudfunctions_function_iam_binding.binding["function2:us-central1:roles/cloudfunctions.invoker"] will be created
  + resource "google_cloudfunctions_function_iam_binding" "binding" {
      + cloud_function = "function2"
      + etag           = (known after apply)
      + id             = (known after apply)
      + members        = [
          + "serviceAccount:864053391115-compute@developer.gserviceaccount.com",
        ]
      + project        = "<PROJECT_ID>"
      + region         = "us-central1"
      + role           = "roles/cloudfunctions.invoker"
    }

  # google_storage_bucket_object.archive["function1"] will be created
  + resource "google_storage_bucket_object" "archive" {
      + bucket         = "bucket1-226"
      + content_type   = (known after apply)
      + crc32c         = (known after apply)
      + detect_md5hash = "different hash"
      + id             = (known after apply)
      + kms_key_name   = (known after apply)
      + md5hash        = (known after apply)
      + media_link     = (known after apply)
      + name           = (known after apply)
      + output_name    = (known after apply)
      + self_link      = (known after apply)
      + source         = (known after apply)
      + storage_class  = (known after apply)
    }

  # google_storage_bucket_object.archive["function2"] will be created
  + resource "google_storage_bucket_object" "archive" {
      + bucket         = "bucket2-226"
      + content_type   = (known after apply)
      + crc32c         = (known after apply)
      + detect_md5hash = "different hash"
      + id             = (known after apply)
      + kms_key_name   = (known after apply)
      + md5hash        = (known after apply)
      + media_link     = (known after apply)
      + name           = (known after apply)
      + output_name    = (known after apply)
      + self_link      = (known after apply)
      + source         = (known after apply)
      + storage_class  = (known after apply)
    }

Plan: 6 to add, 0 to change, 0 to destroy.
```
