locals {
  config = yamldecode(file(var.config_path))
  cloud_functions = flatten([
    for cf_purpose, cf_props in local.config :
    [
      {
        name                  = cf_props["name"]
        region                = cf_props["region"]
        bucket_name           = cf_props["bucket"]["name"]
        bucket_path           = cf_props["bucket"]["path"]
        entrypoint            = lookup(cf_props, "entrypoint", "")
        runtime               = cf_props["runtime"]
        memmory               = lookup(cf_props, "memmory", "")
        trigger_http          = lookup(cf_props, "trigger_http", "")
        description           = lookup(cf_props, "description", "")
        ingress_set           = lookup(cf_props, "ingress_set", "")
        labels                = lookup(cf_props, "labels", {})
        env_vars              = lookup(cf_props, "env_vars", "")
        sa_email              = lookup(cf_props, "sa_email", "")
        event_trigger         = lookup(cf_props, "event_trigger", null)
        event_type_config     = lookup(try(cf_props["event_trigger"], {}), "event_type", "")
        event_resource_config = lookup(try(cf_props["event_trigger"], {}), "resource", "")
        failure_policy        = lookup(try(cf_props["event_trigger"], {}), "failure_policy", "")
        timeout               = lookup(cf_props, "timeout", "")
      }
    ]
  ])
  cloud_functions_access = flatten([
    for cf_purpose, cf_props in local.config : [
      for cf_access_props in lookup(cf_props, "access", []) : [
        {
          name    = cf_props["name"]
          region  = cf_props["region"]
          role    = cf_access_props["role"]
          members = cf_access_props["members"]
        }
      ]
    ]
  ])
}

