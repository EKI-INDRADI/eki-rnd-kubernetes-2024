daemon set

ketika menggunakan replica set / replication contriller , pod akan di jalankan di random node oleh kubernetres



daemon_set  = secara defaultnya menjalankan pod di setiap node yang ada di kubernetes, kecuali jika kita meminta hanya jalan di note tertentu


daemon set = penggunaan kasus 
aplikasi untuk monitoring node
aplikasi untuk mengambil log di node
dan sejenisnya


deamon set , secara default akan di instal 1 di setiap nodes, yang berjalan tanpa berhenti



[daemon-set.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/templates/daemon-set.yaml)

```yml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: daemon-set-name
  labels:
    label-key1: label-value1
  annotations:
    annotation-key1: annotation-value1
spec:
  selector:
    matchLabels:
      label-key1: label-value1
    matchExpressions:
      - key: label-key1
        operator: In
        values:
          - label-value1
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

[daemon-nginx.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/examples/daemon-nginx.yaml)

```yml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: daemon-nginx
  labels:
    name: daemon-nginx
spec:
  selector:
    matchLabels:
      name: daemon-nginx
  template:
    metadata:
      name: daemon-nginx
      labels:
        name: daemon-nginx
    spec:
      containers:
        - name: nginx
          image: nginx
          ports:
            - containerPort: 80
          readinessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 0
            periodSeconds: 10
            failureThreshold: 3
            successThreshold: 1
            timeoutSeconds: 1
```

```bash
mkdir -p /home/ubuntu/KUBERNETES_FILE/daemon_set && 
cd /home/ubuntu/KUBERNETES_FILE/daemon_set && 
nano daemon_set_nginx.yaml
```

```yml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: daemon-set-nginx
  labels:
    name: daemon-set-nginx
spec:
  selector:
    matchLabels:
      name: daemon-set-nginx
  template:
    metadata:
      name: daemon-set-nginx
      labels:
        name: daemon-set-nginx
    spec:
      containers:
        - name: nginx-320
          image: nginx:stable-alpine3.20
          ports:
            - containerPort: 80
          readinessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 0
            periodSeconds: 10
            failureThreshold: 3
            successThreshold: 1
            timeoutSeconds: 1
```


```bash
cd /home/ubuntu/KUBERNETES_FILE/daemon_set &&
kubectl create -f daemon_set_nginx.yaml --namespace default

kubectl get daemonsets
#NAME               DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
#daemon-set-nginx   1         1         1       1            1           <none>          33s

kubectl get pod
#NAME                       READY   STATUS    RESTARTS         AGE
#daemon-set-nginx-22v5q     1/1     Running   0                85s
#nginx-with-probe           1/1     Running   1 (18h ago)      21h
#nginx-with-probe-error     1/1     Running   83 (5m19s ago)   21h
#rs-nginx-match-exp-5vv6n   1/1     Running   0                48m
#rs-nginx-match-exp-7vvvb   1/1     Running   0                48m
#rs-nginx-match-exp-mjm2j   1/1     Running   0                48m


kubectl get nodes
#NAME       STATUS   ROLES           AGE   VERSION
#minikube   Ready    control-plane   26h   v1.30.0



# NOTE karena hanya ada 1 nodes secara otomatis kan terinstal di nodes tersebut (hanya 1) , tapi jika memiliki  bnyk nodes otomatis jumlah pod akan mengikuti jumlah nodes tersebut ( di setiap nodes akan ada 1)


#detailnya
kubectl describe daemonsets daemon-set-nginx
# Name:           daemon-set-nginx
# Selector:       name=daemon-set-nginx
# Node-Selector:  <none>
# Labels:         name=daemon-set-nginx
# Annotations:    deprecated.daemonset.template.generation: 1
# Desired Number of Nodes Scheduled: 1
# Current Number of Nodes Scheduled: 1
# Number of Nodes Scheduled with Up-to-date Pods: 1
# Number of Nodes Scheduled with Available Pods: 1
# Number of Nodes Misscheduled: 0
# Pods Status:  1 Running / 0 Waiting / 0 Succeeded / 0 Failed
# Pod Template:
#   Labels:  name=daemon-set-nginx
#   Containers:
#    nginx-320:
#     Image:         nginx:stable-alpine3.20
#     Port:          80/TCP
#     Host Port:     0/TCP
#     Readiness:     http-get http://:80/ delay=0s timeout=1s period=10s #success=1 #failure=3
#     Environment:   <none>
#     Mounts:        <none>
#   Volumes:         <none>
#   Node-Selectors:  <none>
#   Tolerations:     <none>
# Events:
#   Type    Reason            Age    From                  Message
#   ----    ------            ----   ----                  -------
#   Normal  SuccessfulCreate  4m33s  daemonset-controller  Created pod: daemon-set-nginx-22v5q



#cara deletenya
kubectl delete daemonsets daemon-set-nginx
# daemonset.apps "daemon-set-nginx" deleted

```