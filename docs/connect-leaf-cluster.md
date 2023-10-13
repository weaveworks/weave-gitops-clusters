# Connect a leaf cluster to enterprise

You want to connect an existing kube cluster to Weave Gitops Enterprise via its management cluster.

## Requirements

- You have a leaf cluster. For this guide we will be using [leaf-01](../gke-cluster/vars/leaf-01.tfvars)
- You have a management cluster. For this guide we will be using [internal-dev](../gke-cluster/vars/internal-dev.tfvars)

## Connect leaf cluster to management cluster
### Step 1 - add base config to leaf cluster
For convenience and repeatability, there is a global [leaf cluster config](../k8s/config/leaf-cluster/) that can be added to the cluster directory for the leaf cluster (ie `k8s/clusters/leaf-01-gke`).  The config will look something like this:

```yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: leaf-cluster-config
  namespace: flux-system
spec:
  interval: 10m0s
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: ./k8s/config/leaf-cluster
  prune: true
  validation: client
  postBuild:
    substitute:
      clusterName: leaf-01
```

This will create all the necessary service accounts, tokens, and role bindings necessary for the leaf cluster and management cluster to interact with each other.

### Step 2 - add leaf cluster to management cluster
First create a sops encoded leaf kubeconfig and add it to the management clusters `k8s/secrets` directory
```bash
export CLUSTER_NAME=leaf-01
CA_CERTIFICATE_DATA=<base64-encoded-cert> \
ENDPOINT=<control-plane-ip-address> \
TOKEN=<token> ./k8s/config/leaf-cluster/create-kubeconfig-secret.sh > k8s/secrets/internal-dev-gke/$CLUSTER_NAME-kubeconfig.yaml
sops -e -i k8s/secrets/internal-dev-gke/$CLUSTER_NAME-kubeconfig.yaml
```

Then create a `clusters` directory under the the management clusters `k8s/clusters` directory
```bash
mkdir -p k8s/clusters/internal-dev-gke/clusters
```
and create a clusters kustomization under the management cluster
```yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: clusters
  namespace: flux-system
spec:
  interval: 10m0s
  dependsOn:
    - name: cluster-secrets
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: ./k8s/clusters/internal-dev-gke/clusters
  prune: true
  validation: client
```
> Don't forget to update the `kustomization.yaml` to include the `clusters.yaml` resource

Now just add the GitopsCluster yaml definition to the management cluster's `clusters` directory
```yaml
apiVersion: gitops.weave.works/v1alpha1
kind: GitopsCluster
metadata:
  name: dev
  namespace: flux-system
spec:
  secretRef:
    name: leaf-01-kubeconfig
```

Once all that is done and committed to `main` Flux should create all the necessary resources.  You can verify that everything is working via the cli or [in the ui](https://gitops.internal-dev.wego-gke.weave.works/cluster/details?clusterName=dev)

```
➜ k get gitopsclusters.gitops.weave.works

NAME   AGE   READY   STATUS
dev    19h   True
```
