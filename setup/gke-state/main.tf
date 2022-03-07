terraform {
  backend "local" {}

  required_version = ">= 1.0.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.12.0"
    }
  }
}

provider "google" {
  project = "586119081318" #  weave-gitops-clusters
  region  = "europe-west1"
}

resource "google_storage_bucket" "terraform_state" {
  name     = "weave-gitops-clusters-tf-state"
  location = "EUROPE-WEST1"

  # Disable per-object ACLs
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  labels = {
    creator    = "sam_cook"
    department = "engineering"
    purpose    = "terraform_state"
    team       = "frostbite"
  }
}
