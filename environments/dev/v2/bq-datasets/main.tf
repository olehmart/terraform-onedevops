module "datasets" {
  source = "../../../../modules/v2/bq-dataset"
  project_id = var.project_id
  config = var.config
}
