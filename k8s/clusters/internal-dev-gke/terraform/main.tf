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

resource "github_repository" "example" {
  name        = "example"
  description = "My awesome new repo"

  private = true
}
