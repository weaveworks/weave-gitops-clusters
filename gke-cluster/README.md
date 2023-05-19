# GKE Cluster

Pattern to produce simple [Google Kubernetes (GKE) clusters](https://cloud.google.com/kubernetes-engine).

## WARNING

The clusters created by this project are **not production worthy**. They create
[zonal clusters](https://cloud.google.com/kubernetes-engine/docs/concepts/types-of-clusters#zonal_clusters)
i.e. the control plane only exists in a single Google Zone, as does the nodes
for the node pool (which, by default there is one of).

<!--
To update the TOC, install https://github.com/kubernetes-sigs/mdtoc
and run: mdtoc -inplace gke-cluster/README.md
-->

<!-- toc -->
- [Creates](#creates)
- [Requirements](#requirements)
- [Usage](#usage)
- [Workspaces](#workspaces)
  - [Workspace naming](#workspace-naming)
- [Flux bootstrapping](#flux-bootstrapping)
- [Notes](#notes)
  - [Networking](#networking)
- [Using Weave GitOps on the cluster](#using-weave-gitops-on-the-cluster)
  - [Access](#access)
  - [Reporting bugs found the GKE cluster](#reporting-bugs-found-the-gke-cluster)
- [Connect a leaf cluster](#connect-a-leaf-cluster)
<!-- /toc -->

## Creates

* Simple network
* GKE cluster
* Autoscaling node pool
* Installs Weave Gitops Core (via Flux)
* DNS hosted zone
* Various service accounts

## Requirements

- You are part of the group [gcp-weave-gitops-clusters-project-owners](https://console.cloud.google.com/iam-admin/groups/0147n2zr1jupgmu?orgonly=true&organizationId=36144081350&supportedpurview=organizationId). 
Request [joining via corp](https://github.com/weaveworks/corp/issues/2980)

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

## Flux bootstrapping

Before bootstrapping, make sure to export the GitHub PAT token for the `weaveworksbot`.  The token is available in 1password.

```bash
export GITHUB_TOKEN="<weaveworksbot token>"
make flux-bootstrap
```

You might find the following error

```

CRITICAL: ACTION REQUIRED: gke-gcloud-auth-plugin, which is needed for continued use of kubectl, was not found or is not executable. 
Install gke-gcloud-auth-plugin for use with kubectl by following https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke
```

That you fix via `gcloud components install gke-gcloud-auth-plugin`

if you are using `flux v0.33.0` you might hit [this issue](https://github.com/fluxcd/flux2/issues/3065), so just use a previous
version to bootstrap. for example `0.32.0`

## Notes

### Networking

Long term this project is intended to allow testing of multi-cluster
configurations. As part of testing the more hostile potential setups each
workspace creates its own VPC and subnet, i.e. assumes that the management
cluster is in an entirely separate network to its leaf cluster (this may need
to be pushed further to a separate project).

## Using Weave GitOps on the cluster

### Access

The Weave GitOps UI should be visible [here](https://gitops.euw1.wego-gke.weave.works).

The username and password can be found in 1password under `wego-app-staging`.
Contact [corp-it](https://github.com/weaveworks/corp/issues) if you do not have access to this.

### Reporting bugs found the GKE cluster

If you find a bug, complete **as much of the issue template as possible**.
For the `Weave GitOps Version` field, provide the tag of the image which was
deployed at the time you noticed the bug. This can be found in [this file](https://github.com/weaveworks/weave-gitops-clusters/blob/main/k8s/apps/base/weave-gitops-app/release.yaml)
under `spec.chart.values.image.tag`.

Logs for the `weave-gitops-app` deployment can be found [here](https://console.cloud.google.com/kubernetes/deployment/europe-west1-b/europe-west1-gke/flux-system/weave-gitops-app/logs?project=weave-gitops-clusters&pli=1).
If you cannot see that page, contact [corp-it](https://github.com/weaveworks/corp/issues).

## Connect a leaf cluster

Now that you have provisioned your cluster, in the case of playing the role of a leaf cluster, you might
want to connect it to a mangement clusters. You could read [how to connect a leaf cluster](../docs/connect-leaf-cluster.md).
