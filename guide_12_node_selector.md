node selector = memilih node mana


memilih node untuk kebutuhan tertentu , misal kebutuhan GPU, kebutuhan SSD , dll


untuk menjalankan pod pada node tertentu, sesuai dengan label yg di tentukan



tambahkan label ke dalam node

```bash

kubectl get node

# NAME       STATUS   ROLES           AGE   VERSION
# minikube   Ready    control-plane   28h   v1.30.0

kubectl label node node_name key=value

kubectl label node minikube gpu=true #<<<<------------------ NODE DI BERI NODE SELECTOR gpu=true


kubectl describe node minikube
# Name:               minikube
# Roles:              control-plane
# Labels:             beta.kubernetes.io/arch=amd64
#                     beta.kubernetes.io/os=linux
#                     gpu=true
#                     gpue=true
#                     kubernetes.io/arch=amd64
#                     kubernetes.io/hostname=minikube
#                     kubernetes.io/os=linux
#                     minikube.k8s.io/commit=86fc9d54fca63f295d8737c8eacdbb7987e89c67
#                     minikube.k8s.io/name=minikube
#                     minikube.k8s.io/primary=true
#                     minikube.k8s.io/updated_at=2024_08_20T02_16_15_0700
#                     minikube.k8s.io/version=v1.33.0
#                     node-role.kubernetes.io/control-plane=
#                     node.kubernetes.io/exclude-from-external-load-balancers=




```


template


[pod-node-selector.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/templates/pod-node-selector.yaml)

```yml
apiVersion: v1
kind: Pod
metadata:
  name: pod-name
spec:
  nodeSelector:
    gpu: "true"
  containers:
    - name: container-name
      image: image-name
      ports:
        - containerPort: 80
```

[job-node-selector.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/templates/job-node-selector.yaml)

```yml
apiVersion: batch/v1
kind: Job
metadata:
  name: job-name
  labels:
    label-key1: label-value1
  annotations:
    annotation-key1: annotation-value1
spec:
  completions: 5
  parallelism: 2
  selector:
    matchLabels:
      abel-key1: label-value1
  template:
    metadata:
      name: pod-name
      labels:
        label-key1: label-value1
    spec:
      restartPolicy: Never
      nodeSelector:
        hardisk: ssd
      containers:
        - name: container-name
          image: image-name
          ports:
            - containerPort: 80
```

[daemon-set-node-selector.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/templates/daemon-set-node-selector.yaml)

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
      nodeSelector:
        hardisk: ssd 
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

[cronjob-node-selector.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/templates/cronjob-node-selector.yaml)

```yml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: cron-job-name
  labels:
    label-key: label-value
  annotations:
    annotation-key1: annotation-value1
spec:
  schedule: "* * * * *"
  jobTemplate:
    spec:
      selector:
        matchLabels:
          abel-key1: label-value1
      template:
        metadata:
          name: pod-name
          labels:
            app: pod-la
        spec:
          restartPolicy: Never
          nodeSelector:
            hardisk: ssd
          containers:
            - name: container-name
              image: image-name
              ports:
                - containerPort: 80
```

[replica-set-node-selector.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/templates/replica-set-node-selector.yaml)

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
  template:
    metadata:
      name: pod-name
      labels:
        label-key1: label-value1
    spec:
      nodeSelector:
        hardisk: ssd
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


=============== EXAMPLE


replace [resource] with kubernetes resource

```bash
mkdir -p /home/ubuntu/KUBERNETES_FILE/[resource] && 
cd /home/ubuntu/KUBERNETES_FILE/[resource] && 
nano [resource]_nginx.yaml
```

```yml
apiVersion: v1
kind: [resource]
metadata:
  name: [resource]_nginx
spec:
# ============== nodeSelector
  nodeSelector:
    gpu: "true"
# ============== /nodeSelector
  containers:
    - name: nginx-320
      image: nginx:stable-alpine3.20
      ports:
        - containerPort: 80
```


```bash
cd /home/ubuntu/KUBERNETES_FILE/[resource] &&
kubectl create -f [resource]_nginx.yaml --namespace default
```

//------------------------------


```bash
mkdir -p /home/ubuntu/KUBERNETES_FILE/pod && 
cd /home/ubuntu/KUBERNETES_FILE/pod && 
nano pod_node_selector_nginx_gpu.yaml
```

```yml
apiVersion: v1
kind: Pod
metadata:
  name: pod-node-selector-nginx-gpu
spec:
  nodeSelector:
    gpu: "true"
  containers:
    - name: nginx-320
      image: nginx:stable-alpine3.20
      ports:
        - containerPort: 80
```




```bash
cd /home/ubuntu/KUBERNETES_FILE/pod &&
kubectl create -f pod_node_selector_nginx_gpu.yaml --namespace default


# karena 

# kubectl label node minikube gpu=true 


#ketika membuat nginx dengan node selector akan berhasil
# tetapi jika nodeSelector selain gpu akab bermasalah 
```



misal



```bash
mkdir -p /home/ubuntu/KUBERNETES_FILE/pod && 
cd /home/ubuntu/KUBERNETES_FILE/pod && 
nano pod_node_selector_nginx_ssd.yaml
```

```yml
apiVersion: v1
kind: Pod
metadata:
  name: pod-node-selector-nginx-ssd
spec:
  nodeSelector:
    ssd: "true"
  containers:
    - name: nginx-320
      image: nginx:stable-alpine3.20
      ports:
        - containerPort: 80
```


```bash
cd /home/ubuntu/KUBERNETES_FILE/pod &&
kubectl create -f pod_node_selector_nginx_ssd.yaml --namespace default


# karena 

# kubectl label node minikube gpu=true 

# NAME                              READY   STATUS    RESTARTS   AGE
# pod/pod-node-selector-nginx       1/1     Running   0          84s
# pod/pod-node-selector-nginx-ssd   0/1     Pending   0          33s <!---- akan selalu pending kalo butuh node ssd=true

# NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
# service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   13m

```


``` bash

kubectl get all
kubectl get pod pod-node-selector-nginx
kubectl get all --namespace default
kubectl logs  pod-node-selector-nginx
kubectl describe pod pod-node-selector-nginx
kubectl delete pod pod-node-selector-nginx

kubectl delete all --all # semua akan terhapus untuk service2 yang di butuhkan kubernetes akan tetap ada (terbuat ulang otomatis
kubectl delete all --all --namespace default

kubectl get all 
kubectl get all --namespace default
```


=============== EXAMPLE