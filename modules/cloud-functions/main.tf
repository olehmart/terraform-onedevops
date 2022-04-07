#compress code to a zip file 
#store the code in gcs bucket
resource "google_storage_bucket_object" "archive" {
  for_each = {
    for cf in local.cloud_functions :
    cf.name => cf
  }
  name   = "${each.value.name}.zip"
  bucket = each.value.bucket_name
  source = each.value.bucket_path
}

#create cloud function
resource "google_cloudfunctions_function" "function" {
  depends_on = [google_storage_bucket_object.archive]
  for_each = {
    for cf in local.cloud_functions :
    cf.name => cf
  }
  name                  = each.value.name
  description           = each.value.description
  project               = var.project_id
  region                = each.value.region
  entry_point           = each.value.entrypoint
  runtime               = each.value.runtime
  available_memory_mb   = each.value.memmory
  trigger_http          = each.value.trigger_http
  ingress_settings      = each.value.ingress_set
  labels                = each.value.labels
  source_archive_bucket = each.value.bucket_name
  source_archive_object = "${each.value.name}.zip"
  timeout               = each.value.timeout
  service_account_email = each.value.sa_email
  dynamic "event_trigger" {
    for_each = range(try(each.value.event_trigger, null) != null ? 1 : 0)
    content {
      event_type = each.value.event_type_config
      resource   = each.value.event_resource_config
      failure_policy {
        retry = each.value.failure_policy
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

