# k8s-workshop

## GOALS:

At the end of the workshop, you should be able to:

- Understand what a **Pod** is and how to interact with it
- Ensure that a number of pods are running with **ReplicaSets / Replication Controllers**
- Perform rolling updates and rollbacks with **Deployments**
- Expose your application to the outside world with **Services**

#### 1 Install needed tools
Please follow the presequisite link in README to follow through the installations.

Some pre-flight checks:
- `docker version`
- `kubectl version`
- `helm version`
- `which kubectx kind kubens`
- Make sure you follow config for [Shell auto complete](https://kubernetes.io/docs/tasks/tools/install-kubectl/#enabling-shell-autocompletion)

#### 2 Spin up Kind cluster

[Kind Installation Guide](https://kind.sigs.k8s.io/docs/user/quick-start)

## Part 1: Create local kind cluster
By default, `kind create cluster` will create a 1 master, 1 worker node with stable K8s version. We can modify:
- Cluster setup by giving it different configs
- k8s version by using a different node docker image. More info on [different version](https://hub.docker.com/r/kindest/node/tags)
In this workshop, let's create a 1 master and 2 worker cluster with kubernetes version v1.16.3

```
$ cd kind && kind create cluster --config 1m-2w-cluster/cluster.yml --image kindest/node:v1.16.3
Creating cluster "kind" ...
 ✓ Ensuring node image (kindest/node:v1.16.3) 🖼
 ✓ Preparing nodes 📦📦📦
 ✓ Creating kubeadm config 📜
 ✓ Starting control-plane 🕹️
 ✓ Installing CNI 🔌
 ✓ Installing StorageClass 💾
 ✓ Joining worker nodes 🚜
Cluster creation complete. You can now use the cluster with:

export KUBECONFIG="$(kind get kubeconfig-path --name="kind")"
kubectl cluster-info
```
## Part 2: Hello World
For our Hello World exercise, we will deploy an app containing a bunch of nginx containers.

GOALS:
- Able to create, inspect and delete K8s resources (Pods ReplicaSets Deployments Services)
- Verify that your application is running (index.html and 50x.html get served)

### Check your setup
Before we start, ensure that your `kind` cluster is running:
```
kind get clusters
```

If you have not connect kubectl to kind yet in Part 1, you can do it now by

```
export KUBECONFIG="$(kind get kubeconfig-path --name="kind")"
```
If you are using kube-ps1, you shell should look like this
```
(☸ |kubernetes-admin@kind:default)~/ ❯❯❯ 
```

Let's take a look at how the kube config file looks like:

```
$ cat ~/.kube/config/kind-config-kind
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: <Redacted>
    server: https://127.0.0.1:42443
  name: kind
contexts:
- context:
    cluster: kind
    user: kubernetes-admin
  name: kubernetes-admin@kind
current-context: kubernetes-admin@kind
kind: Config
preferences: {}
users:
- name: kubernetes-admin
  user:
    client-certificate-data: <Redacted>
```
You can see that we are communicating with kubeapi server that is exposed at https://127.0.0.1:42443, using the client certificate using user `kubernetes-admin`. This user have full RW permission to all namespaces in the Kubernetes cluster. For security reasons, it is recommended to create Service Account with token and limit the scope of the permission instead so that in case the credential is compromised, access can still be revoked.

There are many different ways to provide authentication for only cluster admin, tenants, but also (cloud) services that communicate to Kubernetes API. [Official Doc](https://kubernetes.io/docs/reference/access-authn-authz/authentication/)

### Deploy  app
```
# create a Deployment, containing a ReplicaSet (of 3 pods), each of them containing a nginx container
kubectl run --image=nginx hello-nginx --port=80 --labels="app=hello" --replicas=3

# expose your Pods within the hello-nginx Deployment outside the cluster.
kubectl expose deployment hello-nginx --port=80 --name=hello-http --type=NodePort

# grab the NodePort number (30000-32767)
kubectl describe svc hello-http

# Access Pods through your cluster's ip (which is minikube)
wget $(minikube ip):{nodePort}
```

Congrats! You just deployed an app on Kubernetes!

The approach that we took to deploy is known as the **imperative** way. (*imperative vs declarative*: more on that later)

By now, you should have created the following resources:
- 3 Pods (a.k.a. `po`)
- 1 ReplicaSet (a.k.a. `rs`)
- 1 Deployment (a.k.a. `deploy`)
- 1 Service (a.k.a. `svc`)

Please take a look at the resources (`deployment`, `replicasets`, `pods` and `services`) you just deployed with the following commands:

```
kubectl get {resource-type}                             # e.g. kubectl get deployment
kubectl describe {resource-type} {resource-name}        # e.g. kubectl describe deployment hello-nginx
```


### Clean up

Once you are done with this workshop, you can stop the kind cluster by `kind delete cluster`

### Questions to ask yourself
- In the *Deploy our app* section, we deployed an app and exposed it by running some commands (`run` and `expose`). And as mentioned, this way is known as the **imperative** way.

Now imagine if you were to deploy with more configurations (more labels, mount volumes or even multiple pods etc), how would your command look like?

---

### What you have learned in this section

1. Familiarize yourself with **kind**
2. Wire your `kubectl` client to the correct Kubernetes cluster (minikube or a GKE project)
3. Familiarize with the key resources within Kubernetes (Pods, ReplicaSets, Deployments, and Services)
4. Learned how to interact with K8s resources by kubectl `get`, `describe` and `delete`
5. Quickly deployed all these resources in one go with `kubectl run`, which is the `imperative way` of deployment.

This was a very high-level overview of Kubernetes. From here on, we will build your knowledge from the bottom up, starting by looking at [**Pods in the next section**](https://github.com/MrBinh192/k8s-workshop/Part-2-Pods)
