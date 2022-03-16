# weave-gitops-clusters
Configuration for the staging k8s clusters used by weave-gitops.

## Repo layout

The bulk of the important configuration is in these two directories:
* [gke](gke-cluster/) -- create [Google GKE clusters](https://cloud.google.com/kubernetes-engine/)
* [eks](eks-cluster/) -- create [AWS EKS clusters](https://aws.amazon.com/eks/)

The [setup](setup/) directory contains small bits of terraform for shared resources
(e.g. container registries, terraform state buckets). You probably don't need to
make changes here.

## Development

### Requirements

* [Terraform](https://www.terraform.io/downloads)
* [gcloud](https://cloud.google.com/sdk/docs/install)

### Running (gCloud)

```bash
$ gcloud auth application-default login
$ terraform plan  # Check the proposed changes
$ terraform apply # Actually make stuff
```

### Running (AWS)

```bash
$ gsts --aws-role-arn=arn:aws:iam::<account-id>:role/AdministratorAccess
$ terraform plan  # ... as before, run terraform.
$ terraform apply
```

### Pre-commit hooks [optional]

This repository uses [pre-commit hooks](https://pre-commit.com/)
to run various linting tasks. They pre-commit program can be installed via
`pip` or `brew`:

```bash
$ pip install pre-commit
# or
$ brew install pre-commit
```

The hooks themselves are then added to your `.git/hooks` directory:
```bash
$ pre-commit install
```

The first time the hooks run will take a little longer than usual as the scripts
get installed.

They can be run manually:
```bash
$ pre-commit run --all
```

or they will run automatically whenever you run commit, e.g.:
```bash
$ git commit -m "Frobulate the changes"
Trim Trailing Whitespace.................................................Passed
Fix End of Files.........................................................Passed
Check Yaml...............................................................Passed
Check for added large files..............................................Passed
Terraform fmt........................................(no files to check)Skipped
Terraform validate...................................(no files to check)Skipped
[setup eda4e7a] Frobulate the changes
 1 file changed, 42 insertions(+), 69 deletions(-)
 rewrite .pre-commit-config.yaml (64%)
```
