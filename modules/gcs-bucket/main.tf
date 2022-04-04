resource "google_storage_bucket" "bucket" {
  for_each = {
    for bucket in local.buckets:
        join(":", [
          bucket.location,
          bucket.name,
          ]
        ) => bucket
  }
  project       = var.project_id
  name          = each.value.name
  location      = each.value.location
  force_destroy = each.value.force_destroy
  storage_class = each.value.storage_class
  dynamic "versioning" {
    for_each = range(try(each.value.versioning_enabled, null) != null ? 1 : 0)
    content {
      enabled = each.value.versioning_enabled
    }
  }
  labels = each.value.labels
  dynamic "logging" {
    for_each = range(try(each.value.logging, null) != null ? 1 : 0)
    content {
      log_bucket        = each.value.logging_bucket
      log_object_prefix = each.value.logging_object_prefix
    }
  }
  dynamic "encryption" {
    for_each = range(try(each.value.encryption, null) != null ? 1 : 0)
    content {
      default_kms_key_name = each.value.default_kms_key_name
    }
  }
}

resource "google_storage_bucket_iam_binding" "binding" {
  depends_on = [google_storage_bucket.bucket]
  for_each = {
    for bucket_access in local.buckets_access:
        join(":", [
          bucket_access.location,
          bucket_access.bucket,
          bucket_access.role
          ]
        ) => bucket_access
  }
  bucket  = each.value.bucket
  role    = each.value.role
  members = each.value.members
}
