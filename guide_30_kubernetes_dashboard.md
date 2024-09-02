kubernetes dashboard


sebelumnya selalu menggnakan terminal untuk manage object di kubernetes



di kenyataannya mungkin nanati kita akan menggunakan cloud provider untuk manage object di kubernetes.

dimana cloud provider sudah menyediakan web user internaface untuk manager oobject kubernetesnya


kalo di data center sendiri kita juga bs menginstal web user interface untuk manage object di kubernetes

namanya

kubernetes dashboard = opensource untuk manager object kubernetes web



```bash

minikube addons list
# |-----------------------------|----------|--------------|--------------------------------|
# |         ADDON NAME          | PROFILE  |    STATUS    |           MAINTAINER           |
# |-----------------------------|----------|--------------|--------------------------------|
# | ambassador                  | minikube | disabled     | 3rd party (Ambassador)         |
# | auto-pause                  | minikube | disabled     | minikube                       |
# | cloud-spanner               | minikube | disabled     | Google                         |
# | csi-hostpath-driver         | minikube | disabled     | Kubernetes                     |
# | dashboard                   | minikube | disabled     | Kubernetes                     |
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
# | metrics-server              | minikube | disabled     | Kubernetes                     |
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

minikube addons enable dashboard
# * dashboard is an addon maintained by Kubernetes. For any concerns contact minikube on GitHub.
# You can view the list of minikube maintainers at: https://github.com/kubernetes/minikube/blob/master/OWNERS
#   - Using image docker.io/kubernetesui/dashboard:v2.7.0
#   - Using image docker.io/kubernetesui/metrics-scraper:v1.0.8
# * Some dashboard features require the metrics-server addon. To enable all features please run:

#         minikube addons enable metrics-server

# * The 'dashboard' addon is enabled

minikube addons enable metrics-server
# * metrics-server is an addon maintained by Kubernetes. For any concerns contact minikube on GitHub.
# You can view the list of minikube maintainers at: https://github.com/kubernetes/minikube/blob/master/OWNERS
#   - Using image registry.k8s.io/metrics-server/metrics-server:v0.7.1
# * The 'metrics-server' addon is enabled

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


kubectl get all --namespace kubernetes-dashboard
# NAME                                            READY   STATUS    RESTARTS   AGE
# pod/dashboard-metrics-scraper-b5fc48f67-ww5fr   1/1     Running   0          2m55s
# pod/kubernetes-dashboard-779776cb65-xqjhp       1/1     Running   0          2m55s

# NAME                                TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
# service/dashboard-metrics-scraper   ClusterIP   10.104.50.141    <none>        8000/TCP   2m55s
# service/kubernetes-dashboard        ClusterIP   10.109.245.186   <none>        80/TCP     2m55s

# NAME                                        READY   UP-TO-DATE   AVAILABLE   AGE
# deployment.apps/dashboard-metrics-scraper   1/1     1            1           2m55s
# deployment.apps/kubernetes-dashboard        1/1     1            1           2m55s

# NAME                                                  DESIRED   CURRENT   READY   AGE
# replicaset.apps/dashboard-metrics-scraper-b5fc48f67   1         1         1       2m55s
# replicaset.apps/kubernetes-dashboard-779776cb65       1         1         1       2m55s

minikube dashboard

# * Verifying dashboard health ...
# * Launching proxy ...
# * Verifying proxy health ...
# * Opening http://127.0.0.1:44471/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/ in your default browser...
#   http://127.0.0.1:44471/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/

NOTE : hanya berjalan pada local IP kubernetes



```

[for_ip_public](guide_30_kubernetes_dashboard_ip_public.md) hrs enable proxy 0.0.0.0


Gunakan tanda + (pojok kanan atas) untuk membuat resource
pada overview bisa edit resource dan memunculkan configurasi untuk edit


create from input :
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