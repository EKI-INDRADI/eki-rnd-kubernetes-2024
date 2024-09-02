
label = informasi tambahan di semua resource kubernetes , mirip TAG AWS

keperluan query / search / find

[pod-with-label.yml](https://github.com/khannedy/belajar-kubernetes/blob/master/templates/pod-with-label.yaml)
```bash
apiVersion: v1
kind: Pod
metadata:
  name: pod-name
  labels:
    label-key1: label-value1
    label-key2: label-value2
    label-key3: label-value3
spec:
  containers:
    - name: container-name
      image: image-name
      ports:
        - containerPort: 80
```

NOTE : label gak boleh ada spasi, ganti pake -

```bash
mkdir -p /home/ubuntu/KUBERNETES_FILE/pod && 
cd /home/ubuntu/KUBERNETES_FILE/pod && 
nano pod_nginx_with_label.yaml
```

```yml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-with-label
  labels:
    project: xxx
    version: "3.20"
    division: product
    team: product
    environment: production
spec:
  containers:
    - name: nginx-320
      image: nginx:stable-alpine3.20
      ports:
        - containerPort: 80
```

NOTE : name: nginx <<----- unique name


submit pod
```bash

kubectl create -f pod_nginx_with_label.yaml

```


```bash
kubectl get pod 
#ubuntu@YOUR-VM-NAME:~/KUBERNETES_FILE/pod$ kubectl get pod
#NAME               READY   STATUS    RESTARTS   AGE
#nginx              1/1     Running   0          27m
#nginx-with-label   1/1     Running   0          23s

kubectl get pod --show-labels 
#ubuntu@YOUR-VM-NAME:~/KUBERNETES_FILE/pod$ kubectl get pod --show-labels
#NAME               READY   STATUS    RESTARTS   AGE   LABELS
#nginx              1/1     Running   0          28m   <none>
#nginx-with-label   1/1     Running   0          39s   division=product,environment=production,project=xxx,team=product,version=3.20
```

update labels (not recomended, sebaiknya update dari configuration file)

```bash
kubectl label pod <pod_name> key=value 
kubectl label pod <pod_name> key=value --overwrite

# ex : 
# kubectl label pod nginx environment=development
# kubectl label pod nginx environment=qa --overwrite

#ubuntu@YOUR-VM-NAME:~/KUBERNETES_FILE/pod$ kubectl get pod --show-labels
#NAME               READY   STATUS    RESTARTS   AGE    LABELS
#nginx              1/1     Running   0          33m    environment=qa
#nginx-with-label   1/1     Running   0          6m7s   division=product,environment=production,project=xxx,team=product,version=3.20


kubectl get pod --show-labels 
```



query / search / find label

```bash
kubectl get pods -l key
# kubectl get pods -l team
kubectl get pods -l key=value
# kubectl get pods -l team=rnd
kubectl get pods -l '!key'
# kubectl get pods -l '!team'
kubectl get pods -l key!=value
kubectl get pods -l 'key in (value1,value2)'
# kubectl get pods -l 'environment in (production,qa,development)'
kubectl get pods -l 'key notin (value1,value2)'
kubectl get pods -l key,key2=value
# kubectl get pods -l 'environment,team=product'
kubectl get pods -l key=value,key2=value
```

delete pod with speisific label

```bash
# kubectl get pod --show-labels
#ubuntu@YOUR-VM-NAME:~/KUBERNETES_FILE/pod$  kubectl get pod --show-labels
#NAME                    READY   STATUS    RESTARTS   AGE   LABELS
#nginx-with-annotation   1/1     Running   0          65m   division=product,environment=development,project=xxx,team=project,version=3.20
#nginx-with-label        1/1     Running   0          91m   division=product,environment=production,project=xxx,team=product,version=3.20


kubectl delete pod -l key=value

# kubectl delete pod -l environment=development

```