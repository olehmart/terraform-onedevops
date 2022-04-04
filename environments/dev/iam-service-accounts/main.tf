module "iam-service-account" {
  source      = "../../../modules/iam-service-account"
  project_id  = var.project_id
  config_path = var.config_path
}
