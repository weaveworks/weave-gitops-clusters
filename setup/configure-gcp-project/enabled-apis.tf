#
# Additional APIs
#

locals {
  enabled_apis = [
    "artifactregistry.googleapis.com", # enable docker registry
    "container.googleapis.com",        # enable kubernetes
    # Required for github OIDC to work
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",            # this is enabled by default, I believe
    "iamcredentials.googleapis.com", # enable OIDC service accounts
    "sts.googleapis.com",
    # Required for identity-aware load balancers
    "iap.googleapis.com",
    # Cloud DNS
    "dns.googleapis.com",
    # Use KMS so we can encrypt secrets
    "cloudkms.googleapis.com",
  ]
}

resource "google_project_service" "enabled" {
  for_each = toset(local.enabled_apis)

  service                    = each.value
  disable_dependent_services = true
}
