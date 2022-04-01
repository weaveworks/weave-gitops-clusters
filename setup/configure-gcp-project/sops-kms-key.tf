#
# Create a key and associated service account that we can use to
# encrypt secrets with sops
#

# Create the key
resource "google_kms_key_ring" "weave_gitops" {
  name     = local.name
  location = "global"
}

resource "google_kms_crypto_key" "weave_gitops_sops" {
  name     = "${local.name}-sops"
  labels   = local.common_labels
  key_ring = google_kms_key_ring.weave_gitops.id

  purpose = "ENCRYPT_DECRYPT"

  depends_on = [google_project_service.enabled]
}

# Create the service account we can use in k8s. We're creating it here because
# all the clusters will use the same key (as the secret they're currently
# expected to access is the OAuth client secret which is per-project)
resource "google_service_account" "sops_decrypter" {
  project = var.project_id
  # manky short name because account_id has a max length of 30
  account_id   = "sops-decrypter-${local.name}"
  display_name = "Shared SA for decrypting sops secrets via flux. Managed by terraform."
}

resource "google_project_iam_member" "sops_decrypter_artifact_registry" {
  project = var.project_id
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member  = "serviceAccount:${google_service_account.sops_decrypter.email}"
}

resource "google_service_account_iam_member" "sops_decrypter_workload_identity_user" {
  service_account_id = google_service_account.sops_decrypter.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[flux-system/kustomize-controller]"
}
