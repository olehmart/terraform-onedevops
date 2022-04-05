module "pubsub" {
  source      = "../../../modules/pubsub"
  project_id  = var.project_id
  config_path = var.config_path
}
