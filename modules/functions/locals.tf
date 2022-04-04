locals {
  config = yamldecode(file(var.config_path))
  cf_props = flatten([
    for cf_purpose, cf_pr in local.config :
    [
      {
        name         = cf_pr["name"]
        src          = cf_pr["src"]
        runtime      = cf_pr["runtime"]
        memmory      = cf_pr["memmory"]
        trigger_http = cf_pr["trigger_http"]
        entrypoint   = cf_pr["entrypoint"]
        description  = cf_pr["description"]
      }
    ]
  ])
}
