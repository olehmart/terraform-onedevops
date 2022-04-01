resource "google_bigquery_dataset" "dataset" {
  for_each = {
    for ds in local.datasets:
        join(":", [
          ds.location,
          ds.dataset_id,
          ]
        ) => ds
  }
  project = var.project_id
  dataset_id                  = each.value.dataset_id
  friendly_name               = each.value.friendly_name
  description                 = each.value.description
  location                    = each.value.location

  labels = each.value.labels

  delete_contents_on_destroy = each.value.delete_contents_on_destroy
  default_encryption_configuration {
    kms_key_name = each.value.kms_key_name
  }
}

resource "google_bigquery_dataset_access" "access" {
  depends_on = [google_bigquery_dataset.dataset]
  for_each = {
    for ds_access in local.dataset_access_configurations:
        join(":", [
          ds_access.location,
          ds_access.dataset_id,
          ds_access.user,
          ds_access.role,
          ]
        ) => ds_access
  }
  project = var.project_id
  dataset_id    = each.value.dataset_id
  role          = each.value.role
  user_by_email = each.value.user
}

resource "google_bigquery_table" "table" {
  depends_on = [google_bigquery_dataset.dataset]
  for_each = {
    for ds_table in local.dataset_table_configurations:
        join(":", [
          ds_table.location,
          ds_table.dataset_id,
          ds_table.table_id,
          ]
        ) => ds_table
  }
  project = var.project_id
  dataset_id = each.value.dataset_id
  table_id   = each.value.table_id

  labels = each.value.labels

  schema = each.value.schema
  deletion_protection = each.value.deletion_protection
}
