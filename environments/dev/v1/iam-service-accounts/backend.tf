terraform {
  backend "gcs" {
    bucket  = "onedevops-tf-state"
    prefix  = "environments/dev/v1/ia-service-accounts"
  }
}