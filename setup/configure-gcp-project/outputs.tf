output "dns_ns" {
  value       = google_dns_managed_zone.gke.name_servers
  description = "NS records for the GKE hosted zone"
}

output "sops_key_location" {
  value       = "${google_kms_key_ring.weave_gitops.id}/cryptoKeys/${google_kms_crypto_key.weave_gitops_sops.name}"
  description = "ID of the key in a form sops likes"
}

output "sops_service_account_email" {
  value       = google_service_account.sops_decrypter.email
  description = "Email used to annotate the kubernetes service account"
}
