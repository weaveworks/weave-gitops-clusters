# weave-gitops-clusters
Configuration for the staging k8s clusters used by weave-gitops.

## WARNING

The clusters created by this repo are for testing/staging purposes only. They
are not production-worthy.

## Repo layout

The bulk of the important configuration is in these two directories:
* [gke-cluster](gke-cluster/) -- create [Google GKE clusters](https://cloud.google.com/kubernetes-engine/)
* [eks-cluster](eks-cluster/) -- create [AWS EKS clusters](https://aws.amazon.com/eks/) [coming soon!]

The [setup](setup/) directory contains small bits of terraform for shared resources
(e.g. container registries, terraform state buckets). You probably don't need to
make changes here.

## Usage

Each directory contains a README describing how that section of the project
should be deployed/used.

### Tools

Required

* [Terraform](https://www.terraform.io/downloads)
* [gcloud](https://cloud.google.com/sdk/docs/install)
* [flux](https://fluxcd.io/)
* [sops](https://github.com/mozilla/sops)

Nice to have:

* [pre-commit hooks](https://pre-commit.com/)

### Sops

We use [sops](https://github.com/mozilla/sops) to encrypt secrets such that they
can be accessed by flux and turned into kubernetes secrets in the relevant
cluster.

The `.sops.yaml` file defines creation rules that will automatically encrypt
new files added to any directory that matches `k8s/secrets/gke-*`.

It is recommended that any files you decrypt you add a `*.dec` or `*.dec.*`
suffix to (e.g. `foo.dec.yaml`) so git will automatically ignore them.

```bash
# Create or update a secret
$ sops k8s/secrets/gke-europe-west1/new-secret.yaml
# Decrypt a secret to the terminal
$ sops -d k8s/secrets/gke-europe-west1/old-secret.yaml
# Decrypt a secret to a file
$ sops -d k8s/secrets/gke-europe-west1/old-secret.yaml > k8s/secrets/gke-europe-west1/old-secret.dec.yaml
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
