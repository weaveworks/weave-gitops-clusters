module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version = " ~> 20"

  name       = local.name
  project_id = var.project_id

  # Region
  zones    = ["${var.region}-${var.zone_id}"]
  region   = var.region
  regional = false

  # Network
  network                = module.gcp-network.network_name
  subnetwork             = module.gcp-network.subnets_names[0]
  ip_range_pods          = local.pods_range_name
  ip_range_services      = local.services_range_name
  master_ipv4_cidr_block = var.subnet_config.ip_range_control

  # You'd think this would be true by default...
  enable_private_nodes = true

  # Grant service account 'artifactregistry.reader' & 'storage.objectViewer'
  grant_registry_access = true

  # Node config
  node_pools = [{
    name         = "${local.name}-pool"
    machine_type = var.node_pool_config.machine_type
    min_count    = var.node_pool_config.min_count
    max_count    = var.node_pool_config.max_count
    disk_size_gb = var.node_pool_config.disk_size_gb
    },
  ]
}
