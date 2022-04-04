# Terraform module: cloud-build-triggers

The purpose of this module to create GCP cloud build triggers.

### Known issues:
&#x1F534; **Currently, support of approval configuration hasn't been added to Terraform resource `google_cloudbuild_trigger`. To enable Trigger approval, it has to be done manually!**

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
Configuration for GCP cloud build triggers should be placed in YAML config file and path to this file should be provided
to the module. The example configuration can be found here: [config_example.yaml](config_example.yaml)  
#### Format:
```yaml
resource_purpose: unique name for GCP cloud build trigger (used only internally for Terraform)
  name:
    description: name of cloud build trigger
    required: true
    value type: string; may only contain alphanumeric characters and dashes, and cannot start or end with a dash;
    
  description:
    description: description of cloud build trigger
    required: false
    value type: string
        
  tags:
    description: list of tags assigned to the resource
    required: false
    value type: list
  
  disabled:
    description: whether the trigger is disabled or not. If true, the trigger will never result in a build
    required: false
    value type: bool
    default value: true
    
  substitutions:
    description: substitutions data for Build resource
    required: false
    value type: map
  
  service_account:
    description: service account for the resource
    required: false
    value type: string. Format - projects/{PROJECT_ID}/serviceAccounts/{ACCOUNT_ID_OR_EMAIL}
    
  filename:
    description: path, from the source root, to a file whose contents is used for the template
    required: false
    value type: string
    
  git_file_source:
    description: the file source describing the local or remote Build template
    required: false
    value type: map
    
    path:
      description: the path of the file, with the repo root as the root of the path
      required: true
      value type: string
    
    uri:
      description: the URI of the repo
      required: false
      value type: string
      
    repo_type:
      description: the type of the repo, since it may not be explicit from the repo field (e.g from a URL). 
                   Possible values are UNKNOWN, CLOUD_SOURCE_REPOSITORIES, and GITHUB
      required: false
      value type: string
      
    revision:
      description: the branch, tag, arbitrary ref, or SHA version of the repo to use when resolving the filename
      required: false
      value type: string
  
  source_to_build:
    description: the repo and ref of the repository from which to build
    required: false
    value type: map
    
    uri:
      description: the URI of the repo
      required: true
      value type: string
      
    ref:
      description: the branch or tag to use. Must start with "refs/"
      required: true
      value type: string
      
    repo_type:
      description: the type of the repo, since it may not be explicit from the repo field (e.g from a URL). 
                   Possible values are UNKNOWN, CLOUD_SOURCE_REPOSITORIES, and GITHUB
      required: true
      value type: string
      
  trigger_template:
    description: template describing the types of source changes to trigger a build
    required: false
    value type: map
    
    project_id:
      description: ID of the project that owns the Cloud Source Repository
      required: false
      value type: string
      
    repo_name:
      description: name of the Cloud Source Repository. If omitted, the name "default" is assumed
      required: false
      value type: string
      
    dir:
      description: directory, relative to the source root, in which to run the build
      required: false
      value type: string
      
    invert_regex:
      description: only trigger a build if the revision regex does NOT match the revision regex
      required: false
      value type: bool
      
    branch_name:
      description: name of the branch to build. Exactly one a of branch name, tag, or commit SHA must be provided. 
                   This field is a regular expression
      required: false
      value type: string
      
    tag_name:
      description: name of the tag to build. Exactly one of a branch name, tag, or commit SHA must be provided. 
                   This field is a regular expression
      required: false
      value type: string
      
    commit_sha:
      description: explicit commit SHA to build. Exactly one of a branch name, tag, or commit SHA must be provided
      required: false
      value type: string
      
  github:
    description: describes the configuration of a trigger that creates a build whenever a GitHub event is received
    required: false
    value type: map
    
    owner:
      description: owner of the repository
      required: false
      value type: string
    
    name:
      description: name of the repository
      required: false
      value type: string

    pull_request:
      description: filter to match changes in pull requests. Specify only one of pull_request or push
      required: false
      value type: map
      
      branch:
        description: regex of branches to match
        required: true
        value type: string
        
      comment_control:
        description: whether to block builds on a "/gcbrun" comment from a repository owner or collaborator. 
                     Possible values are COMMENTS_DISABLED, COMMENTS_ENABLED, and COMMENTS_ENABLED_FOR_EXTERNAL_CONTRIBUTORS_ONLY
        required: false
        value type: string
        
      invert_regex:
        description: if true, branches that do NOT match the git_ref will trigger a build
        required: false
        value type: bool
    
    push:
      description: filter to match changes in refs, like branches or tags. Specify only one of pull_request or push
      required: false
      value type: map
      
      invert_regex:
        description: when true, only trigger a build if the revision regex does NOT match the git_ref regex
        required: false
        value type: bool
        
      branch:
        description: regex of branches to match. Specify only one of branch or tag
        required: false
        value type: string
        
      tag:
        description: regex of tags to match. Specify only one of branch or tag
        required: false
        value type: string
    
  pubsub_config:
    description: PubsubConfig describes the configuration of a trigger that creates a build whenever a Pub/Sub message is published
    required: false
    value type: map
      
    service_account_email:
      description: service account that will make the push request
      required: false
      value type: string
        
    topic:
      description: the name of the topic from which this subscription is receiving messages
      required: true
      value type: string
      
    state:
      description: potential issues with the underlying Pub/Sub subscription configuration. Only populated on get requests
      required: false
      value type: string

    subscription:
      description: output only. Name of the subscription
      required: false
      value type: string
      
  webhook_config:
    description: webhookConfig describes the configuration of a trigger that creates a build whenever a webhook is sent to a trigger's webhook URL
    required: false
    value type: map
    
    secret:
      description: resource name for the secret required as a URL parameter
      required: true
      value type: string
      
    state:
      description: potential issues with the underlying Pub/Sub subscription configuration. Only populated on get requests
      required: false
      value type: string
```
Example of config file:
```yaml
---
trigger1:
  name: trigger1
  decription: "test trigger"
  tags: ["tag1", "tag2"]
  service_account: projects/<PROJECT_ID>/serviceAccounts/tf-service-account@<PROJECT_ID>.iam.gserviceaccount.com
  disabled: true
  filename: cloudbuild/cloudbuildApply.yaml
  github:
    name: terraform-onedevops
    owner: olehmart
    push:
      branch: "^main$"
  substitutions:
    _ENV: dev
trigger2:
  name: trigger2
  decription: "test trigger2"
  tags: ["tag1", "tag2"]
  service_account: projects/<PROJECT_ID>/serviceAccounts/tf-service-account@<PROJECT_ID>.iam.gserviceaccount.com
  disabled: true
  filename: cloudbuild/cloudbuildApply.yaml
  github:
    name: terraform-onedevops
    owner: olehmart
    pull_request:
      branch: "^main$"
      comment_control: COMMENTS_ENABLED_FOR_EXTERNAL_CONTRIBUTORS_ONLY
  substitutions:
    _ENV: dev2
```
Example of running TF plan with example config:
```commandline
terraform plan -var=project_id=<PROJECT_ID> -var=config_path=./config_example.yaml

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.cloud-build-trigger.google_cloudbuild_trigger.trigger["trigger1"] will be created
  + resource "google_cloudbuild_trigger" "trigger" {
      + create_time     = (known after apply)
      + description     = "trigger1"
      + disabled        = true
      + filename        = "cloudbuild/cloudbuildApply.yaml"
      + id              = (known after apply)
      + name            = "trigger1"
      + project         = "<PROJECT_ID>"
      + service_account = "projects/<PROJECT_ID>/serviceAccounts/tf-service-account@<PROJECT_ID>.iam.gserviceaccount.com"
      + substitutions   = {
          + "_ENV" = "dev"
        }
      + tags            = [
          + "tag1",
          + "tag2",
        ]
      + trigger_id      = (known after apply)

      + github {
          + name  = "terraform-onedevops"
          + owner = "olehmart"

          + push {
              + branch       = "^main$"
              + invert_regex = false
            }
        }
    }

  # module.cloud-build-trigger.google_cloudbuild_trigger.trigger["trigger2"] will be created
  + resource "google_cloudbuild_trigger" "trigger" {
      + create_time     = (known after apply)
      + description     = "trigger2"
      + disabled        = true
      + filename        = "cloudbuild/cloudbuildApply.yaml"
      + id              = (known after apply)
      + name            = "trigger2"
      + project         = "<PROJECT_ID>"
      + service_account = "projects/<PROJECT_ID>/serviceAccounts/tf-service-account@<PROJECT_ID>.iam.gserviceaccount.com"
      + substitutions   = {
          + "_ENV" = "dev2"
        }
      + tags            = [
          + "tag1",
          + "tag2",
        ]
      + trigger_id      = (known after apply)

      + github {
          + name  = "terraform-onedevops"
          + owner = "olehmart"

          + pull_request {
              + branch          = "^main$"
              + comment_control = "COMMENTS_ENABLED_FOR_EXTERNAL_CONTRIBUTORS_ONLY"
              + invert_regex    = false
            }
        }
    }

Plan: 2 to add, 0 to change, 0 to destroy.
```

