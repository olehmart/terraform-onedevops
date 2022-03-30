module "datasets" {
  source = "../../../../modules/v1/bq-dataset"
  for_each = var.datasets
  project_id = var.project_id
  dataset_id = each.key
  owner_sa_email = each.value.owner_sa_email
  location = each.value.location
  labels = try(each.value.labels, {})
  description = try(each.value.description, "")
}