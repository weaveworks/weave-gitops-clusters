#
# Additional APIs
#

locals {
  enabled_apis = [
    "artifactregistry.googleapis.com", # enable docker registry
    "container.googleapis.com",        # enable kubernetes
    "iamcredentials.googleapis.com",   # enable OIDC service accounts
  ]
}

resource "google_project_service" "enabled" {
  for_each = toset(local.enabled_apis)

  service                    = each.value
  disable_dependent_services = true
}
