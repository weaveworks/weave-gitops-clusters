# Configure GCP project

Does the ground work of getting the project the k8s clusters will be created in
to a known state. Specifically:

* Enable required APIs:
  - Artifact registry
  - iamcredentials
* Create an artifact registry we can use for docker images
* Create a service account that can be accessed by Github Actions (via OIDC)
