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

