locals {
  config = yamldecode(file(var.config))
}