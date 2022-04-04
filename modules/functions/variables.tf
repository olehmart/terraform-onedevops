variable "project_id" {
  type        = string
  description = "GCP project ID"
}
variable "config_path" {
  type        = string
  description = "YAML config path for cloud functions creation"
}
variable "region" {
  description = "(Required) Region of function."
  default     = "us-central1"
  type        = string
}
