# Create a managed zone to host all of our GKE clusters

resource "google_dns_managed_zone" "gke" {
  name        = "${local.name}-clusters"
  dns_name    = "wego-gke.weave.works."
  description = "Hosts all GKE based weave-gitops-clusters"
  labels      = local.common_labels
}
