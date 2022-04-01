module "datasets" {
  source = "../../../modules/bq-dataset"
  project_id = var.project_id
  config_path = var.config_path
}
