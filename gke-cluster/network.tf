module "gcp-network" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 5"
  project_id   = var.project_id
  network_name = local.name

  subnets = [{
    subnet_name   = local.name
    subnet_region = var.region
    subnet_ip     = var.subnet_config.ip_range_base
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
