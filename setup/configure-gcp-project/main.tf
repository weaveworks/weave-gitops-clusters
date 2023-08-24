terraform {
  required_version = "= 1.3.6"

  backend "gcs" {
    bucket = "weave-gitops-clusters-tf-state"
    prefix = "weave-gitops-clusters/setup/configure-gcp-project"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.12.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = "europe-west1"
}
