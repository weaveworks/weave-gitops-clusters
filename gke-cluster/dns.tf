#
# Create a DNS hosted zone that we can use and a service account that the
# external-dns controller can assume to write records.
#

data "google_dns_managed_zone" "wego-gke" {
  name = "weave-gitops-clusters" # must match what's configured in setup/configure-gcp-project/dns.tf
}

# Create the hosted zone
resource "google_dns_managed_zone" "delegated" {
  name        = local.name
  dns_name    = "${var.dns_short_name}.${data.google_dns_managed_zone.wego-gke.dns_name}"
  description = "Delegated zone for the ${local.name} cluster. Managed by Terraform."
}

# Add our delegated zone's NS records to the parent
resource "google_dns_record_set" "delegated" {
  name         = google_dns_managed_zone.delegated.dns_name
  managed_zone = data.google_dns_managed_zone.wego-gke.name
  type         = "NS"
  ttl          = 300 # seconds
  rrdatas      = google_dns_managed_zone.delegated.name_servers
}

# Create the service account
resource "google_service_account" "external-dns" {
  project = var.project_id
  # manky short name because account_id has a max length of 30
  account_id   = "dns-${local.name}"
  display_name = "External DNS controller in cluster ${local.name}. Managed by terraform."
}

resource "google_project_iam_member" "external-dns-admin" {
  project = var.project_id
  role    = "roles/dns.admin"
  member  = "serviceAccount:${google_service_account.external-dns.email}"
}

resource "google_service_account_iam_member" "external-dns-workload-identity-user" {
  service_account_id = google_service_account.external-dns.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[kube-system/external-dns]"
}
