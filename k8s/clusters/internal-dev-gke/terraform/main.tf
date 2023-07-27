terraform {
  required_providers {
    github = {
      source = "integrations/github"
      version = "5.32.0"
    }
  }
}

variable "github_token" {}

provider "github" {
  token = var.github_token
}

data "github_repository" "weave_gitops_clusters" {
  full_name = "weaveworks/weave-gitops-clusters"
}

resource "github_repository_pull_request" "test" {
    base_repository = data.github_repository.weave_gitops_clusters.name
    base_ref        = "main"
    head_ref        = "yiannistri-patch-1"
    title           = "feat: Adding more flags"
    body            = "Added new config map"
}
