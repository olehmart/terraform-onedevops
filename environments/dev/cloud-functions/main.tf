module "functions" {
  source = "../../../modules/cloud-functions"
  project_id = var.project_id
  config_path = var.config_path
}
