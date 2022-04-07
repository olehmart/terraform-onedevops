data "archive_file" "source" {
  for_each = {
    for cf in local.cloud_functions :
    cf.name => cf
  }
  type        = "zip"
  source_dir  = "src/${each.value.name}"
  output_path = "src/${each.value.name}-${local.timestamp}.zip"
}

#compress code to a zip file
#store the code in gcs bucket
resource "google_storage_bucket_object" "archive" {
  depends_on = [data.archive_file.source]
  for_each = {
    for cf in local.cloud_functions :
    cf.name => cf
  }
  name   = "${each.value.bucket_path}${each.value.name}.zip#${data.archive_file.source[each.value.name].output_md5}"
  bucket = each.value.bucket_name
  source = data.archive_file.source[each.value.name].output_path
}

#create cloud function
resource "google_cloudfunctions_function" "function" {
  depends_on = [google_storage_bucket_object.archive]
  for_each = {
    for cf in local.cloud_functions :
    cf.name => cf
  }
  name                          = each.value.name
  description                   = each.value.description
  project                       = var.project_id
  region                        = each.value.region
  entry_point                   = each.value.entrypoint
  runtime                       = each.value.runtime
  available_memory_mb           = each.value.available_memory_mb
  trigger_http                  = each.value.trigger_http
  ingress_settings              = each.value.ingress_settings
  labels                        = each.value.labels
  source_archive_bucket         = each.value.bucket_name
  source_archive_object         = "${each.value.bucket_path}${each.value.name}.zip#${data.archive_file.source[each.value.name].output_md5}"
  timeout                       = each.value.timeout
  service_account_email         = each.value.service_account_email
  environment_variables         = each.value.environment_variables
  vpc_connector                 = each.value.vpc_connector
  vpc_connector_egress_settings = each.value.vpc_connector_egress_settings
  min_instances                 = each.value.min_instances
  max_instances                 = each.value.max_instances
  dynamic "event_trigger" {
    for_each = range(try(each.value.event_trigger, null) != null ? 1 : 0)
    content {
      event_type = each.value.event_trigger_event_type
      resource   = each.value.event_trigger_resource
      dynamic "failure_policy" {
        for_each = range(try(each.value.event_trigger_failure_policy, null) != null ? 1 : 0)
        content {
          retry = each.value.event_trigger_failure_policy
        }
      }
    }
  }
}

resource "google_cloudfunctions_function_iam_binding" "binding" {
  depends_on = [google_cloudfunctions_function.function]
  for_each = {
    for access in local.cloud_functions_access :
    join(":", [
      access.name,
      access.region,
      access.role,
      ]
    ) => access
  }
  project        = var.project_id
  region         = each.value.region
  cloud_function = each.value.name
  role           = each.value.role
  members        = each.value.members
}

