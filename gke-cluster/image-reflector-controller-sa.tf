#
# Create a GCP Service account that can be used by the image-reflector-controller
# to read the state of the artifact registry
#

resource "google_service_account" "image-reflector-controller" {
  project = var.project_id
  # manky short name because account_id has a max length of 30
  account_id   = "image-rc-${local.name}"
  display_name = "Image reflector controller in cluster ${local.name}. Managed by terraform."
}

resource "google_project_iam_member" "image-reflector-controller-artifact-registry" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.image-reflector-controller.email}"
}

resource "google_service_account_iam_member" "image-reflector-controller-workload-identity-user" {
  service_account_id = google_service_account.image-reflector-controller.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[flux-system/image-reflector-controller]"
}
