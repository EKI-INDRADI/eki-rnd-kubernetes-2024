Horizontal pod autoscler


ketika pod sedang sibuk , maka memory/cpu tinggi == performance aplikasi akan turun, maka dari itu application scaling dibutuhkan, ada 2 jenis application scaling vertical scaling dan horizontal scaling





vertical scaling = upgrade computational resource aplikasi kita (hardware ex : cpu/memory)

horizontal scaling = membuat pod baru agar beban pekerjaan bisa di distribusikan ke pod baru tersebut (ex : replicaset)



di kubernetes ada : 

## vertical pod autoscaler

vertical pod autosclaer = secara otomatis application secara vertical dengan cara mengupgrade resource pod dan menurunkan secara otomatis jika tidak diperlukan.


## https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler


NOTE : BLM DI TEST

```bash
kubectl describe vpa

kubectl delete all --all

mkdir -p /home/ubuntu/KUBERNETES_FILE/service &&
cd /home/ubuntu/KUBERNETES_FILE/service &&
nano service_vertical_pod_auto_scaler.yaml
```

```yaml
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  name: my-app-vpa
spec:
  targetRef:
    apiVersion: "apps/v1"
    kind:       Deployment
    name:       my-app
  updatePolicy:
    updateMode: "Auto"
  # updatePolicy:
  #   evictionRequirements:
  #     - resources: ["cpu", "memory"]
  #       changeRequirement: TargetHigherThanRequests
```

```bash
cd /home/ubuntu/KUBERNETES_FILE/service &&
kubectl apply -f service_vertical_pod_auto_scaler.yaml  --namespace default


kubectl get all
kubectl --namespace=kube-system get pods|grep vpa
```


## horizontal pod autoscaler

horizontal pod autoscaler =  autoscaling secara horizontal dengan cara menambah pod baru dan menurutkan secara otomatis jika tidak diperlukan

logicnya , mendengarkan data metrics dari setiap pod jika sudah mencapai batas tertentu (baik itu menaikan jumlah pod atau menurunkan jumlah pod)

```bash

               KUBERNETES CLUSTER
____________________________________________________
           | DEPLOYMENT / REPLICASET |
   |------>|_________________________|-------|
   |                 |                       |
 ___________  _______v_______   _____________v_
| HPA       | | NODE1 (POD1) | |  NODE2 (POD1) |
|___________| |______________| |_______________|
    ^                |                      |
    |                |                      |
    |          ______v____________          |
    |-------  |  Metrics Server  | <--------|
              |__________________|


```


```bash
minikube addons list
# |-----------------------------|----------|--------------|--------------------------------|
# |         ADDON NAME          | PROFILE  |    STATUS    |           MAINTAINER           |
# |-----------------------------|----------|--------------|--------------------------------|
# | ambassador                  | minikube | disabled     | 3rd party (Ambassador)         |
# | auto-pause                  | minikube | disabled     | minikube                       |
# | cloud-spanner               | minikube | disabled     | Google                         |
# | csi-hostpath-driver         | minikube | disabled     | Kubernetes                     |
# | dashboard                   | minikube | enabled ✅   | Kubernetes                     |
# | default-storageclass        | minikube | enabled ✅   | Kubernetes                     |
# | efk                         | minikube | disabled     | 3rd party (Elastic)            |
# | freshpod                    | minikube | disabled     | Google                         |
# | gcp-auth                    | minikube | disabled     | Google                         |
# | gvisor                      | minikube | disabled     | minikube                       |
# | headlamp                    | minikube | disabled     | 3rd party (kinvolk.io)         |
# | helm-tiller                 | minikube | disabled     | 3rd party (Helm)               |
# | inaccel                     | minikube | disabled     | 3rd party (InAccel             |
# |                             |          |              | [info@inaccel.com])            |
# | ingress                     | minikube | enabled ✅   | Kubernetes                     |
# | ingress-dns                 | minikube | disabled     | minikube                       |
# | inspektor-gadget            | minikube | disabled     | 3rd party                      |
# |                             |          |              | (inspektor-gadget.io)          |
# | istio                       | minikube | disabled     | 3rd party (Istio)              |
# | istio-provisioner           | minikube | disabled     | 3rd party (Istio)              |
# | kong                        | minikube | disabled     | 3rd party (Kong HQ)            |
# | kubeflow                    | minikube | disabled     | 3rd party                      |
# | kubevirt                    | minikube | disabled     | 3rd party (KubeVirt)           |
# | logviewer                   | minikube | disabled     | 3rd party (unknown)            |
# | metallb                     | minikube | disabled     | 3rd party (MetalLB)            |
# | metrics-server              | minikube | enabled ✅   | Kubernetes                     |
# | nvidia-device-plugin        | minikube | disabled     | 3rd party (NVIDIA)             |
# | nvidia-driver-installer     | minikube | disabled     | 3rd party (Nvidia)             |
# | nvidia-gpu-device-plugin    | minikube | disabled     | 3rd party (Nvidia)             |
# | olm                         | minikube | disabled     | 3rd party (Operator Framework) |
# | pod-security-policy         | minikube | disabled     | 3rd party (unknown)            |
# | portainer                   | minikube | disabled     | 3rd party (Portainer.io)       |
# | registry                    | minikube | disabled     | minikube                       |
# | registry-aliases            | minikube | disabled     | 3rd party (unknown)            |
# | registry-creds              | minikube | disabled     | 3rd party (UPMC Enterprises)   |
# | storage-provisioner         | minikube | enabled ✅   | minikube                       |
# | storage-provisioner-gluster | minikube | disabled     | 3rd party (Gluster)            |
# | storage-provisioner-rancher | minikube | disabled     | 3rd party (Rancher)            |
# | volumesnapshots             | minikube | disabled     | Kubernetes                     |
# | yakd                        | minikube | disabled     | 3rd party (marcnuri.com)       |
# |-----------------------------|----------|--------------|--------------------------------|


minikube addons enbale metrics-server # kalo belum di enable wajib enable


kubectl get all --namespace kube-system
# service/kube-dns         ClusterIP   10.96.0.10      <none>        53/UDP,53/TCP,9153/TCP   7d3h
# service/metrics-server   ClusterIP   10.99.194.141   <none>        443/TCP                  177m

# NAME                        DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
# daemonset.apps/kube-proxy   1         1         1       1            1           kubernetes.io/os=linux   7d3h

# NAME                             READY   UP-TO-DATE   AVAILABLE   AGE
# deployment.apps/coredns          1/1     1            1           7d3h
# deployment.apps/metrics-server   1/1     1            1           177m

# NAME                                       DESIRED   CURRENT   READY   AGE
# replicaset.apps/coredns-7db6d8ff4d         1         1         1       7d3h
# replicaset.apps/metrics-server-c59844bb4   1         1         1       177m

```



create HPA
```bash
kubectl apply -f hpa.yml
or
kubectl create -f hpa.yml

kubectl describe hpa hpa_name

kubectl delete hpa hpa_name
```

contoh

Template :
[horizontal-pod-autoscaler.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/templates/horizontal-pod-autoscaler.yaml)

```yaml

apiVersion: autoscaling/v2beta2
kind: HorizontalPodAutoscaler
metadata:
  name: hpa-name
spec:
  minReplicas: 3 #jika kondisi  cpu/memory belum menyentuh 70%, maka tetap 3 , jika lebih dari 70 maka akan ke set maxinal pod
  maxReplicas: 5
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: deployment-name
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70 #70% SET
    - type: Resource
      resource:
        name: memory # note : ati2 untuk monitoring memory , ada beberapa aplikasi yg kalo udah naik memorynya gak mau turun contoh mongodb , java , dll
        # jika tidak yakin aplikasinya bs berkurang memory maka cukup menggunakan cpu metriks saja
        target:
          type: Utilization
          averageUtilization: 70 #70% SET

```

Contoh :
[horizontal-pod-autoscaler.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/examples/horizontal-pod-autoscaler.yaml)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nodejs-web
  labels:
    name: nodejs-web
spec:
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

---

apiVersion: autoscaling/v2beta2
kind: HorizontalPodAutoscaler
metadata:
  name: hpa-name
spec:
  minReplicas: 3
  maxReplicas: 5
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: nodejs-web
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
    - type: Resource
      resource:
        name: memory
        target:
          type: Utilization
          averageUtilization: 70
```




COBA




```bash
kubectl describe hpa

kubectl delete all --all

mkdir -p /home/ubuntu/KUBERNETES_FILE/service &&
cd /home/ubuntu/KUBERNETES_FILE/service &&
nano service_horizontal_pod_auto_scaler.yaml
```

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nodejs-web
  labels:
    name: nodejs-web
spec:
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

# NOTE REPSET TIDAK DI SET KARENA DI SET DI HPA

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

---

apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: hpa-name
spec:
  minReplicas: 3
  maxReplicas: 5
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: nodejs-web
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
    - type: Resource
      resource:
        name: memory
        target:
          type: Utilization
          averageUtilization: 70
```

```bash
cd /home/ubuntu/KUBERNETES_FILE/service &&
kubectl apply -f service_horizontal_pod_auto_scaler.yaml  --namespace default
# deployment.apps/nodejs-web created
# service/nodejs-web-service created
# horizontalpodautoscaler.autoscaling/hpa-name created


kubectl get all
# NAME                              READY   STATUS    RESTARTS   AGE
# pod/nodejs-web-6785b496c8-dwp6b   1/1     Running   0          13s

# NAME                         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
# service/kubernetes           ClusterIP   10.96.0.1        <none>        443/TCP          4m
# service/nodejs-web-service   NodePort    10.110.177.133   <none>        3000:30001/TCP   13s

# NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
# deployment.apps/nodejs-web   1/1     1            1           13s

# NAME                                    DESIRED   CURRENT   READY   AGE
# replicaset.apps/nodejs-web-6785b496c8   1         1         1       13s

# NAME                                           REFERENCE               TARGETS                                     MINPODS   MAXPODS   REPLICAS   AGE
# horizontalpodautoscaler.autoscaling/hpa-name   Deployment/nodejs-web   cpu: <unknown>/70%, memory: <unknown>/70%   3         5         0          13s

kubectl get all
# NAME                              READY   STATUS    RESTARTS   AGE
# pod/nodejs-web-6785b496c8-8lct2   1/1     Running   0          79s
# pod/nodejs-web-6785b496c8-dwp6b   1/1     Running   0          94s
# pod/nodejs-web-6785b496c8-qvt2k   1/1     Running   0          79s

# NAME                         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
# service/kubernetes           ClusterIP   10.96.0.1        <none>        443/TCP          5m21s
# service/nodejs-web-service   NodePort    10.110.177.133   <none>        3000:30001/TCP   94s

# NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
# deployment.apps/nodejs-web   3/3     3            3           94s

# NAME                                    DESIRED   CURRENT   READY   AGE
# replicaset.apps/nodejs-web-6785b496c8   3         3         3       94s

# NAME                                           REFERENCE               TARGETS                                     MINPODS   MAXPODS   REPLICAS   AGE
# horizontalpodautoscaler.autoscaling/hpa-name   Deployment/nodejs-web   cpu: <unknown>/70%, memory: <unknown>/70%   3         5         3          94s




# NOTE : di sarankan MinReplicas :2 , jadi kalo ada 1 tiba2 mati ada backup

# di production wajib menggunakan HPA
```




