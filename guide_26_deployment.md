
# CREATE DEPLOYMENT

deploy aplkasi dan update aplikasi secara deklaratif menggunakan file konfigurasi

saat buat deployment secara otomatis akan membuat replicaset dan secara otomatis membuat pod

## kubernetes cluster

                            NODE1                |          NODE2

Deployment -> replicaset -> pod1
**************\_**************> pod2

```bash
kubectl get deployments
kubectl describe deployment name_deployment
kubectl delete deployment name_deployment

```

Contoh CREATE Konfigurasi

Template :
[deployment.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/templates/deployment.yaml)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deployment-name
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

Contoh :
[deployment.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/examples/deployment.yaml)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nodejs-web
  labels:
    name: nodejs-web
spec:
  replicas: 3
  selector:
    matchLabels:
      name: nodejs-web
  template:
    metadata:
      name: nodejs-web
      labels:
        name: nodejs-web
    spec:
      containers:
        - name: nodejs-web
          image: khannedy/nodejs-web:1
          ports:
            - containerPort: 3000

---
apiVersion: v1
kind: Service
metadata:
  name: nodejs-web-service
spec:
  type: NodePort
  selector:
    name: nodejs-web
  ports:
    - port: 3000
      targetPort: 3000
      nodePort: 30001
```

COBA

```bash
kubectl delete all --all


mkdir -p /home/ubuntu/KUBERNETES_FILE/service &&
cd /home/ubuntu/KUBERNETES_FILE/service &&
nano service_deployment_nodejs_web.yaml
```

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nodejs-web
  labels:
    name: nodejs-web
spec:
  replicas: 3
  selector:
    matchLabels:
      app-selector: nodejs-web
  template:
    metadata:
      name: nodejs-web
      labels:
        app-selector: nodejs-web
    spec:
      containers:
        - name: nodejs-web
          image: khannedy/nodejs-web:1
          ports:
            - containerPort: 3000

---
apiVersion: v1
kind: Service
metadata:
  name: nodejs-web-service
spec:
  type: NodePort
  selector:
    app-selector: nodejs-web
  ports:
    - port: 3000
      targetPort: 3000
      nodePort: 30001
```

```bash
cd /home/ubuntu/KUBERNETES_FILE/service &&
kubectl apply -f service_deployment_nodejs_web.yaml  --namespace default

kubectl get deployments
# NAME         READY   UP-TO-DATE   AVAILABLE   AGE
# nodejs-web   3/3     3            3           27s

kubectl get all
# NAME                              READY   STATUS    RESTARTS   AGE
# pod/nodejs-web-5b8d4df8c4-7jkm5   1/1     Running   0          61s
# pod/nodejs-web-5b8d4df8c4-f6kdn   1/1     Running   0          61s
# pod/nodejs-web-5b8d4df8c4-xkmbb   1/1     Running   0          61s

# NAME                         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
# service/kubernetes           ClusterIP   10.96.0.1       <none>        443/TCP          85s
# service/nodejs-web-service   NodePort    10.111.161.15   <none>        3000:30001/TCP   61s

# NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
# deployment.apps/nodejs-web   3/3     3            3           61s

# NAME                                    DESIRED   CURRENT   READY   AGE
# replicaset.apps/nodejs-web-5b8d4df8c4   3         3         3       61s



minikube service nodejs-web-service 

|-----------|--------------------|-------------|---------------------------|
| NAMESPACE |        NAME        | TARGET PORT |            URL            |
|-----------|--------------------|-------------|---------------------------|
| default   | nodejs-web-service |        3000 | http://192.168.49.2:30001 |
|-----------|--------------------|-------------|---------------------------|
# * Opening service default/nodejs-web-service in default browser...
#   http://192.168.49.2:30001



kubectl port-forward --address 0.0.0.0 service/nodejs-web-service 30001:3000 

  # http://<YOUR_IP_PUBLIC>:30001/


# Application 1.0

kubectl describe deployments nodejs-web
# Name:                   nodejs-web
# Namespace:              default
# CreationTimestamp:      Mon, 26 Aug 2024 06:50:48 +0000
# Labels:                 name=nodejs-web
# Annotations:            deployment.kubernetes.io/revision: 1
# Selector:               app-selector=nodejs-web
# Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
# StrategyType:           RollingUpdate
# MinReadySeconds:        0
# RollingUpdateStrategy:  25% max unavailable, 25% max surge
# Pod Template:
#   Labels:  app-selector=nodejs-web
#   Containers:
#    nodejs-web:
#     Image:         khannedy/nodejs-web:1
#     Port:          3000/TCP
#     Host Port:     0/TCP
#     Environment:   <none>
#     Mounts:        <none>
#   Volumes:         <none>
#   Node-Selectors:  <none>
#   Tolerations:     <none>
# Conditions:
#   Type           Status  Reason
#   ----           ------  ------
#   Available      True    MinimumReplicasAvailable
#   Progressing    True    NewReplicaSetAvailable
# OldReplicaSets:  <none>
# NewReplicaSet:   nodejs-web-5b8d4df8c4 (3/3 replicas created)
# Events:
#   Type    Reason             Age    From                   Message
#   ----    ------             ----   ----                   -------
#   Normal  ScalingReplicaSet  9m57s  deployment-controller  Scaled up replica set nodejs-web-5b8d4df8c4 to 3


kubectl delete -f service_deployment_nodejs_web.yaml  
# deployment.apps "nodejs-web" deleted
# service "nodejs-web-service" deleted

```

# UPDATE DEPLOYMENT

update versi aplikasi , dll

tinggal menggunakan apply lagi , jika update akan membuat replicaset baru dan pod baru 
(tanpa server mati) 

artinya replicaset lama dan pod lama tidak terhapus 
sebelum  replicaset baru dan pod baru success berjalan  baru akan di delete yang lama
tidak ada downtime server



deploy update
```bash
kubectl apply -f deployment.yaml
```



COBA ( contoh update image  version 1 -> 2)

```bash
#kubectl delete all --all #(DONT USE)


mkdir -p /home/ubuntu/KUBERNETES_FILE/service &&
cd /home/ubuntu/KUBERNETES_FILE/service &&
nano service_deployment_nodejs_web.yaml

rubah  khannedy/nodejs-web:1 menjadi khannedy/nodejs-web:2
```

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nodejs-web
  labels:
    name: nodejs-web
spec:
  revisionHistoryLimit: 10
  replicas: 3
  selector:
    matchLabels:
      app-selector: nodejs-web
  template:
    metadata:
      name: nodejs-web
      labels:
        app-selector: nodejs-web
    spec:
      containers:
        - name: nodejs-web
          image: khannedy/nodejs-web:2
          ports:
            - containerPort: 3000

---
apiVersion: v1
kind: Service
metadata:
  name: nodejs-web-service
spec:
  type: NodePort
  selector:
    app-selector: nodejs-web
  ports:
    - port: 3000
      targetPort: 3000
      nodePort: 30001
```

```bash
cd /home/ubuntu/KUBERNETES_FILE/service &&
kubectl apply -f service_deployment_nodejs_web.yaml  --namespace default

deployment.apps/nodejs-web configured
service/nodejs-web-service unchanged


kubectl get deployments
# NAME         READY   UP-TO-DATE   AVAILABLE   AGE
# nodejs-web   3/3     3            3           61s


kubectl get all

# ubuntu@YOUR-VM-NAME:~/KUBERNETES_FILE/service$ kubectl get all
# NAME                              READY   STATUS    RESTARTS   AGE
# pod/nodejs-web-5b8d4df8c4-2lcn7   1/1     Running   0          21s
# pod/nodejs-web-5b8d4df8c4-5xn9h   1/1     Running   0          21s
# pod/nodejs-web-5b8d4df8c4-vhlpb   1/1     Running   0          21s



minikube service nodejs-web-service 

# |-----------|--------------------|-------------|---------------------------|
# | NAMESPACE |        NAME        | TARGET PORT |            URL            |
# |-----------|--------------------|-------------|---------------------------|
# | default   | nodejs-web-service |        3000 | http://192.168.49.2:30001 |
# |-----------|--------------------|-------------|---------------------------|
# # * Opening service default/nodejs-web-service in default browser...
# #   http://192.168.49.2:30001


kubectl port-forward --address 0.0.0.0 service/nodejs-web-service 30001:3000 

# http://<YOUR_IP_PUBLIC>:30001/

# Application 2.0 <!---- image berubah aplikais brubah>

#==================

kubectl describe deployments nodejs-web
# Name:                   nodejs-web
# Namespace:              default
# CreationTimestamp:      Mon, 26 Aug 2024 06:50:48 +0000
# Labels:                 name=nodejs-web
# Annotations:            deployment.kubernetes.io/revision: 1
# Selector:               app-selector=nodejs-web
# Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
# StrategyType:           RollingUpdate
# MinReadySeconds:        0
# RollingUpdateStrategy:  25% max unavailable, 25% max surge
# Pod Template:
#   Labels:  app-selector=nodejs-web
#   Containers:
#    nodejs-web:
#     Image:         khannedy/nodejs-web:1
#     Port:          3000/TCP
#     Host Port:     0/TCP
#     Environment:   <none>
#     Mounts:        <none>
#   Volumes:         <none>
#   Node-Selectors:  <none>
#   Tolerations:     <none>
# Conditions:
#   Type           Status  Reason
#   ----           ------  ------
#   Available      True    MinimumReplicasAvailable
#   Progressing    True    NewReplicaSetAvailable
# OldReplicaSets:  <none>
# NewReplicaSet:   nodejs-web-5b8d4df8c4 (3/3 replicas created)
# Events:
#   Type    Reason             Age    From                   Message
#   ----    ------             ----   ----                   -------
#   Normal  ScalingReplicaSet  9m57s  deployment-controller  Scaled up replica set nodejs-web-5b8d4df8c4 to 3


kubectl delete -f service_deployment_nodejs_web.yaml  
# deployment.apps "nodejs-web" deleted
# service "nodejs-web-service" deleted

kubectl get all
# pada proses ini ada replicaset lama yang tetap ada tapi currentnya 0, 
# karena proses deployment ini tidak langsung mengganti ke pod baru , tapi emunggu pod baru UP , 
# baru pod lama di hapus maka dari itu replicasetnya masih ada tapi tidak terpakai

#
# pod/nodejs-web-5dbb6bc987-chjkb   1/1     Running   0          2m5s
# pod/nodejs-web-5dbb6bc987-nrppv   1/1     Running   0          2m14s
# pod/nodejs-web-5dbb6bc987-zkhmr   1/1     Running   0          2m7s
                                                                     #<---- pod lama juga otomatis terminate 

# NAME                         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
# service/kubernetes           ClusterIP   10.96.0.1       <none>        443/TCP          31m
# service/nodejs-web-service   NodePort    10.106.62.177   <none>        3000:30001/TCP   11m

# NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
# deployment.apps/nodejs-web   3/3     3            3           11m

# NAME                                    DESIRED   CURRENT   READY   AGE
# replicaset.apps/nodejs-web-5b8d4df8c4   0         0         0       11m   #<---- otomatis 0 service lama , tidak di hapus karena kebutuhan proses rollback
# replicaset.apps/nodejs-web-5dbb6bc987   3         3         3       2m14s



kubectl describe deployments nodejs-web 
#( pada proses ini ada history start stop dari pod , tergantung dari jumlah
# revisionHistoryLimit: 10 pada yaml config )

# Name:                   nodejs-web
# Namespace:              default
# CreationTimestamp:      Mon, 26 Aug 2024 07:10:21 +0000
# Labels:                 name=nodejs-web
# Annotations:            deployment.kubernetes.io/revision: 2
# Selector:               app-selector=nodejs-web
# Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
# StrategyType:           RollingUpdate
# MinReadySeconds:        0
# RollingUpdateStrategy:  25% max unavailable, 25% max surge
# Pod Template:
#   Labels:  app-selector=nodejs-web
#   Containers:
#    nodejs-web:
#     Image:         khannedy/nodejs-web:2
#     Port:          3000/TCP
#     Host Port:     0/TCP
#     Environment:   <none>
#     Mounts:        <none>
#   Volumes:         <none>
#   Node-Selectors:  <none>
#   Tolerations:     <none>
# Conditions:
#   Type           Status  Reason
#   ----           ------  ------
#   Available      True    MinimumReplicasAvailable
#   Progressing    True    NewReplicaSetAvailable
# OldReplicaSets:  nodejs-web-5b8d4df8c4 (0/0 replicas created)
# NewReplicaSet:   nodejs-web-5dbb6bc987 (3/3 replicas created)
# Events:
#   Type    Reason             Age    From                   Message
#   ----    ------             ----   ----                   -------
#   Normal  ScalingReplicaSet  13m    deployment-controller  Scaled up replica set nodejs-web-5b8d4df8c4 to 3
#   Normal  ScalingReplicaSet  4m34s  deployment-controller  Scaled up replica set nodejs-web-5dbb6bc987 to 1
#   Normal  ScalingReplicaSet  4m27s  deployment-controller  Scaled down replica set nodejs-web-5b8d4df8c4 to 2 from 3
#   Normal  ScalingReplicaSet  4m27s  deployment-controller  Scaled up replica set nodejs-web-5dbb6bc987 to 2 from 1
#   Normal  ScalingReplicaSet  4m25s  deployment-controller  Scaled down replica set nodejs-web-5b8d4df8c4 to 1 from 2
#   Normal  ScalingReplicaSet  4m25s  deployment-controller  Scaled up replica set nodejs-web-5dbb6bc987 to 3 from 2
#   Normal  ScalingReplicaSet  4m23s  deployment-controller  Scaled down replica set nodejs-web-5b8d4df8c4 to 0 from 1

```