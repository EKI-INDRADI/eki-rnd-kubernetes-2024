
## show list vm/nodes/minion

```bash

kubectl get node

```

or

```bash

kubectl get nodes

```

```bash

ubuntu@AZRN-VM-SV-PROD-KUBERNETES:~$ kubectl get nodes
NAME       STATUS   ROLES           AGE   VERSION
minikube   Ready    control-plane   23m   v1.30.0

```

## detail vm/nodes/minion


```sh

kubectl describe node <node_name>

## ex : kubectl describe node minikube

```
