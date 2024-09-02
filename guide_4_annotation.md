annotation mirip label, tapi tidak bs di filter / di query (informasi besar sampai 256 kb)
contoh : dokumentasi / description / policy

[pod-with-annotaion.yml](https://github.com/khannedy/belajar-kubernetes/blob/master/templates/pod-with-annotation.yaml)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-name
  labels:
    label-key1: label-value1
  annotations:
    annotation-key1: annotation-value
    annotation-key2: veri long annotation value, bla bla bla bla bla bla
spec:
  containers:
    - name: container-name
      image: image-name
      ports:
        - containerPort: 80
```

note : annotaion boleh ada spasi dan bole panjang max 256 kb


```bash
mkdir -p /home/ubuntu/KUBERNETES_FILE/pod && 
cd /home/ubuntu/KUBERNETES_FILE/pod && 
nano pod_nginx_with_annotation.yaml
```

```yml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-with-annotation
  labels:
    project: xxx
    version: "3.20"
    division: product
    team: project
    environment: development
  annotations:
    description: ini adalah aplikasi yg dibuat oleh team project
    documentation: zzzzzzzzzzzzz
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

kubectl create -f pod_nginx_with_annotation.yaml

```

```bash

kubectl get pod --show-labels 
#NAME                   READY   STATUS    RESTARTS   AGE   LABELS
#nginx                  1/1     Running   0          51m   environment=qa
#nginx-with-annotaion   1/1     Running   0          54s   division=product,environment=development,project=xxx,team=project,version=3.20
#nginx-with-label       1/1     Running   0          24m   division=product,environment=production,project=xxx,team=product,version=3.20
kubectl describe pod nginx-with-annotation
#ubuntu@AZRN-VM-SV-PROD-KUBERNETES:~/KUBERNETES_FILE/pod$ kubectl describe pod nginx-with-annotation
#Name:             nginx-with-annotation
#Namespace:        default
#Priority:         0
#Service Account:  default
#Node:             minikube/192.168.49.2
#Start Time:       Tue, 20 Aug 2024 04:07:45 +0000
#Labels:           division=product
#                  environment=development
#                  project=xxx
#                  team=project
#                  version=3.20
#Annotations:      description: ini adalah aplikasi yg dibuat oleh team project
#                  documentation: zzzzzzzzzzzzz


```


update annotation (not recomended, sebaiknya update dari configuration file)

```bash
kubectl annotate pod <pod_name> key=value 
kubectl annotate pod <pod_name> key=value --overwrite

# ex : 
# kubectl annotate pod nginx-with-label documentation="step by step"
# kubectl annotate pod nginx-with-label documentation="step 1. asdasdas" --overwrite

```