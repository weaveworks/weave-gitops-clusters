resource "google_artifact_registry_repository" "weave_gitops" {
  # Because this is in beta we need to specify the provider as well as project & region
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/artifact_registry_repository
  provider = google-beta
  project  = var.project_id
  location = "europe-west1"

  repository_id = local.name
  description   = "Private repo for branch builds of the weave-gitops docker images"
  format        = "DOCKER"

  labels = local.common_labels

  depends_on = [google_project_service.enabled]
}
