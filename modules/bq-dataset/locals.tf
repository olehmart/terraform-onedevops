locals {
  config = yamldecode(file(var.config_path))

  datasets = flatten([
    for ds_purpose, ds_props in local.config :
          [
            {
              dataset_id = ds_props["dataset_id"]
              friendly_name = lookup(ds_props, "friendly_name", ds_props["dataset_id"])
              description = lookup(ds_props, "description", "")
              location = ds_props["location"]
              labels = lookup(ds_props, "labels", {})
              delete_contents_on_destroy = lookup(ds_props, "delete_contents_on_destroy", true)
              kms_key_name = lookup(ds_props, "kms_key_name", "")
          }
          ]
  ])
  dataset_access_configurations = flatten([
    for ds_purpose, ds_props in local.config : [
      for access_props in lookup(ds_props, "access", []) : [
        {
          dataset_id = ds_props["dataset_id"]
          location = ds_props["location"]
          role = access_props["role"]
          user = access_props["user"]
        }
      ]
    ]
  ])
  dataset_table_configurations = flatten([
    for ds_purpose, ds_props in local.config : [
      for table_props in lookup(ds_props, "tables", []) : [
        {
          dataset_id = ds_props["dataset_id"]
          location = ds_props["location"]
          table_id = table_props["table_id"]
          labels = lookup(table_props, "labels", {})
          schema = try(file(table_props["schema_file_path"]), "")
          deletion_protection = lookup(table_props, "deletion_protection", false)
        }
      ]
    ]
  ])
}
