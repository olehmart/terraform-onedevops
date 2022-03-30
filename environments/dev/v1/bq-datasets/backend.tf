terraform {
  backend "gcs" {
    bucket  = "onedevops-tf-state"
    prefix  = "environments/dev/v1/bq-datasets"
  }
}