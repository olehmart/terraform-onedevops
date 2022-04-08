locals {
  config = yamldecode(file(var.config_path))
  email_suffix = "${var.project_id}.iam.gserviceaccount.com"
  sa_config_project_roles = flatten([
    for sa_purpose, sa_props in local.config: [
      for role_name in lookup(sa_props, "project_roles", []) : {
        sa_name = sa_props["name"]
        role_name = role_name
        sa_email = join("@", [sa_props["name"], local.email_suffix])
  }
  ]
  ])
  sa_config_iam_roles = flatten([
    for sa_purpose, sa_props in local.config :
      [
        for role_name, members in lookup(sa_props, "iam_roles", []) : {
          sa_name = sa_props["name"]
          role_name = role_name
          sa_email = join("@", [sa_props["name"], local.email_suffix])
          members = [
            for member in members: length(regexall(".*[@[/:{~!].*", member)) > 0 ? join(":", ["serviceAccount", member]) : join("@", [
              member == "SELF" ? join(":", ["serviceAccount", sa_props["name"]]) : join(":", ["serviceAccount", member]),
              local.email_suffix])
          ]
        }
      ]
  ])
}
