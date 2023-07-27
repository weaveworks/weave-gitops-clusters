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

resource "github_issue" "test" {
  repository       = data.github_repository.weave_gitops_clusters.name
  title            = "My issue title"
  body             = "The body of my issue"
}
