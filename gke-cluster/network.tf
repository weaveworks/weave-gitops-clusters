module "gcp-network" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 5"
  project_id   = var.project_id
  network_name = local.name

  subnets = [{
    subnet_name           = local.name
    subnet_region         = var.region
    subnet_ip             = var.subnet_config.ip_range_base
    subnet_private_access = true
    }
  ]

  secondary_ranges = {
    "${local.name}" = [
      {
        range_name    = local.pods_range_name
        ip_cidr_range = var.subnet_config.ip_range_pods
      },
      {
        range_name    = local.services_range_name
        ip_cidr_range = var.subnet_config.ip_range_services
      },
    ]
  }
}

module "cloud_router_nat" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 0.4"
  project = var.project_id # Replace this with your project ID in quotes
  name    = local.name
  network = module.gcp-network.network_name
  region  = var.region

  nats = [{
    name = local.name
  }]
}

# Required for Istio to work on private GKE clusters
# https://istio.io/latest/docs/setup/platform-setup/gke
resource "google_compute_firewall" "istio" {
  project     = var.project_id
  name        = "gke-${module.gcp-network.network_name}-istio"
  network     = module.gcp-network.network_name
  description = "Allow Istio Pilot discovery validation webhook"
  direction   = "INGRESS"

  source_ranges = [module.gke.master_ipv4_cidr_block]

  allow {
    protocol = "tcp"
    ports    = ["15017"]
  }
}
