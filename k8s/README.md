# k8s

This holds the flux configuration for the clusters

* [`apps`](./apps) this holds application configuration. e.g for [weave-gitops-app](https://github.com/weaveworks/weave-gitops)
* [`clusters`](./clusters) entry point for flux, mostly un-modified
* [`infrastructure`](./infrastructure) covers flux sources and supporting applications
* [`secrets`](./secrets) per cluster sops secrets
