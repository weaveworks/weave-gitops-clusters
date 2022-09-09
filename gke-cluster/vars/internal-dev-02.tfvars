region         = "europe-west1"
dns_short_name = "internal-dev-02"
node_pool_config = {
  machine_type = "e2-standard-2"
  min_count    = 1
  max_count    = 5
  disk_size_gb = 30
}
