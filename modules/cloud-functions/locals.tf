locals {
  config = yamldecode(file(var.config_path))
  cloud_functions = flatten([
    for cf_purpose, cf_props in local.config :
    [
      {
        name                          = cf_props["name"]
        region                        = cf_props["region"]
        bucket_name                   = cf_props["bucket"]["name"]
        bucket_path                   = lookup(cf_props["bucket"], "path", "")
        entrypoint                    = lookup(cf_props, "entrypoint", "")
        runtime                       = cf_props["runtime"]
        available_memory_mb           = lookup(cf_props, "available_memory_mb", "")
        trigger_http                  = lookup(cf_props, "trigger_http", null)
        description                   = lookup(cf_props, "description", "")
        ingress_settings              = lookup(cf_props, "ingress_settings", "")
        labels                        = lookup(cf_props, "labels", {})
        environment_variables         = lookup(cf_props, "environment_variables", {})
        service_account_email         = lookup(cf_props, "service_account_email", "")
        event_trigger                 = lookup(cf_props, "event_trigger", null)
        event_trigger_event_type      = lookup(try(cf_props["event_trigger"], {}), "event_type", "")
        event_trigger_resource        = lookup(try(cf_props["event_trigger"], {}), "resource", "")
        event_trigger_failure_policy  = lookup(try(cf_props["event_trigger"], {}), "failure_policy", null)
        timeout                       = lookup(cf_props, "timeout", "")
        vpc_connector                 = lookup(cf_props, "vpc_connector", "")
        vpc_connector_egress_settings = lookup(cf_props, "vpc_connector_egress_settings", null)
        max_instances                 = lookup(cf_props, "max_instances", null)
        min_instances                 = lookup(cf_props, "min_instances", null)

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
  timestamp = formatdate("YYMMDDhhmmss", timestamp())
}

