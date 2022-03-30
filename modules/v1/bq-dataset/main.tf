resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = var.dataset_id
  friendly_name               = var.dataset_id
  description                 = try(var.description, "")
  location                    = var.location

  labels = try(var.labels, null)

  access {
    role          = "OWNER"
    user_by_email = var.owner_sa_email
  }
}
