resource "google_pubsub_topic" "topic" {
  for_each = {
    for topic in local.topics:
        topic.name => topic
  }
  project = var.project_id
  name    = each.value.name
  labels  = each.value.labels
  dynamic "message_storage_policy" {
    for_each = range(try(each.value.message_storage_policy, null) != null ? 1 : 0)
    content {
      allowed_persistence_regions = each.value.message_storage_policy_allowed_persistence_regions
    }
  }
  dynamic "schema_settings" {
    for_each = range(try(each.value.schema_settings, null) != null ? 1 : 0)
    content {
      schema   = each.value.schema_settings_schema
      encoding = each.value.schema_settings_encoding
    }
  }
  message_retention_duration = each.value.message_retention_duration
  kms_key_name               = each.value.kms_key_name

}

resource "google_pubsub_topic_iam_binding" "binding" {
  depends_on = [google_pubsub_topic.topic]
  for_each = {
    for access in local.topic_access:
        join(":", [
          access.topic,
          access.role,
          ]
        ) => access
  }
  project    = var.project_id
  topic      = each.value.topic
  role       = each.value.role
  members    = each.value.members
}

resource "google_pubsub_subscription" "subscription" {
  depends_on = [google_pubsub_topic.topic]
  for_each = {
    for subscription in local.subscriptions:
        join(":", [
          subscription.topic,
          subscription.name,
          ]
        ) => subscription
  }
  project = var.project_id
  name    = each.value.name
  topic   = each.value.topic
  labels  = each.value.labels
  dynamic "push_config" {
    for_each = range(try(each.value.push_config, null) != null ? 1 : 0)
    content {
      push_endpoint = each.value.push_config_push_endpoint
      attributes    = each.value.push_config_attributes
    }
  }
  ack_deadline_seconds       = each.value.ack_deadline_seconds
  message_retention_duration = each.value.message_retention_duration
  retain_acked_messages      = each.value.retain_acked_messages
  filter                     = each.value.filter
  dynamic "dead_letter_policy" {
    for_each = range(try(each.value.dead_letter_policy, null) != null ? 1 : 0)
    content {
      dead_letter_topic     = each.value.dead_letter_policy_dead_letter_topic
      max_delivery_attempts = each.value.dead_letter_policy_max_delivery_attempts
    }
  }
  dynamic "retry_policy" {
    for_each = range(try(each.value.retry_policy, null) != null ? 1 : 0)
    content {
      minimum_backoff = each.value.retry_policy_minimum_backoff
      maximum_backoff = each.value.retry_policy_maximum_backoff
    }
  }
  enable_message_ordering = each.value.enable_message_ordering
}

resource "google_pubsub_subscription_iam_binding" "editor" {
  depends_on = [google_pubsub_subscription.subscription]
  for_each   = {
    for access in local.subscription_access:
        join(":", [
          access.topic,
          access.subscription,
          access.role,
          ]
        ) => access
  }
  subscription = each.value.subscription
  role         = each.value.role
  members      = each.value.members
}
