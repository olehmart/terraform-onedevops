resource "google_storage_bucket" "bucket" {
  for_each = local.config
  name     = each.value.name
  location = each.value.name
}

resource "google_storage_bucket_object" "archive" {
  depends_on = [google_storage_bucket.bucket]
  for_each = {
    for sc in local.cf_props :
    join(":", [
      sc.src,
      sc.name,
      ]
    ) => sc
  }
  name   = "${each.value.name}.zip}"
  bucket = each.value.name
  source = each.value.src
}

resource "google_cloudfunctions_function" "function" {
  depends_on = [google_storage_bucket_object.archive]
  for_each = {
    for cf in local.cf_props :
    join(":", [
      cf.name,
      cf.runtime,
      cf.description,
      cf.entrypoint,
      cf.trigger_http,
      cf.memmory,
      ]
    ) => cf
  }
  name                  = each.value.name
  description           = each.value.description
  runtime               = each.value.runtime
  available_memory_mb   = each.value.memmory
  source_archive_bucket = each.value.name
  source_archive_object = each.value.name
  trigger_http          = each.value.trigger_http
  entry_point           = each.value.entrypoint
}

# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker" {
  depends_on     = [google_cloudfunctions_function.function]
  for_each       = local.config
  project        = var.project_id
  region         = var.region
  cloud_function = each.value.name
  role           = "roles/cloudfunctions.invoker"
  member         = "allUsers"
}
