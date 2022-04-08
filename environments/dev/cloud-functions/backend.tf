terraform {
  backend "gcs" {
    bucket  = "terraform-state-sapient-mariner"
    prefix  = "environments/dev/cloud-functions"
  }
}
