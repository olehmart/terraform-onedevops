locals {
  config = yamldecode(file(var.config_path))

  topics = flatten([
    for topic_purpose, topic_props in local.config :
          [
            {
              name = topic_props["name"]
              labels = lookup(topic_props, "labels", {})
              message_storage_policy = lookup(topic_props, "message_storage_policy", null)
              message_storage_policy_allowed_persistence_regions = lookup(try(topic_props["message_storage_policy"],
                {}), "allowed_persistence_regions", "")
              schema_settings = lookup(topic_props, "schema_settings", null)
              schema_settings_schema = lookup(try(topic_props["schema_settings"], {}), "schema", "")
              schema_settings_encoding = lookup(try(topic_props["schema_settings"], {}), "encoding", "")
              message_retention_duration = lookup(topic_props, "message_retention_duration", "")
              kms_key_name = lookup(topic_props, "kms_key_name", "")
          }
          ]
  ])

  subscriptions = flatten([
    for topic_purpose, topic_props in local.config : [
      for subscription_props in lookup(topic_props, "subscriptions", []) : [
        {
          topic   = topic_props["name"]
          name = subscription_props["name"]
          labels = lookup(subscription_props, "labels", {})
          push_config = lookup(subscription_props, "push_config", null)
          push_config_push_endpoint = lookup(try(subscription_props["push_config"], {}), "push_endpoint", "")
          push_config_attributes = lookup(try(subscription_props["push_config"], {}), "attributes", "")
          ack_deadline_seconds = lookup(subscription_props, "ack_deadline_seconds", null)
          message_retention_duration = lookup(subscription_props, "message_retention_duration", "")
          retain_acked_messages = lookup(subscription_props, "retain_acked_messages", null)
          filter = lookup(subscription_props, "filter", "")
          dead_letter_policy = lookup(subscription_props, "dead_letter_policy", null)
          dead_letter_policy_dead_letter_topic = lookup(try(subscription_props["dead_letter_policy"], {}), "dead_letter_topic", "")
          dead_letter_policy_max_delivery_attempts = lookup(try(subscription_props["dead_letter_policy"], {}), "max_delivery_attempts", "")
          retry_policy = lookup(subscription_props, "retry_policy", null)
          retry_policy_minimum_backoff = lookup(try(subscription_props["retry_policy"], {}), "minimum_backoff", "")
          retry_policy_maximum_backoff = lookup(try(subscription_props["retry_policy"], {}), "maximum_backoff", "")
          enable_message_ordering = lookup(subscription_props, "enable_message_ordering", null)
        }
      ]
    ]
  ])

  topic_access = flatten([
    for topic_purpose, topic_props in local.config : [
      for access_props in lookup(topic_props, "access", []) : [
        {
          topic   = topic_props["name"]
          role    = access_props["role"]
          members = access_props["members"]
        }
      ]
    ]
  ])

  subscription_access = flatten([
    for topic_purpose, topic_props in local.config : [
      for subscription_props in lookup(topic_props, "subscriptions", []) : [
        for access_props in lookup(subscription_props, "access", []) : [
          {
            topic        = topic_props["name"]
            subscription = subscription_props["name"]
            role         = access_props["role"]
            members      = access_props["members"]
          }
        ]
      ]
    ]
  ])
}
