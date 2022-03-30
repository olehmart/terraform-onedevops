resource "google_service_account" "service_account" {
  for_each = local.config
  account_id   = each.value.name
  display_name = each.value.name
}
