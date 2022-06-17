#
# Use a dedicated group to manage access to the project as we want to limit
# access to one or two people per team (so we can make sure they're
# appropriately trained etc.)
#

locals {
  project_owners_group = "gcp-weave-gitops-clusters-project-owners@weave.works"
}

resource "google_project_iam_member" "project_owners" {
  project = var.project_id
  role    = "roles/owner"
  member  = "group:${local.project_owners_group}"
}
