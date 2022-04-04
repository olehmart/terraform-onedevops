# Currently, resource google_cloudbuild_trigger doesn't support "approval" configuration.
# If approval should be enabled, it has to be done manually

resource "google_cloudbuild_trigger" "trigger" {
  for_each = {
    for trigger in local.triggers:
        trigger.name => trigger
  }
  project         = var.project_id
  name            = each.value.name
  description     = each.value.description
  tags            = each.value.tags
  disabled        = each.value.disabled
  substitutions   = each.value.substitutions
  service_account = each.value.service_account
  filename        = each.value.filename
  dynamic "git_file_source" {
    for_each = range(try(each.value.git_file_source, null) != null ? 1 : 0)
    content {
      path      = each.value.git_file_source_path
      uri       = each.value.git_file_source_uri
      repo_type = each.value.git_file_source_repo_type
      revision  = each.value.git_file_source_revision
    }
  }
  dynamic "source_to_build" {
    for_each = range(try(each.value.source_to_build, null) != null ? 1 : 0)
    content {
      uri       = each.value.source_to_build_uri
      ref       = each.value.source_to_build_ref
      repo_type = each.value.source_to_build_repo_type
    }
  }
  dynamic "trigger_template" {
    for_each = range(try(each.value.trigger_template, null) != null ? 1 : 0)
    content {
      project_id   = each.value.trigger_template_project_id
      repo_name    = each.value.trigger_template_repo_name
      dir          = each.value.trigger_template_dir
      invert_regex = each.value.trigger_template_invert_regex
      branch_name  = each.value.trigger_template_branch_name
      tag_name     = each.value.trigger_template_tag_name
      commit_sha   = each.value.trigger_template_commit_sha
    }
  }
  dynamic "github" {
    for_each = range(try(each.value.github, null) != null ? 1 : 0)
    content {
      owner = each.value.github_owner
      name  = each.value.github_name
      dynamic "pull_request" {
        for_each = range(try(each.value.github_pull_request, null) != null ? 1 : 0)
        content {
          branch          = each.value.github_pull_request_branch
          comment_control = each.value.github_pull_request_comment_control
          invert_regex    = each.value.github_pull_request_invert_regex
        }
      }
      dynamic "push" {
        for_each = range(try(each.value.github_push, null) != null ? 1 : 0)
        content {
          invert_regex = each.value.github_push_invert_regex
          branch       = each.value.github_push_branch
          tag          = each.value.github_push_tag
        }
      }
    }
  }
  dynamic "pubsub_config" {
    for_each = range(try(each.value.pubsub_config, null) != null ? 1 : 0)
    content {
      service_account_email = each.value.pubsub_config_service_account_email
      topic                 = each.value.pubsub_config_topic
      state                 = each.value.pubsub_config_state
      subscription          = each.value.pubsub_config_subscription
    }
  }
  dynamic "webhook_config" {
    for_each = range(try(each.value.webhook_config, null) != null ? 1 : 0)
    content {
      secret = each.value.webhook_config_secret
      state  = each.value.webhook_config_state
    }
  }
}
