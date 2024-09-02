https://www.youtube.com/watch?v=yvZvRHO92Vs&list=PL-CtdCApEFH8XrWyQAyRd6d_CKwxD8Ime&index=17

tujuan = replicaset dibuat untuk menggantikan replication controller


replica set = menjaga jumlah replica pod , generasi terbaru dari replication controller

replica set vs replication controller
replica set = 
- kemapuan == replciation controller
- untuk label selector yg lebih expressive dibanding replication controller


[replica-set.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/templates/replica-set.yaml)


selectornya untuk versi pake labelnya bs pake matchLabels

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: replica-set-name
  labels:
    label-key1: label-value1
  annotations:
    annotation-key1: annotation-value1
spec:
  replicas: 3
  selector:
    matchLabels:
      label-key1: label-value1
  template:
    metadata:
      name: pod-name
      labels:
        label-key1: label-value1
    spec:
      containers:
      - name: container-name
        image: image-name
        ports:
        - containerPort: 80
        readinessProbe:
          httpGet:
            path: /health
            port: 80
          initialDelaySeconds: 0
          periodSeconds: 10
          failureThreshold: 3
          successThreshold: 1
          timeoutSeconds: 1
```


```bash
mkdir -p /home/ubuntu/KUBERNETES_FILE/replica_set && 
cd /home/ubuntu/KUBERNETES_FILE/replica_set && 
nano rs_nginx.yaml
```


```yml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: rs-nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app-selector: rs-nginx-app-selector
  template:
    metadata:
      name: rs-nginx
      labels:
       app-selector: rs-nginx-app-selector
    spec:
      containers:
        - name: nginx-320
          image: nginx:stable-alpine3.20
          ports:
            - containerPort: 80
```


HARUS SAMA LABELNYA app-selector: rs-nginx-app-selector

```yml
#   selector:
    matchLabels:
      app-selector: rs-nginx-app-selector

#   template:
#     metadata:
#       name: rs-nginx
      labels:
       app-selector: rs-nginx-app-selector

```

```bash
cd /home/ubuntu/KUBERNETES_FILE/replica_set &&
kubectl create -f rs_nginx.yaml --namespace default

kubectl get pod
# ubuntu@YOUR-VM-NAME:~/KUBERNETES_FILE/replica_set$ kubectl get pod
# NAME                     READY   STATUS    RESTARTS      AGE
# nginx-with-probe         1/1     Running   1 (17h ago)   20h
# nginx-with-probe-error   1/1     Running   60 (9s ago)   20h
# rc-nginx-6mcjm           1/1     Running   1 (17h ago)   17h
# rc-nginx-9mszq           1/1     Running   1 (17h ago)   17h
# rc-nginx-rbpjd           1/1     Running   1 (17h ago)   17h
# rs-nginx-fsh84           1/1     Running   0             3s
# rs-nginx-l2dwc           1/1     Running   0             3s
# rs-nginx-tnjzb           1/1     Running   0             3s

kubectl get rs
# ubuntu@YOUR-VM-NAME:~/KUBERNETES_FILE/replica_set$ kubectl get rs
# NAME       DESIRED   CURRENT   READY   AGE
# rs-nginx   3         3         3       45s


kubectl delete pod rs-nginx-tnjzb

# ubuntu@YOUR-VM-NAME:~/KUBERNETES_FILE/replica_set$ kubectl delete pod rs-nginx-tnjzb
# pod "rs-nginx-tnjzb" deleted

kubectl get pod
# ubuntu@YOUR-VM-NAME:~/KUBERNETES_FILE/replica_set$ kubectl get pod
# NAME                     READY   STATUS             RESTARTS       AGE
# nginx-with-probe         1/1     Running            1 (17h ago)    20h
# nginx-with-probe-error   0/1     CrashLoopBackOff   60 (83s ago)   20h
# rc-nginx-6mcjm           1/1     Running            1 (17h ago)    17h
# rc-nginx-9mszq           1/1     Running            1 (17h ago)    17h
# rc-nginx-rbpjd           1/1     Running            1 (17h ago)    17h
# rs-nginx-fsh84           1/1     Running            0              92s
# rs-nginx-jdlbz           1/1     Running            0              5s
# rs-nginx-l2dwc           1/1     Running            0              92s


```






label select match expression

match expression 
1. matchLabels = mirip replication controller, key=value harus sama
2. matchExpression = menmabahkan operasi  
In = value label hrs ada di value (multi) ,
NotIn = value label gak ada pada value (multi), 
Exists  = value label hrs ada di value ,
NotExists = value label gak ada pada value, 

[replica-set-match-expression.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/templates/replica-set-match-expression.yaml)


```yml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: replica-set-name
  labels:
    label-key1: label-value1
  annotations:
    annotation-key1: annotation-value1
spec:
  replicas: 3
  selector:
    matchLabels:
      label-key1: label-value1
    matchExpressions:
      - key: label-key
        operator: In
        values:
          - label-value1
          - label-value2
  template:
    metadata:
      name: pod-name
      labels:
        label-key1: label-value1
    spec:
      containers:
      - name: container-name
        image: image-name
        ports:
        - containerPort: 80
        readinessProbe:
          httpGet:
            path: /health
            port: 80
          initialDelaySeconds: 0
          periodSeconds: 10
          failureThreshold: 3
          successThreshold: 1
          timeoutSeconds: 1
```








```bash
mkdir -p /home/ubuntu/KUBERNETES_FILE/replica_set && 
cd /home/ubuntu/KUBERNETES_FILE/replica_set && 
nano rs_nginx_match_expression.yaml
```


```yml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: rs-nginx-match-exp
spec:
  replicas: 3
  selector:
    matchExpressions:
      - key: app-selector
        operator: In
        values:
          - rs-nginx-match-exp-app-selector
      - key: env-selector
        operator: In
        values:
          - prod
          - aq
          - dev
  template:
    metadata:
      name: rs-nginx-match-exp
      labels:
       app-selector: rs-nginx-match-exp-app-selector
       env-selector: prod
    spec:
      containers:
        - name: nginx-320
          image: nginx:stable-alpine3.20
          ports:
            - containerPort: 80
```


```bash
cd /home/ubuntu/KUBERNETES_FILE/replica_set &&
kubectl create -f rs_nginx_match_expression.yaml --namespace default



kubectl get rs
# NAME                       READY   STATUS             RESTARTS       AGE
# nginx-with-probe           1/1     Running            1 (17h ago)    20h
# nginx-with-probe-error     0/1     CrashLoopBackOff   68 (76s ago)   20h
# rs-nginx-match-exp-5vv6n   1/1     Running            0              5m2s
# rs-nginx-match-exp-7vvvb   1/1     Running            0              5m2s
# rs-nginx-match-exp-mjm2j   1/1     Running            0              5m2s



kubectl get pod --show-labels
# NAME                       READY   STATUS             RESTARTS        AGE     LABELS
# nginx-with-probe           1/1     Running            1 (17h ago)     20h     <none>
# nginx-with-probe-error     0/1     CrashLoopBackOff   68 (2m1s ago)   20h     <none>
# rs-nginx-match-exp-5vv6n   1/1     Running            0               5m47s   app-selector=rs-nginx-match-exp-app-selector,env-selector=prod
# rs-nginx-match-exp-7vvvb   1/1     Running            0               5m47s   app-selector=rs-nginx-match-exp-app-selector,env-selector=prod
# rs-nginx-match-exp-mjm2j   1/1     Running            0               5m47s   app-selector=rs-nginx-match-exp-app-selector,env-selector=prod





```