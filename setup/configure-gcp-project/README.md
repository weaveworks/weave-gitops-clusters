# Configure GCP project

Does the ground work of getting the project the k8s clusters will be created in
to a known state. Specifically:

* Enable required APIs:
  - [Artifact registry](https://console.cloud.google.com/apis/library/artifactregistry.googleapis.com)
  - [IAM Credentials](https://console.cloud.google.com/apis/library/iamcredentials.googleapis.com)
  - [Kubernetes](https://console.cloud.google.com/apis/library/container.googleapis.com)
* Create an artifact registry we can use for docker images
* Create a service account that can be accessed by Github Actions (via OIDC)

## Prerequisites

- Terraform v1.3.6

## Bootstrap

**Only required on first deployment, you likely don't need to do this!**

Initially, you need to manually create an oAuth consent page and get the credentials
[follow this guide](https://cloud.google.com/iap/docs/enabling-kubernetes-howto#enabling_iap)

## Access control

Must have `Owner` on the project, to permit writing to the Terraform state bucket and to IAM/IAP.

```shell
$ gcloud --project=weave-gitops-clusters auth application-default login
Your browser has been opened to visit:

    https://accounts.google.com/o/oauth2/auth?response_type=code&client_id=<redacted>

Opening in existing browser session.

Credentials saved to file: [/home/username/.config/gcloud/application_default_credentials.json]

These credentials will be used by any library that requests Application Default Credentials (ADC).

Quota project "weave-gitops-clusters" was added to ADC which can be used by Google client libraries for billing and quota. Note that some services may still bill the project owning the resource.
```
