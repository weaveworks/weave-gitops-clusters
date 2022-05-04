#
# Service account that we can get the creds of and give them to
# enterprise/clusterctl for basic CAPI operations.
#

resource "google_service_account" "enterprise-capi" {
  project = var.project_id
  # manky short name because account_id has a max length of 30
  account_id   = "ent-capi-${local.name}"
  display_name = "Used by enterprise for CAPI ops in ${local.name}. Managed by terraform."
}

resource "google_project_iam_member" "enterprise-capi-role" {
  project = var.project_id
  # Initially readonly until we figure out what we'd like this to be able to do.
  role   = "roles/container.clusterViewer"
  member = "serviceAccount:${google_service_account.enterprise-capi.email}"
}

resource "google_service_account_key" "enterprise-capi" {
  service_account_id = google_service_account.enterprise-capi.name
}

resource "local_file" "enterprise-capi-creds" {
  content  = google_service_account_key.enterprise-capi.private_key
  filename = "${path.module}/sa-keys/enterprise-capi-${terraform.workspace}.json"
}
