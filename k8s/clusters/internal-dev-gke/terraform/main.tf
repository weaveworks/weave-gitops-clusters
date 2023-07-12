terraform {
  required_providers {
    github = {
      source = "integrations/github"
      version = "5.30.1"
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
  repository       = github_repository.weave_gitops_clusters.name
  title            = "My issue title"
  body             = "The body of my issue"
}
