#
# Create a service account that can be used by a github action to push images
# to the container registry
#

resource "google_service_account" "github_actions_service_account" {
  account_id   = "github-actions-service"
  display_name = "Github Actions container registry writer SA"
  description  = "Service account for use by Github actions for writing to the weave-gitops-clusters container registry"
  depends_on   = [google_project_service.enabled]
}

resource "google_project_iam_member" "project" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.github_actions_service_account.email}"
}

module "oidc" {
  version = "v3.0.0"
  source  = "terraform-google-modules/github-actions-runners/google//modules/gh-oidc"

  project_id        = var.project_id
  pool_id           = "github-actions-sa-pool"
  pool_display_name = "Github Actions Pool"
  provider_id       = "github-provider"
  # If we want to configure this with other repos we can change this to
  # reference 'repository_owner' and add that to the attribute mapping
  attribute_condition = "attribute.repository == 'weaveworks/weave-gitops'"
  sa_mapping = {
    (google_service_account.github_actions_service_account.account_id) = {
      sa_name   = google_service_account.github_actions_service_account.name
      attribute = "*"
    }
  }
}

output "google_service_account_email" {
  value = google_service_account.github_actions_service_account.email
}

output "workload_identity_provider" {
  value = module.oidc.provider_name
}
