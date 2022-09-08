# Connect a leaf cluster to enterprise

You want to connect an existing kube cluster to Weave Gitops Enterprise via its management cluster.

## Requirements

- You have a leaf cluster. For this guide we will be using [internal-dev-02](../gke-cluster/vars/internal-dev-02.tfvars)
- You have a management cluster. For this guide we will be using [internal-dev](../gke-cluster/vars/internal-dev.tfvars)

## How-to 

## Connecting leaf cluster Kubernetes 1.21 or above

Mostly, the current documentation [how to connect an existing cluster](https://docs.gitops.weave.works/docs/cluster-management/managing-existing-clusters) works.
However, from Kubernetes 1.21 bound tokens are the [default service account tokens](https://globalcloudplatforms.com/2022/07/15/what-gke-users-need-to-know-about-kubernetes-new-service-account-tokens/)
meaning that when you create a service account, there wont be any static token created as you could see below
```
➜   k get sa
NAME           SECRETS   AGE
default        0         21h
internal-dev   0         12h
```
so in order to create the token required for the kubeconfig you would need to create a token in any of the following ways

### Service Account Token Secrets

These are non bounded tokens that could be generated via a secret resource as explained in the 
[guide](https://kubernetes.io/docs/concepts/configuration/secret/#service-account-token-secrets)

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: internal-dev-token
  namespace: default
  annotations:
    kubernetes.io/service-account.name: "internal-dev"
type: kubernetes.io/service-account-token

```

that once created you could see how the secret data includes both the `service account token` and the `ca.crt` to be
used to create the management cluster kubeconfig

```
➜  gke-cluster git:(issues/34) ✗ k get secret
NAME                 TYPE                                  DATA   AGE
internal-dev-token   kubernetes.io/service-account-token   3      11h

```

Once you have created the leaf cluster [kubeconfig as secret in the management cluster](https://docs.gitops.weave.works/docs/cluster-management/managing-existing-clusters/#how-to-create-a-kubeconfig-secret-using-a-service-account).
You could just add the [gitops cluster manifest](../k8s/clusters/internal-dev-gke/clusters/gitops-cluster.yaml).

Notice that you should ensure to create the cluster manifest in 
the [right namespace](https://github.com/weaveworks/weave-gitops-enterprise/blob/76ff28cf899a094cef623b5ccd46b2f426516abf/cmd/clusters-service/app/server.go#L176)

And you could see that cluster service is happy because the cluster shows 
[in the ui](https://gitops.internal-dev.wego-gke.weave.works/cluster/details?clusterName=internal-dev-02) or the logs
 
```
{"level":"info","ts":1662589808.5358994,"logger":"gitops.multi-cluster-fetcher","caller":"fetcher/multi.go:56","msg":"Found clusters","clusters":["management","flux-system/internal-dev-02"]}
```

## Connecting leaf cluster Kubernetes 1.20 or below 
It is unlikely that you are in this scenario but in this case, 
you just need to follow [how to connect an existing cluster](https://docs.gitops.weave.works/docs/cluster-management/managing-existing-clusters).
