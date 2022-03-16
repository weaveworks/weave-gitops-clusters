terraform {
  required_version = ">= 1.0.0"

  backend "gcs" {
    bucket = "weave-gitops-clusters-tf-state"
    prefix = "weave-gitops-clusters/gke-cluster"
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
  region  = var.region
}
