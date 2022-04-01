variable "project_id" {
  type        = string
  description = "Project Id to deploy into"
  default     = "weave-gitops-clusters"
}

variable "oauth_support_email" {
  type        = string
  description = "Email required for setting up the oAuth consent screen"
  # FIXME this should be a group email but it has to be one I have admin on
  default = "sam.cook@weave.works"
}
