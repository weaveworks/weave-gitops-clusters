locals {

  # Make sure we're in a known workspace
  allowed_workspaces = {
    europe-west1 = true
  }
  is_allowed_workspace = local.allowed_workspaces[terraform.workspace]
}
