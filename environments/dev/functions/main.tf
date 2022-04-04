module "functions" {
  source = "../../../modules/functions"
  project_id = var.project_id
  config_path = var.config_path
}
