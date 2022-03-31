terraform {
  backend "gcs" {
    bucket  = "onedevops-tf-state"
    prefix  = "environments/dev/bq-datasets"
  }
}