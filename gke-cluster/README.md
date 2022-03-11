# GKE Cluster

Pattern to produce simple [Google Kubernetes (GKE) clusters](https://cloud.google.com/kubernetes-engine).

## Creates

* Simple network
* GKE cluster
* Autoscaling node pool
* Installs Flux

## Workspaces

This uses [Terraform Workspaces](https://www.terraform.io/language/state/workspaces#using-workspaces)
to provide isolation between different environments. To change workspace use:

```bash
$ terraform workspace select <worksapce-name>
# ....
```

If you need to create a new workspace:

1. Add it to `allowed_workspaces` in [`locals.tf`](locals.tf)
2. Create it:
    ```bash
    $ terraform workspace new <worksapce-name>
    ```

Workspaces are currently named after the region they're deployed to. If multiple
workspaces are needed in the same region they can be created with some suffix.


## Notes

### Networking

Long term this project is intended to allow testing of multi-cluster
configurations. As part of testing the more hostile potential setups each
workspace creates its own VPC and subnet, i.e. assumes that the management
cluster is in an entirely separate network to its leaf cluster (this may need
to be pushed further to a separate project).
