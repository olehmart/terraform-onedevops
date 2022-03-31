module "datasets" {
  source = "../../../modules/bq-dataset"
  project_id = var.project_id
  config = var.config
}
