terraform {
  required_version = ">= 1.0.0"

  backend "gcs" {
    bucket = "weave-gitops-clusters-tf-state"
    prefix = "weave-gitops-clusters/setup/container-registry"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.12.0"
    }
  }
}

variable "project" {
  type        = string
  description = "Project Id to deploy into"
  default     = "weave-gitops-clusters"
}

provider "google" {
  project = var.project
  region  = "europe-west1"
}

resource "google_artifact_registry_repository" "weave_gitops" {
  # Because this is in beta we need to specify the provider as well as project & region
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/artifact_registry_repository
  provider = google-beta
  project  = var.project
  location = "europe-west1"

  repository_id = "weave-gitops"
  description   = "Private repo for branch builds of the weave-gitops docker images"
  format        = "DOCKER"

  labels = {
    creator    = "sam_cook"
    department = "engineering"
    purpose    = "terraform_state"
    team       = "frostbite"
  }
}
