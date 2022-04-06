variable "project_id" {
  type        = string
  description = "The Google project to deploy to"
  default     = "weave-gitops-clusters"
}

variable "region" {
  type        = string
  description = "Region to deploy to"
}

variable "zone_id" {
  type        = string
  description = "Which zone in the region tol use (e.g. 'a', 'b' etc.)"
  default     = "b" # Apparently europe-west1-a doesn't exist so use b which exists for both eu & us
}

variable "dns_short_name" {
  type        = string
  description = "Name for the hosted zone we'll create."
}

variable "subnet_config" {
  type = object({
    ip_range_base     = string
    ip_range_pods     = string
    ip_range_services = string
    ip_range_control  = string
  })
  description = "How to configure subnet IPs"
  default = {
    ip_range_base     = "10.0.0.0/16"
    ip_range_pods     = "10.1.0.0/16"
    ip_range_services = "10.2.0.0/16"
    # "The size of the RFC 1918 block for the cluster control plane must be /28." from
    # https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters#req_res_lim
    # (default is 10.0.0.0/16)
    ip_range_control = "10.3.0.0/28"
  }
}

variable "node_pool_config" {
  type = object({
    machine_type = string
    min_count    = number
    max_count    = number
    disk_size_gb = number
  })
  description = "Configuration for the node pool"
  default = {
    machine_type = "e2-medium"
    min_count    = 1
    max_count    = 5
    disk_size_gb = 30
  }
}
