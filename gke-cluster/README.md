# GKE Cluster

Pattern to produce simple [Google Kubernetes (GKE) clusters](https://cloud.google.com/kubernetes-engine).

## WARNING

The clusters created by this project are **not production worthy**. They create
[zonal clusters](https://cloud.google.com/kubernetes-engine/docs/concepts/types-of-clusters#zonal_clusters)
i.e. the control plane only exists in a single Google Zone, as does the nodes
for the node pool (which, by default there is one of).

## Creates

* Simple network
* GKE cluster
* Autoscaling node pool
* Installs Weave Gitops Core (via Flux)

## Usage

```bash
$ make ENV=<env> tf-plan
# ...
$ make ENV=<env> tf-apply
# ...
```

where `env` should match the name of the environment to be deployed and have a
corresponding `tfvars` file in `vars/` (once you've run a make command with
`ENV` set it should remember it by reading `.terraform/environment`).

## Workspaces

This uses [Terraform Workspaces](https://www.terraform.io/language/state/workspaces#using-workspaces)
to provide isolation between different environments.


To create a new workspace run:
```bash
$ make ENV=<new-env> tf-create-workspace
```

You'll need to update `locals.tf`'s `allowed_workspaces` list (otherwise you'll
get `Invalid index` errors) and add any further customisations to the newly
created `vars/<new-workspace-name>.tfvars` file.

### Workspace naming

Workspaces are currently named after the region they're deployed to. If multiple
workspaces are needed in the same region they can be created with some suffix.


## Notes

### Networking

Long term this project is intended to allow testing of multi-cluster
configurations. As part of testing the more hostile potential setups each
workspace creates its own VPC and subnet, i.e. assumes that the management
cluster is in an entirely separate network to its leaf cluster (this may need
to be pushed further to a separate project).
