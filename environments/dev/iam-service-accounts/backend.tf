terraform {
  backend "gcs" {
    bucket  = "terraform-state-sapient-mariner"
    prefix  = "environments/dev/iam-service-accounts"
  }
}
