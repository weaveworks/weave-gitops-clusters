locals {
  name = "${terraform.workspace}-gke"

  # Just make this easily setable
  pods_range_name     = "ip-range-pods"
  services_range_name = "ip-range-services"

  # Make sure we're in a known workspace
  allowed_workspaces = {
    internal-dev    = true
    europe-west1    = true
    us-central1     = true
    internal-dev-02 = true
    leaf-01         = true
    leaf-02         = true
  }
  is_allowed_workspace = local.allowed_workspaces[terraform.workspace]
}
