variable "project_id" {
  type = string
  description = "GCP project ID"
}

variable "dataset_id" {
  type = string
  description = "GCP BQ Dataset ID"
}

variable "location" {
  type = string
  description = "GCP location"
}

variable "owner_sa_email" {
  type = string
  description = "GCP IAM service account name"
}

variable "description" {
  type = string
  description = "Description of BQ dataset"
  default = ""
}

variable "labels" {
  type = map
  description = "Map of labels"
  default = {}
}
