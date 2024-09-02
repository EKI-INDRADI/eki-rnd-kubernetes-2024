computational resources = pembagian hardware / manage resource hardware

tujuannya : jangan sampai pod yang sibuk membuat semua pod di node(vm) yang sama menjadi lambat karena resource nya terpakai penuh oleh pod yang sibuk


request dan limit = mekanisme penggunaan control memory dan cpu
request = jika container request digaransi 1gb , dan hanya akan menjalankan node(vm) yg memiliki resource tersebut
limit = memastikan bahwa container tidak akan pernah melewati resource tersebut, container hanya boleh menggunakan resource sampai limit (jika melewati limit, kemungkinan bs di kill oleh kubernetesnya)

contoh :

request memory 5GB dan limit 10GB, di garansi dapet memory 5gb minimal dan batas atas 10GB, jika lebih dari itu akankena outof memory pada containernya




Template  :
[pod-with-resource.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/templates/pod-with-resource.yaml)


```yaml

apiVersion: v1
kind: Pod
metadata:
  name: pod-name
  labels:
    label-key1: label-value1
    label-key2: label-value2
    label-key3: label-value3
spec:
  volumes:
    - name: volume-name
      emptyDir: {}
  containers:
    - name: container-name
      image: image-name
      ports:
        - containerPort: 80
      resources:
        requests:
          # milli core , 1 core = 1000M
          cpu: 1000m
          # mebibyte , 250Mi (mebibytes/MiB) = 262.144M (megabytes/MB)  , 1 MiB (Mebibyte) ≈ 1.048576 MB (Megabytes).
          memory: 250Mi
        limits:
          # milli core, 1 core = 1000M
          cpu: 2000m
          # mebibyte , 250Mi  (mebibytes/MiB) = 524.288M (megabytes/MB), 1 MiB (Mebibyte) ≈ 1.048576 MB (Megabytes).
          memory: 500Mi

```

Contoh :
[resources.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/examples/resources.yaml)

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
          image: khannedy/nodejs-web
          ports:
            - containerPort: 3000
          resources:
            requests:
              cpu: 1000m
              memory: 1000Mi
            limits:
              cpu: 1000m
              memory: 1000Mi

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

SPEC SERVER AZURE VM
Standard D2s v3 (2 vcpus, 8 GiB memory)


```bash
kubectl delete all --all
kubectl delete pv --all
kubectl delete pvc --all


mkdir -p /home/ubuntu/KUBERNETES_FILE/service &&
cd /home/ubuntu/KUBERNETES_FILE/service &&
nano service_resources.yaml

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
          image: khannedy/nodejs-web
          ports:
            - containerPort: 3000
          resources:
            requests:
              cpu: 150m
              # artinya 1000m = 1 core * replicas
              memory: 300Mi
               # artinya 500Mi = 550MB-+
            limits:
              cpu: 150m
              memory: 300Mi
          # resources: #SEBELUMNYA V1
          #   requests:
          #     cpu: 1000m
          #     memory: 1000Mi
          #   limits:
          #     cpu: 1000m
          #     memory: 1000Mi

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
kubectl apply -f service_resources.yaml  --namespace default

# deployment.apps/nodejs-web created
# service/nodejs-web-service created


kubectl get all

# NAME                              READY   STATUS    RESTARTS   AGE
# pod/nodejs-web-7f94fbccf7-98hsz   0/1     Pending   0          116s <!--- bakalan pending terus karena CPU hardware nya cuma 2 CORE , di request 1 core x3 (repset)
# pod/nodejs-web-7f94fbccf7-bng5t   1/1     Running   0          116s
# pod/nodejs-web-7f94fbccf7-mrhc8   0/1     Pending   0          116s

# NAME                         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
# service/kubernetes           ClusterIP   10.96.0.1       <none>        443/TCP          8m11s
# service/nodejs-web-service   NodePort    10.105.74.248   <none>        3000:30001/TCP   116s

# NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
# deployment.apps/nodejs-web   1/3     3            1           116s

# NAME                                    DESIRED   CURRENT   READY   AGE
# replicaset.apps/nodejs-web-7f94fbccf7   3         3         1       116s



# update config turunin spec jadi 200m cpu 500MI memory
kubectl apply -f service_resources.yaml  --namespace default
# AKAN TETAP KARENA CASE DEPLOYMENT JUMLAH RESOURCE YG  DIGUNAKAN di X2 SEMUA , KARENA START NEW_RESOURCE &  STOP OLD_RESOURCE 

kubectl get all
# NAME                              READY   STATUS    RESTARTS   AGE
# pod/nodejs-web-59b4fdc5c5-lqrh7   0/1     Pending   0          10s
# pod/nodejs-web-7f94fbccf7-bng5t   1/1     Running   0          9m14s
# pod/nodejs-web-7f94fbccf7-mrhc8   0/1     Pending   0          9m14s
# pod/nodejs-web-d9fd99bcc-9mn9z    0/1     Pending   0          2m42s

# NAME                         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
# service/kubernetes           ClusterIP   10.96.0.1       <none>        443/TCP          15m
# service/nodejs-web-service   NodePort    10.105.74.248   <none>        3000:30001/TCP   9m14s

# NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
# deployment.apps/nodejs-web   1/3     1            1           9m14s

# NAME                                    DESIRED   CURRENT   READY   AGE
# replicaset.apps/nodejs-web-59b4fdc5c5   1         1         0       10s
# replicaset.apps/nodejs-web-7f94fbccf7   2         2         1       9m14s
# replicaset.apps/nodejs-web-d9fd99bcc    1         1         0       2m42s

kubectl delete -f service_resources.yaml  --namespace default
# deployment.apps "nodejs-web" deleted
# service "nodejs-web-service" deleted


# copy paste config lagi n buat baru turunin spec jadi 150m cpu 300MI memory
kubectl apply -f service_resources.yaml  --namespace default
# deployment.apps/nodejs-web created
# service/nodejs-web-service created
kubectl get all
# NAME                             READY   STATUS    RESTARTS   AGE
# pod/nodejs-web-cc9f8b46c-7gb6s   1/1     Running   0          21s
# pod/nodejs-web-cc9f8b46c-k4v7s   1/1     Running   0          21s
# pod/nodejs-web-cc9f8b46c-kq68x   1/1     Running   0          21s

# NAME                         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
# service/kubernetes           ClusterIP   10.96.0.1       <none>        443/TCP          24m
# service/nodejs-web-service   NodePort    10.103.173.73   <none>        3000:30001/TCP   21s

# NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
# deployment.apps/nodejs-web   3/3     3            3           21s

# NAME                                   DESIRED   CURRENT   READY   AGE
# replicaset.apps/nodejs-web-cc9f8b46c   3         3         3       21s


```

# check total minikube use
```bash
# View resourece node
kubectl top nodes
# NAME       CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%
# minikube   185m         9%     939Mi           11%

# View resource pods
kubectl top pods --all-namespaces
# NAMESPACE              NAME                                        CPU(cores)   MEMORY(bytes)
# ingress-nginx          ingress-nginx-controller-84df5799c-kpcbv    1m           41Mi
# kube-system            coredns-7db6d8ff4d-76r4c                    2m           21Mi
# kube-system            etcd-minikube                               16m          50Mi
# kube-system            kube-apiserver-minikube                     38m          205Mi
# kube-system            kube-controller-manager-minikube            11m          60Mi
# kube-system            kube-proxy-2g8vm                            1m           14Mi
# kube-system            kube-scheduler-minikube                     3m           19Mi
# kube-system            metrics-server-c59844bb4-bnd78              3m           19Mi
# kube-system            storage-provisioner                         2m           18Mi
# kubernetes-dashboard   dashboard-metrics-scraper-b5fc48f67-ww5fr   1m           18Mi
# kubernetes-dashboard   kubernetes-dashboard-779776cb65-xqjhp       1m           39Mi


#  View Resource Usage Summary
kubectl get --all-namespaces pods -o=custom-columns=NAMESPACE:.metadata.namespace,POD:.metadata.name,CPU_REQUEST:.spec.containers[*].resources.requests.cpu,MEMORY_REQUEST:.spec.containers[*].resources.requests.memory,CPU_LIMIT:.spec.containers[*].resources.limits.cpu,MEMORY_LIMIT:.spec.containers[*].resources.limits.memory



```