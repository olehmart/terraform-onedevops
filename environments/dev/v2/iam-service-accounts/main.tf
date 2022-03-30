module "datasets" {
  source = "../../../../modules/v2/iam-service-account"
  project_id = var.project_id
  config = var.config
}
