namespace  , 
tujuan : handle nama aplikasi sama
ex : multi tenant (vm cost/manage untuk per prusahaan)
ex : 1 namespace untuk 1 prusahaan
ex : multi tenant / multi team / multi environment
namespace mirip grouping,

namespace digunakan resource sudah terlalu bnyk


get list namespace
```bash
kubectl get namespaces
#or
kubectl get namespace
#or
kubectl get ns
#NAME              STATUS   AGE
#default           Active   136m
#kube-node-lease   Active   136m
#kube-public       Active   136m
#kube-system       Active   136m

```

NOTE : ketika kalo buat pod langsung seperti sebelumnya bakalan masuk namespace default


check pod namespace
```bash
kubectl get pod --namespace <name_namespace>
#or
kubectl get pod --n <name_namespace>
# ex : 
# kubectl get pod --namespace default
# kubectl get pod --namespace kube-system
# kubectl get pod --namespace kube-public
# kubectl get pod --namespace kube-node-lease
```


create namespace

```bash
mkdir -p /home/ubuntu/KUBERNETES_FILE/namespace && 
cd /home/ubuntu/KUBERNETES_FILE/namespace && 
nano namespace_finance.yaml
```

```yml
apiVersion: v1
kind: Namespace
metadata:
  name: namespace-finance
```

NOTE : name: namespace-finance <<----- unique name


submit namespace
```bash

kubectl create -f namespace_finance.yaml

```


create pod in spesific namespace

```bash
kubectl create -f file_name.yaml --namespace namespace-finance

ex :

cd /home/ubuntu/KUBERNETES_FILE/pod && \
kubectl create -f pod_nginx.yaml --namespace namespace-finance

# kubectl get pod --namespace namespace-finance
# ubuntu@YOUR-VM-NAME:~/KUBERNETES_FILE/pod$ kubectl get pod --namespace namespace-finance
# NAME    READY   STATUS    RESTARTS   AGE
# nginx   1/1     Running   0          91s

```


delete namespace

```bash
kubectl delete namespace name_namespace

# kubectl delete namespace namespace-finance
```

NOTE : semua resource pada namespace yg di delete akan terhapus




delete all pod from namespace

```bash
kubectl delete pod --all --namespace name_namespace

# kubectl delete pod --all --namespace default
# kubectl get pod --namespace default
```
