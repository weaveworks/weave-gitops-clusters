variable "project_id" {
  type        = string
  description = "The Google project to deploy to"
  default     = "weave-gitops-clusters"
}

variable "region" {
  type        = string
  description = "Region to deploy to"
}

variable "subnet_config" {
  type = object({
    ip_range_base     = string
    ip_range_pods     = string
    ip_range_services = string
  })
  description = "How to create a subnet for this project"
  default = {
    ip_range_base     = "10.0.0.0/16"
    ip_range_pods     = "10.1.0.0/16"
    ip_range_services = "10.2.0.0/16"
  }
}
