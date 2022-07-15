# Creating a new cluster

If you are deploying a cluster in a new GKE project you need to enable the
[OAuth consent screen](https://cloud.google.com/iap/docs/enabling-kubernetes-howto#enabling_iap)
and get the credentials.

1. `cd` to the terrafrom directory for the type of cluster you want (gke or eks)
2. Add a new `vars/<cluster-name>.tfvars` file and update the variables for it
3. Run `make tf-create-workspace`
4. Add the flux cluster config to `./k8s/clusters/<cluster-name>`
5. Push & merge all your changes (otherwise `flux bootstrap` may nuke them)
6. Run `make install-all` (this will ask you if you want to create the terraform resources then install flux)
7. If you're creating a GKE cluster:
  1. Pull changes (flux will have bootstrapped stuff)
  2. Add the following to `./k8s/clusters/<cluster-name>/flux-system/kustomization.yaml`:
      ```yaml
      # Allow the image reflector to access artifact registry cf.
      # https://fluxcd.io/docs/guides/image-update/#using-native-gcp-gcr-auto-login
      patches:
      - target:
          version: v1
          group: apps
          kind: Deployment
          name: image-reflector-controller
          namespace: flux-system
        patch: |-
          - op: add
            path: /spec/template/spec/containers/0/args/-
            value: --gcp-autologin-for-gcr
      patchesStrategicMerge:
      - |-
        apiVersion: v1
        kind: ServiceAccount
        metadata:
          name: image-reflector-controller
          namespace: flux-system
          annotations:
            # This value will be output by terraform as well
            iam.gke.io/gcp-service-account: image-rc-<cluster-name>@weave-gitops-clusters.iam.gserviceaccount.com
      ```
  3. commit and push these changes
