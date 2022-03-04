# Container Repository

Create a private repository that can host [gitops-server](https://github.com/weaveworks/weave-gitops/blob/v2-preview-1/gitops-server.dockerfile)
images that aren't yet ready for public use.

By creating this within google we simplify access to it from the GKE clusters
and don't pollute our public offerings.
