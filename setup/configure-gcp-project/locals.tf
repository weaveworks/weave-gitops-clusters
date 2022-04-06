locals {
  name = "weave-gitops"

  common_labels = {
    creator    = "sam_cook"
    department = "engineering"
    purpose    = "staging"
    team       = "frostbite"
    repo       = "weave-gitops-clusters"
  }
}
