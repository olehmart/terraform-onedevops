module "cloud-build-trigger" {
  source      = "../../../modules/cloud-build-trigger"
  project_id  = var.project_id
  config_path = var.config_path
}
