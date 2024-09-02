pod = container / multi container  | case:  1 pod:* container /  1 pod:1 container 


```bash

## ex :

container1 | container2 |   container1     | container1  | 
        pod1            |      pod2        |     pod3    |
                      node1                |    node2    |

```

## show list pod

```bash

kubectl get pod

```


```bash

ubuntu@YOUR-VM-NAME:~$ kubectl get pod
No resources found in default namespace.

```

## detail pod


```bash

kubectl describe pod <pod_name>

## ex : kubectl describe pod pod1

```

## create/submit pod

[pod.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/templates/pod.yaml)

```yml
apiVersion: v1
kind: Pod
metadata:
  name: pod-name
spec:
  containers:
    - name: container-name
      image: image-name
      ports:
        - containerPort: 80
```

[nginx](https://hub.docker.com/_/nginx/tags)

docker pull nginx:stable-alpine3.20


submit pod
```bash
mkdir -p /home/ubuntu/KUBERNETES_FILE/pod && 
cd /home/ubuntu/KUBERNETES_FILE/pod && 
nano pod_nginx.yaml
```

```yml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
    - name: nginx-320
      image: nginx:stable-alpine3.20
      ports:
        - containerPort: 80
```

submit pod
```bash

kubectl create -f pod_nginx.yaml

```

makesure pod running

```bash
kubectl get pod    
# kubectl get po
# kubectl get pods 
# ubuntu@YOUR-VM-NAME:~/KUBERNETES_FILE/pod$ kubectl get pod
# NAME    READY   STATUS    RESTARTS   AGE
# nginx   1/1     Running   0          2m8s

kubectl get pod -o wide
#ubuntu@YOUR-VM-NAME:~/KUBERNETES_FILE/pod$ kubectl get pod -o wide
#NAME    READY   STATUS    RESTARTS   AGE     IP           NODE       NOMINATED NODE   READINESS GATES
#nginx   1/1     Running   0          3m49s   10.244.0.5   minikube   <none>           <none>

kubectl describe pod nginx
# agak panjang detailnya
```

access pod
```bash
kubectl port-forward --address 0.0.0.0 <pod_name> <pod_port_access>:port_pod

kubectl port-forward --address 0.0.0.0 pod_name 8888:8080

# ex: kubectl port-forward --address 0.0.0.0 nginx 8888:80
#Forwarding from 127.0.0.1:8888 -> 80
#Forwarding from [::1]:8888 -> 80

```


delete pod

```bash
# kubectl get pod
#NAME                    READY   STATUS    RESTARTS   AGE   LABELS
#nginx-with-annotaion    1/1     Running   0          66m   division=product,envi                                                                           ronment=development,project=xxx,team=project,version=3.20
#nginx-with-annotation   1/1     Running   0          64m   division=product,envi                                                                           ronment=development,project=xxx,team=project,version=3.20
#nginx-with-label        1/1     Running   0          89m   division=product,envi 

kubectl delete pod namepod
#or
kubectl delete pod namepod1 namepod2 namepod3

# kubectl delete pod nginx
# kubectl delete pod nginx-with-annotaion
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

