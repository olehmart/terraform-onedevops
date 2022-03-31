resource "google_bigquery_dataset" "dataset" {
  for_each = {
    for ds in local.datasets:
        join(":", [
          ds.location,
          ds.dataset_id,
          ]
        ) => ds
  }
  dataset_id                  = each.value.dataset_id
  friendly_name               = each.value.friendly_name
  description                 = each.value.description
  location                    = each.value.location

  labels = each.value.labels
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
  dataset_id    = each.value.dataset_id
  role          = each.value.role
  user_by_email = each.value.user
}
