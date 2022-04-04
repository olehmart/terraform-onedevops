locals {
  config = yamldecode(file(var.config_path))

  buckets = flatten([
    for bucket_purpose, bucket_props in local.config :
          [
            {
              name = bucket_props["name"]
              location = bucket_props["location"]
              force_destroy = lookup(bucket_props, "force_destroy", true)
              storage_class = lookup(bucket_props, "storage_class", "STANDARD")
              versioning_enabled = lookup(bucket_props, "versioning_enabled", false)
              labels = lookup(bucket_props, "labels", {})
              logging_bucket = lookup(try(bucket_props["logging"], {}), "log_bucket", "")
              logging_object_prefix = lookup(try(bucket_props["logging"], {}), "log_object_prefix", "")
              default_kms_key_name = lookup(try(bucket_props["encryption"], {}), "default_kms_key_name", "")
          }
          ]
  ])

  buckets_access = flatten([
    for bucket_purpose, bucket_props in local.config : [
      for access_props in lookup(bucket_props, "access", []) : [
        {
          bucket   = bucket_props["name"]
          location = bucket_props["location"]
          role     = access_props["role"]
          members  = access_props["members"]
        }
      ]
    ]
  ])
}
