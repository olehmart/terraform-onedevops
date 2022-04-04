module "gcs-bucket" {
  source      = "../../../modules/gcs-bucket"
  project_id  = var.project_id
  config_path = var.config_path
}
