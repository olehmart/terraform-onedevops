# Terraform module: pubsub

The purpose of this module to create Pub/Sub and grant access to it.

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
Configuration for Pub/Sub should be placed in YAML config file and path to this file should be provided
to the module. The example configuration can be found here: [config_example.yaml](config_example.yaml)  
#### Format:
```yaml
resource_purpose: unique name for Pub/Sub (used only internally for Terraform)
  name:
    description: Topic name
    required: true
    value type: string;
      
  labels:
    decription: labels assigned to the resource
    required: false
    value type: map
    
  message_storage_policy:
    decription: Policy constraining the set of Google Cloud Platform regions where messages published to the topic may be stored. 
                If not present, then no constraints are in effect
    required: false
    value type: map
    
    allowed_persistence_regions:
      decription: A list of IDs of GCP regions where messages that are published to the topic may be persisted in storage
      required: true
      value type: list
      
  schema_settings:
    decription: Settings for validating messages published against a schema
    required: false
    value type: map
    
    schema:
      decription: The name of the schema that messages published should be validated against. 
                  Format is projects/{project}/schemas/{schema}.
      required: true
      value type: string
      
    encoding:
      decription: The encoding of messages validated against schema. Default value is ENCODING_UNSPECIFIED. 
                  Possible values are ENCODING_UNSPECIFIED, JSON, and BINARY
      required: false
      value type: string
      
  message_retention_duration:
    decription: Indicates the minimum duration to retain a message after it is published to the topic.
    required: false
    value type: string
    
  kms_key_name:
    decription: The resource name of the Cloud KMS CryptoKey to be used to protect access to messages published on this topic.
                The expected format is projects/*/locations/*/keyRings/*/cryptoKeys/*
    required: false
    value type: string
    
  access:
    decription: access configuration for topic
    required: false
    value type: list of maps
    
    role:
      description: IAM role name
      required: true
      value type: string
      
    members:
      description: List of members assigned to the IAM role. Each member name should start with member type(serviceAccount, user, group)
      required: true
      value type: list
      
  subscriptions:
    decription: List of subscriptions configurations
    required: false
    value type: list of maps
    
    name:
      description: Subscription name
      required: true
      value type: string
      
    labels:
      description: Labels assigned to the resource
      required: false
      value type: map
      
    push_config:
      description: If push delivery is used with this subscription, this field is used to configure it
      required: false
      value type: map
      
      push_endpoint:
        description: A URL locating the endpoint to which messages should be pushed
        required: true
        value type: string
        
      attributes:
        description: Endpoint configuration attributes
        required: false
        value type: string
        
    ack_deadline_seconds:
      description: This value is the maximum time after a subscriber receives a message before the subscriber should acknowledge the message
      required: false
      value type: string
      
    message_retention_duration:
      description: How long to retain unacknowledged messages in the subscription's backlog, from the moment a message is published
      required: false
      value type: string
      
    retain_acked_messages:
      description: Indicates whether to retain acknowledged messages
      required: false
      value type: bool
      
    filter:
      description: The subscription only delivers the messages that match the filter
      required: false
      value type: string
      
    dead_letter_policy:
      description: A policy that specifies the conditions for dead lettering messages in this subscription
      required: false
      value type: map
      
      dead_letter_topic:
        description: The name of the topic to which dead letter messages should be published. Format is projects/{project}/topics/{topic}
        required: false
        value type: string
        
      max_delivery_attempts:
        description: The maximum number of delivery attempts for any message
        required: false
        value type: string
        
    retry_policy:
      description: A policy that specifies how Pub/Sub retries message delivery for this subscription
      required: false
      value type: map
      
      minimum_backoff:
        description: The minimum delay between consecutive deliveries of a given message
        required: false
        value type: string
        
      maximum_backoff:
        description: The maximum delay between consecutive deliveries of a given message
        required: false
        value type: string
        
    enable_message_ordering:
      description: If true, messages published with the same orderingKey in PubsubMessage will be delivered to the 
                   subscribers in the order in which they are received by the Pub/Sub system
      required: false
      value type: bool
      
    access:
      decription: access configuration for subscription
      required: false
      value type: list of maps
    
      role:
        description: IAM role name
        required: true
        value type: string
      
      members:
        description: List of members assigned to the IAM role. Each member name should start with member type(serviceAccount, user, group)
        required: true
        value type: list
```
Example of config file:
```yaml
---
topic1:
  name: topic1
  labels:
    provisioned_by: terraform
    class: 3
  message_storage_policy:
    allowed_persistence_regions:
      - us-east1
      - us-central1
  message_retention_duration: 86600s
  access:
    - role: "roles/pubsub.viewer"
      members:
        - serviceAccount:864053391115-compute@developer.gserviceaccount.com
  subscriptions:
    - name: subs1-top1
      ack_deadline_seconds: 20
      labels:
        topic: topic1
      push_config:
        push_endpoint: https://example.com/push
        attributes:
          x-goog-version: v1
      access:
        - role: roles/pubsub.subscriber
          members:
            - serviceAccount:864053391115-compute@developer.gserviceaccount.com
    - name: subs2-top1
      labels:
        topic: topic2

topic2:
  name: topic2
  labels:
    provisioned_by: terraform
    class: 3
  access:
    - role: "roles/pubsub.viewer"
      members:
        - serviceAccount:864053391115-compute@developer.gserviceaccount.com
```
Example of running TF plan with example config:
```commandline
terraform plan -var=project_id=<PROJECT_ID> -var=config_path=./config_example.yaml

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.pubsub.google_pubsub_subscription.subscription["topic1:subs1-top1"] will be created
  + resource "google_pubsub_subscription" "subscription" {
      + ack_deadline_seconds = 20
      + id                   = (known after apply)
      + labels               = {
          + "topic" = "topic1"
        }
      + name                 = "subs1-top1"
      + project              = "<PROJECT_ID>"
      + topic                = "topic1"

      + expiration_policy {
          + ttl = (known after apply)
        }

      + push_config {
          + push_endpoint = "https://example.com/push"
        }
    }

  # module.pubsub.google_pubsub_subscription.subscription["topic1:subs2-top1"] will be created
  + resource "google_pubsub_subscription" "subscription" {
      + ack_deadline_seconds = (known after apply)
      + id                   = (known after apply)
      + labels               = {
          + "topic" = "topic2"
        }
      + name                 = "subs2-top1"
      + project              = "<PROJECT_ID>"
      + topic                = "topic1"

      + expiration_policy {
          + ttl = (known after apply)
        }
    }

  # module.pubsub.google_pubsub_subscription_iam_binding.editor["topic1:subs1-top1:roles/pubsub.subscriber"] will be created
  + resource "google_pubsub_subscription_iam_binding" "editor" {
      + etag         = (known after apply)
      + id           = (known after apply)
      + members      = [
          + "serviceAccount:864053391115-compute@developer.gserviceaccount.com",
        ]
      + project      = (known after apply)
      + role         = "roles/pubsub.subscriber"
      + subscription = "subs1-top1"
    }

  # module.pubsub.google_pubsub_topic.topic["topic1"] will be created
  + resource "google_pubsub_topic" "topic" {
      + id                         = (known after apply)
      + labels                     = {
          + "class"          = "3"
          + "provisioned_by" = "terraform"
        }
      + message_retention_duration = "86600s"
      + name                       = "topic1"
      + project                    = "<PROJECT_ID>"

      + message_storage_policy {
          + allowed_persistence_regions = [
              + "us-east1",
              + "us-central1",
            ]
        }

      + schema_settings {
          + encoding = (known after apply)
          + schema   = (known after apply)
        }
    }

  # module.pubsub.google_pubsub_topic.topic["topic2"] will be created
  + resource "google_pubsub_topic" "topic" {
      + id      = (known after apply)
      + labels  = {
          + "class"          = "3"
          + "provisioned_by" = "terraform"
        }
      + name    = "topic2"
      + project = "<PROJECT_ID>"

      + message_storage_policy {
          + allowed_persistence_regions = (known after apply)
        }

      + schema_settings {
          + encoding = (known after apply)
          + schema   = (known after apply)
        }
    }

  # module.pubsub.google_pubsub_topic_iam_binding.binding["topic1:roles/pubsub.viewer"] will be created
  + resource "google_pubsub_topic_iam_binding" "binding" {
      + etag    = (known after apply)
      + id      = (known after apply)
      + members = [
          + "serviceAccount:864053391115-compute@developer.gserviceaccount.com",
        ]
      + project = "<PROJECT_ID>"
      + role    = "roles/pubsub.viewer"
      + topic   = "topic1"
    }

  # module.pubsub.google_pubsub_topic_iam_binding.binding["topic2:roles/pubsub.viewer"] will be created
  + resource "google_pubsub_topic_iam_binding" "binding" {
      + etag    = (known after apply)
      + id      = (known after apply)
      + members = [
          + "serviceAccount:864053391115-compute@developer.gserviceaccount.com",
        ]
      + project = "<PROJECT_ID>"
      + role    = "roles/pubsub.viewer"
      + topic   = "topic2"
    }

Plan: 7 to add, 0 to change, 0 to destroy.
```
