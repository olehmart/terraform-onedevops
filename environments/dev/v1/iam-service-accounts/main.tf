module "iam_service_accounts" {
  count = length(var.iam_service_accounts)
  source = "../../../../modules/v1/iam-service-account"
  sa_name = var.iam_service_accounts[count.index]
  project_id = var.project_id
}