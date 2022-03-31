variable "project_id" {
  type = string
  description = "GCP project ID"
}
variable "config_path" {
  type = string
  description = "YAML config path for IAM service accounts configuration"
}
variable "sleep_after_sa_creation" {
  type = string
  default = "10s"
  description = "Timeout to wait for IAM Service account creation"
}
