output "image-reflector-controller-sa-account-name" {
  value       = google_service_account.image-reflector-controller.email
  description = "Service account email for the Image Reflector Controller"
}
