output "dns_ns" {
  value       = google_dns_managed_zone.gke.name_servers
  description = "NS records for the GKE hosted zone"
}
