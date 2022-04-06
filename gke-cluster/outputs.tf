output "image-reflector-controller-sa-account-name" {
  value       = google_service_account.image-reflector-controller.email
  description = "Service account email for the Image Reflector Controller"
}

output "external-dns-sa-account-name" {
  value       = google_service_account.external-dns.email
  description = "Service account email for the External DNS"
}
