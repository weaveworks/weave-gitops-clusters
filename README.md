# weave-gitops-clusters
Configuration for the staging k8s clusters used by weave-gitops.

## Repo layout

The bulk of the important configuration is in these two directories:
* [gke](gke/) -- create [Google GKE clusters](https://cloud.google.com/kubernetes-engine/)
* [eks](eks/) -- create [AWS EKS clusters](https://aws.amazon.com/eks/)

The [setup](setup/) directory contains small bits of terraform for shared resources
(e.g. container registries, terraform state buckets). You probably don't need to
make changes here.
