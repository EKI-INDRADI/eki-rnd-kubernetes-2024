ingress = mengekspose menggunakan domain, jika menggunkn nodePort/load balancer mka client hrs tau semua ip address semua node/load balancer, ingress hanya mendukung protocol http

kalo di amazon /azure,dll

biasanya sudah ada add-on untuk menginstall ingress , suapaya bs auto generate domain

https://learn.microsoft.com/en-us/azure/aks/app-routing?tabs=default%2Cdeploy-app-default

ingress == sebenarnya adalah nginx


menjalankan ingres di minikube

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
# | ingress                     | minikube | disabled     | Kubernetes                     |
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

minikube addons enable ingress
# * ingress is an addon maintained by Kubernetes. For any concerns contact minikube on GitHub.
# You can view the list of minikube maintainers at: https://github.com/kubernetes/minikube/blob/master/OWNERS
#   - Using image registry.k8s.io/ingress-nginx/controller:v1.10.0
#   - Using image registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.4.0
#   - Using image registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.4.0
# * Verifying ingress addon...
# * The 'ingress' addon is enabled

# https://kubernetes.github.io/ingress-nginx/troubleshooting/
kubectl get svc --all-namespaces
# default         kubernetes                           ClusterIP   10.96.0.1        <none>        443/TCP                      4m8s
# ingress-nginx   ingress-nginx-controller             NodePort    10.97.136.163    <none>        80:31601/TCP,443:31950/TCP   105m
# ingress-nginx   ingress-nginx-controller-admission   ClusterIP   10.105.115.109   <none>        443/TCP                      105m
# kube-system     kube-dns                             ClusterIP   10.96.0.10       <none>        53/UDP,53/TCP,9153/TCP       2d7h

kubectl get pod --all-namespaces
# NAMESPACE       NAME                                       READY   STATUS      RESTARTS        AGE
# ingress-nginx   ingress-nginx-admission-create-9v262       0/1     Completed   0               115m
# ingress-nginx   ingress-nginx-admission-patch-75t7r        0/1     Completed   0               115m
# ingress-nginx   ingress-nginx-controller-84df5799c-kpcbv   1/1     Running     0               115m
# kube-system     coredns-7db6d8ff4d-76r4c                   1/1     Running     5 (3h2m ago)    2d7h
# kube-system     etcd-minikube                              1/1     Running     5 (3h2m ago)    2d7h
# kube-system     kube-apiserver-minikube                    1/1     Running     5 (3h2m ago)    2d7h
# kube-system     kube-controller-manager-minikube           1/1     Running     5 (3h2m ago)    2d7h
# kube-system     kube-proxy-2g8vm                           1/1     Running     5 (3h2m ago)    2d7h
# kube-system     kube-scheduler-minikube                    1/1     Running     5 (3h2m ago)    2d7h
# kube-system     storage-provisioner                        1/1     Running     10 (3h1m ago)   2d7h

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

kubectl get pods -n kube-system

kubectl get all --namespace kube-system
# NAME                                   READY   STATUS    RESTARTS       AGE
# pod/coredns-7db6d8ff4d-76r4c           1/1     Running   5 (73m ago)    2d5h
# pod/etcd-minikube                      1/1     Running   5 (73m ago)    2d5h
# pod/kube-apiserver-minikube            1/1     Running   5 (73m ago)    2d5h
# pod/kube-controller-manager-minikube   1/1     Running   5 (73m ago)    2d5h
# pod/kube-proxy-2g8vm                   1/1     Running   5 (73m ago)    2d5h
# pod/kube-scheduler-minikube            1/1     Running   5 (73m ago)    2d5h
# pod/storage-provisioner                1/1     Running   10 (72m ago)   2d5h

# NAME               TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)                  AGE
# service/kube-dns   ClusterIP   10.96.0.10   <none>        53/UDP,53/TCP,9153/TCP   2d5h

# NAME                        DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
# daemonset.apps/kube-proxy   1         1         1       1            1           kubernetes.io/os=linux   2d5h

# NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
# deployment.apps/coredns   1/1     1            1           2d5h

# NAME                                 DESIRED   CURRENT   READY   AGE
# replicaset.apps/coredns-7db6d8ff4d   1         1         1       2d5h



#NOTE : harusnya ada pod/ingress-inginx , tapi gak ada
```


```bash
cd /home/ubuntu/KUBERNETES_FILE/service &&
kubectl create -f service_nginx_ngiress.yaml --namespace default
kubectl get ingresses
kubectl delete ingre nama_service

minikube ip
kubectl get ingresses

minikube ip
# 192.168.49.2


sudo nano /etc/hosts
192.168.49.2 ingress.nginx.local
192.168.49.2 rnd-ingress.prieds.com
```

Template : 
[service-with-ingress.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/templates/service-with-ingress.yaml)

```yml

apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: ingress-name
  labels:
    label-key1: label-value1
spec:
  rules:
    - host: sub.domain.com
      http:
        paths:
          - path: /
            backend:
              serviceName: service-name
              servicePort: 80

```

Contoh : 
[service-nginx-ingress.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/examples/service-nginx-ingress.yaml)


```bash
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      name: nginx
  template:
    metadata:
      name: nginx
      labels:
        name: nginx
    spec:
      containers:
        - name: nginx
          image: nginx
          ports:
            - containerPort: 80

---

apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    name: nginx
  ports:
    - port: 80
      targetPort: 80

---

apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: nginx-ingress
  labels:
    name: nginx-ingress
spec:
  rules:
    - host: nginx.khannedy.local
      http:
        paths:
          - path: /
            backend:
              serviceName: nginx-service
              servicePort: 80

```





COBA
<!-- https://kubernetes.io/docs/reference/kubernetes-api/service-resources/ingress-v1/ -->

```bash
kubectl delete all --all
kubectl delete ingress ingress-nginx-with-ingress
kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission ##(SOLVED VALIDATE)


mkdir -p /home/ubuntu/KUBERNETES_FILE/service && 
cd /home/ubuntu/KUBERNETES_FILE/service && 
nano service_nginx_with_ingress.yaml
```

```bash
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: pod-nginx-with-ingress
spec:
  replicas: 3
  selector:
    matchLabels:
      app-selector: app-pod-nginx-with-ingress
  template:
    metadata:
      name: pod-nginx-with-ingress
      labels:
        app-selector: app-pod-nginx-with-ingress
    spec:
      containers:
        - name: nginx-320
          image: nginx:stable-alpine3.20
          ports:
            - containerPort: 80


---

apiVersion: v1
kind: Service
metadata:
  name: service-nginx-with-ingress
spec:
  selector:
    app-selector: app-pod-nginx-with-ingress
  ports:
    - port: 80
      targetPort: 80

---

#https://kubernetes.io/docs/reference/using-api/deprecation-guide/

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-nginx-with-ingress
  labels:
    name: ingress-nginx-with-ingress
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
    # nginx.ingress.kubernetes.io/rewrite-target: /rnd
    # nginx.ingress.kubernetes.io/use-regex: "true"
spec:
  # ingressClassName: nginx
  rules:
    - host: rnd-ingress.prieds.com
      http:
        paths:
          - path: /
          # - path: /rnd
            pathType: Prefix
            backend:
              service:
                 name: service-nginx-with-ingress
                 port:
                   number: 80
```

```bash
cd /home/ubuntu/KUBERNETES_FILE/service &&
kubectl create -f service_nginx_with_ingress.yaml  --namespace default

# replicaset.apps/pod-nginx-with-ingress created
# service/service-nginx-with-ingress created
# ingress.networking.k8s.io/ingress-nginx-with-ingress created

minikube ip
# 192.168.49.2

kubectl get ingress
# NAME                         CLASS   HOSTS                 ADDRESS   PORTS   AGE
# ingress-nginx-with-ingress   nginx   ingress.nginx.local             80      37s

kubectl get all
# NAME                               READY   STATUS    RESTARTS   AGE
# pod/pod-nginx-with-ingress-9hfqp   1/1     Running   0          2m24s
# pod/pod-nginx-with-ingress-r956s   1/1     Running   0          2m24s
# pod/pod-nginx-with-ingress-t4bgq   1/1     Running   0          2m24s

# NAME                                 TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
# service/kubernetes                   ClusterIP   10.96.0.1      <none>        443/TCP   2m40s
# service/service-nginx-with-ingress   ClusterIP   10.99.185.14   <none>        80/TCP    2m24s

# NAME                                     DESIRED   CURRENT   READY   AGE
# replicaset.apps/pod-nginx-with-ingress   3         3         3       2m24s

minikube service service-nginx-with-ingress --namespace default

# |-----------|----------------------------|-------------|--------------|
# | NAMESPACE |            NAME            | TARGET PORT |     URL      |
# |-----------|----------------------------|-------------|--------------|
# | default   | service-nginx-with-ingress |             | No node port |
# |-----------|----------------------------|-------------|--------------|
# * service default/service-nginx-with-ingress has no node port
# ! Services [default/service-nginx-with-ingress] have type "ClusterIP" not meant to be exposed, however for local development minikube allows you to access this !
# * Starting tunnel for service service-nginx-with-ingress.
# |-----------|----------------------------|-------------|------------------------|
# | NAMESPACE |            NAME            | TARGET PORT |          URL           |
# |-----------|----------------------------|-------------|------------------------|
# | default   | service-nginx-with-ingress |             | http://127.0.0.1:39549 |
# |-----------|----------------------------|-------------|------------------------|
# * Opening service default/service-nginx-with-ingress in default browser...
#   http://127.0.0.1:39549
# ! Because you are using a Docker driver on linux, the terminal needs to be open to run it.
# ^C* Stopping tunnel for service service-nginx-with-ingress.


#--------------------- SOLVED

# replicaset.apps/pod-nginx-with-ingress created
# service/service-nginx-with-ingress created
# Error from server (InternalError): error when creating "service_nginx_with_ingress.yaml": Internal error occurred: failed calling webhook "validate.nginx.ingress.kubernetes.io": failed to call webhook: Post "https://ingress-nginx-controller-admission.ingress-nginx.svc:443/networking/v1/ingresses?timeout=10s": tls: failed to verify certificate: x509: certificate signed by unknown authority

kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission

#--------------------- /SOLVED



curl http://rnd-ingress.prieds.com

# <!DOCTYPE html>
# <html>
# <head>
# <title>Welcome to nginx!</title>
# <style>
# html { color-scheme: light dark; }
# body { width: 35em; margin: 0 auto;
# font-family: Tahoma, Verdana, Arial, sans-serif; }
# </style>
# </head>
# <body>
# <h1>Welcome to nginx!</h1>
# <p>If you see this page, the nginx web server is successfully installed and
# working. Further configuration is required.</p>

# <p>For online documentation and support please refer to
# <a href="http://nginx.org/">nginx.org</a>.<br/>
# Commercial support is available at
# <a href="http://nginx.com/">nginx.com</a>.</p>

# <p><em>Thank you for using nginx.</em></p>
# </body>
# </html>


#untuk akses public perlu deployment
# ----------------------------------------------------------------
# example : https://stackoverflow.com/questions/61365202/nginx-ingress-service-ingress-nginx-controller-admission-not-found

# Deployment ex : https://stackoverflow.com/questions/61616203/nginx-ingress-controller-failed-calling-webhook/61681896#61681896

# https://kubernetes.io/docs/concepts/services-networking/ingress/


 https://kubernetes.github.io/ingress-nginx/deploy/#docker-for-mac 

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.40.2/deploy/static/provider/cloud/deploy.yaml

kubectl get all --namespace ingress-nginx

```

```yaml

apiVersion: v1
kind: Namespace
metadata:
  name: ingress-nginx
  labels:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/instance: ingress-nginx

---
# Source: ingress-nginx/templates/controller-serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    helm.sh/chart: ingress-nginx-3.4.1
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/version: 0.40.2
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/component: controller
  name: ingress-nginx
  namespace: ingress-nginx
---
# Source: ingress-nginx/templates/controller-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  labels:
    helm.sh/chart: ingress-nginx-3.4.1
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/version: 0.40.2
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/component: controller
  name: ingress-nginx-controller
  namespace: ingress-nginx
data:
---
# Source: ingress-nginx/templates/clusterrole.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    helm.sh/chart: ingress-nginx-3.4.1
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/version: 0.40.2
    app.kubernetes.io/managed-by: Helm
  name: ingress-nginx
rules:
  - apiGroups:
      - ''
    resources:
      - configmaps
      - endpoints
      - nodes
      - pods
      - secrets
    verbs:
      - list
      - watch
  - apiGroups:
      - ''
    resources:
      - nodes
    verbs:
      - get
  - apiGroups:
      - ''
    resources:
      - services
    verbs:
      - get
      - list
      - update
      - watch
  - apiGroups:
      - extensions
      - networking.k8s.io   # k8s 1.14+
    resources:
      - ingresses
    verbs:
      - get
      - list
      - watch
  - apiGroups:
      - ''
    resources:
      - events
    verbs:
      - create
      - patch
  - apiGroups:
      - extensions
      - networking.k8s.io   # k8s 1.14+
    resources:
      - ingresses/status
    verbs:
      - update
  - apiGroups:
      - networking.k8s.io   # k8s 1.14+
    resources:
      - ingressclasses
    verbs:
      - get
      - list
      - watch
---
# Source: ingress-nginx/templates/clusterrolebinding.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    helm.sh/chart: ingress-nginx-3.4.1
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/version: 0.40.2
    app.kubernetes.io/managed-by: Helm
  name: ingress-nginx
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: ingress-nginx
subjects:
  - kind: ServiceAccount
    name: ingress-nginx
    namespace: ingress-nginx
---
# Source: ingress-nginx/templates/controller-role.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  labels:
    helm.sh/chart: ingress-nginx-3.4.1
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/version: 0.40.2
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/component: controller
  name: ingress-nginx
  namespace: ingress-nginx
rules:
  - apiGroups:
      - ''
    resources:
      - namespaces
    verbs:
      - get
  - apiGroups:
      - ''
    resources:
      - configmaps
      - pods
      - secrets
      - endpoints
    verbs:
      - get
      - list
      - watch
  - apiGroups:
      - ''
    resources:
      - services
    verbs:
      - get
      - list
      - update
      - watch
  - apiGroups:
      - extensions
      - networking.k8s.io   # k8s 1.14+
    resources:
      - ingresses
    verbs:
      - get
      - list
      - watch
  - apiGroups:
      - extensions
      - networking.k8s.io   # k8s 1.14+
    resources:
      - ingresses/status
    verbs:
      - update
  - apiGroups:
      - networking.k8s.io   # k8s 1.14+
    resources:
      - ingressclasses
    verbs:
      - get
      - list
      - watch
  - apiGroups:
      - ''
    resources:
      - configmaps
    resourceNames:
      - ingress-controller-leader-nginx
    verbs:
      - get
      - update
  - apiGroups:
      - ''
    resources:
      - configmaps
    verbs:
      - create
  - apiGroups:
      - ''
    resources:
      - endpoints
    verbs:
      - create
      - get
      - update
  - apiGroups:
      - ''
    resources:
      - events
    verbs:
      - create
      - patch
---
# Source: ingress-nginx/templates/controller-rolebinding.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  labels:
    helm.sh/chart: ingress-nginx-3.4.1
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/version: 0.40.2
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/component: controller
  name: ingress-nginx
  namespace: ingress-nginx
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: ingress-nginx
subjects:
  - kind: ServiceAccount
    name: ingress-nginx
    namespace: ingress-nginx
---
# Source: ingress-nginx/templates/controller-service-webhook.yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    helm.sh/chart: ingress-nginx-3.4.1
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/version: 0.40.2
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/component: controller
  name: ingress-nginx-controller-admission
  namespace: ingress-nginx
spec:
  type: ClusterIP
  ports:
    - name: https-webhook
      port: 443
      targetPort: webhook
  selector:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/component: controller
---
# Source: ingress-nginx/templates/controller-service.yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    helm.sh/chart: ingress-nginx-3.4.1
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/version: 0.40.2
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/component: controller
  name: ingress-nginx-controller
  namespace: ingress-nginx
spec:
  type: LoadBalancer
  externalTrafficPolicy: Local
  ports:
    - name: http
      port: 80
      protocol: TCP
      targetPort: http
    - name: https
      port: 443
      protocol: TCP
      targetPort: https
  selector:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/component: controller
---
# Source: ingress-nginx/templates/controller-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    helm.sh/chart: ingress-nginx-3.4.1
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/version: 0.40.2
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/component: controller
  name: ingress-nginx-controller
  namespace: ingress-nginx
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: ingress-nginx
      app.kubernetes.io/instance: ingress-nginx
      app.kubernetes.io/component: controller
  revisionHistoryLimit: 10
  minReadySeconds: 0
  template:
    metadata:
      labels:
        app.kubernetes.io/name: ingress-nginx
        app.kubernetes.io/instance: ingress-nginx
        app.kubernetes.io/component: controller
    spec:
      dnsPolicy: ClusterFirst
      containers:
        - name: controller
          image: k8s.gcr.io/ingress-nginx/controller:v0.40.2@sha256:46ba23c3fbaafd9e5bd01ea85b2f921d9f2217be082580edc22e6c704a83f02f
          imagePullPolicy: IfNotPresent
          lifecycle:
            preStop:
              exec:
                command:
                  - /wait-shutdown
          args:
            - /nginx-ingress-controller
            - --publish-service=$(POD_NAMESPACE)/ingress-nginx-controller
            - --election-id=ingress-controller-leader
            - --ingress-class=nginx
            - --configmap=$(POD_NAMESPACE)/ingress-nginx-controller
            - --validating-webhook=:8443
            - --validating-webhook-certificate=/usr/local/certificates/cert
            - --validating-webhook-key=/usr/local/certificates/key
          securityContext:
            capabilities:
              drop:
                - ALL
              add:
                - NET_BIND_SERVICE
            runAsUser: 101
            allowPrivilegeEscalation: true
          env:
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
            - name: POD_NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
            - name: LD_PRELOAD
              value: /usr/local/lib/libmimalloc.so
          livenessProbe:
            httpGet:
              path: /healthz
              port: 10254
              scheme: HTTP
            initialDelaySeconds: 10
            periodSeconds: 10
            timeoutSeconds: 1
            successThreshold: 1
            failureThreshold: 5
          readinessProbe:
            httpGet:
              path: /healthz
              port: 10254
              scheme: HTTP
            initialDelaySeconds: 10
            periodSeconds: 10
            timeoutSeconds: 1
            successThreshold: 1
            failureThreshold: 3
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
            - name: https
              containerPort: 443
              protocol: TCP
            - name: webhook
              containerPort: 8443
              protocol: TCP
          volumeMounts:
            - name: webhook-cert
              mountPath: /usr/local/certificates/
              readOnly: true
          resources:
            requests:
              cpu: 100m
              memory: 90Mi
      serviceAccountName: ingress-nginx
      terminationGracePeriodSeconds: 300
      volumes:
        - name: webhook-cert
          secret:
            secretName: ingress-nginx-admission
---
# Source: ingress-nginx/templates/admission-webhooks/validating-webhook.yaml
# before changing this value, check the required kubernetes version
# https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/#prerequisites
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
metadata:
  labels:
    helm.sh/chart: ingress-nginx-3.4.1
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/version: 0.40.2
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/component: admission-webhook
  name: ingress-nginx-admission
webhooks:
  - name: validate.nginx.ingress.kubernetes.io
    rules:
      - apiGroups:
          - networking.k8s.io
        apiVersions:
          - v1beta1
          - v1
        operations:
          - CREATE
          - UPDATE
        resources:
          - ingresses
    failurePolicy: Fail
    sideEffects: None
    admissionReviewVersions:
      - v1
      - v1beta1
    clientConfig:
      service:
        namespace: ingress-nginx
        name: ingress-nginx-controller-admission
        path: /networking/v1beta1/ingresses
---
# Source: ingress-nginx/templates/admission-webhooks/job-patch/serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: ingress-nginx-admission
  annotations:
    helm.sh/hook: pre-install,pre-upgrade,post-install,post-upgrade
    helm.sh/hook-delete-policy: before-hook-creation,hook-succeeded
  labels:
    helm.sh/chart: ingress-nginx-3.4.1
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/version: 0.40.2
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/component: admission-webhook
  namespace: ingress-nginx
---
# Source: ingress-nginx/templates/admission-webhooks/job-patch/clusterrole.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: ingress-nginx-admission
  annotations:
    helm.sh/hook: pre-install,pre-upgrade,post-install,post-upgrade
    helm.sh/hook-delete-policy: before-hook-creation,hook-succeeded
  labels:
    helm.sh/chart: ingress-nginx-3.4.1
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/version: 0.40.2
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/component: admission-webhook
rules:
  - apiGroups:
      - admissionregistration.k8s.io
    resources:
      - validatingwebhookconfigurations
    verbs:
      - get
      - update
---
# Source: ingress-nginx/templates/admission-webhooks/job-patch/clusterrolebinding.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: ingress-nginx-admission
  annotations:
    helm.sh/hook: pre-install,pre-upgrade,post-install,post-upgrade
    helm.sh/hook-delete-policy: before-hook-creation,hook-succeeded
  labels:
    helm.sh/chart: ingress-nginx-3.4.1
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/version: 0.40.2
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/component: admission-webhook
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: ingress-nginx-admission
subjects:
  - kind: ServiceAccount
    name: ingress-nginx-admission
    namespace: ingress-nginx
---
# Source: ingress-nginx/templates/admission-webhooks/job-patch/role.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: ingress-nginx-admission
  annotations:
    helm.sh/hook: pre-install,pre-upgrade,post-install,post-upgrade
    helm.sh/hook-delete-policy: before-hook-creation,hook-succeeded
  labels:
    helm.sh/chart: ingress-nginx-3.4.1
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/version: 0.40.2
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/component: admission-webhook
  namespace: ingress-nginx
rules:
  - apiGroups:
      - ''
    resources:
      - secrets
    verbs:
      - get
      - create
---
# Source: ingress-nginx/templates/admission-webhooks/job-patch/rolebinding.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: ingress-nginx-admission
  annotations:
    helm.sh/hook: pre-install,pre-upgrade,post-install,post-upgrade
    helm.sh/hook-delete-policy: before-hook-creation,hook-succeeded
  labels:
    helm.sh/chart: ingress-nginx-3.4.1
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/version: 0.40.2
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/component: admission-webhook
  namespace: ingress-nginx
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: ingress-nginx-admission
subjects:
  - kind: ServiceAccount
    name: ingress-nginx-admission
    namespace: ingress-nginx
---
# Source: ingress-nginx/templates/admission-webhooks/job-patch/job-createSecret.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: ingress-nginx-admission-create
  annotations:
    helm.sh/hook: pre-install,pre-upgrade
    helm.sh/hook-delete-policy: before-hook-creation,hook-succeeded
  labels:
    helm.sh/chart: ingress-nginx-3.4.1
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/version: 0.40.2
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/component: admission-webhook
  namespace: ingress-nginx
spec:
  template:
    metadata:
      name: ingress-nginx-admission-create
      labels:
        helm.sh/chart: ingress-nginx-3.4.1
        app.kubernetes.io/name: ingress-nginx
        app.kubernetes.io/instance: ingress-nginx
        app.kubernetes.io/version: 0.40.2
        app.kubernetes.io/managed-by: Helm
        app.kubernetes.io/component: admission-webhook
    spec:
      containers:
        - name: create
          image: docker.io/jettech/kube-webhook-certgen:v1.3.0
          imagePullPolicy: IfNotPresent
          args:
            - create
            - --host=ingress-nginx-controller-admission,ingress-nginx-controller-admission.$(POD_NAMESPACE).svc
            - --namespace=$(POD_NAMESPACE)
            - --secret-name=ingress-nginx-admission
          env:
            - name: POD_NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
      restartPolicy: OnFailure
      serviceAccountName: ingress-nginx-admission
      securityContext:
        runAsNonRoot: true
        runAsUser: 2000
---
# Source: ingress-nginx/templates/admission-webhooks/job-patch/job-patchWebhook.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: ingress-nginx-admission-patch
  annotations:
    helm.sh/hook: post-install,post-upgrade
    helm.sh/hook-delete-policy: before-hook-creation,hook-succeeded
  labels:
    helm.sh/chart: ingress-nginx-3.4.1
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/version: 0.40.2
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/component: admission-webhook
  namespace: ingress-nginx
spec:
  template:
    metadata:
      name: ingress-nginx-admission-patch
      labels:
        helm.sh/chart: ingress-nginx-3.4.1
        app.kubernetes.io/name: ingress-nginx
        app.kubernetes.io/instance: ingress-nginx
        app.kubernetes.io/version: 0.40.2
        app.kubernetes.io/managed-by: Helm
        app.kubernetes.io/component: admission-webhook
    spec:
      containers:
        - name: patch
          image: docker.io/jettech/kube-webhook-certgen:v1.3.0
          imagePullPolicy: IfNotPresent
          args:
            - patch
            - --webhook-name=ingress-nginx-admission
            - --namespace=$(POD_NAMESPACE)
            - --patch-mutating=false
            - --secret-name=ingress-nginx-admission
            - --patch-failure-policy=Fail
          env:
            - name: POD_NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
      restartPolicy: OnFailure
      serviceAccountName: ingress-nginx-admission
      securityContext:
        runAsNonRoot: true
        runAsUser: 2000

```





NOTE USE =========================================
















```bash

# https://github.com/nginxinc/kubernetes-ingress/issues/5526

#  sslRedirectAnnotation                 = "ingress.kubernetes.io/ssl-redirect" 

# -------------------------DEPRECATED
# https://stackoverflow.com/questions/50087544/disable-ssl-redirect-for-kubernetes-nginx-ingress
# -------------------------DEPRECATED


# -------------------------DEPRECATED
# https://stackoverflow.com/questions/72224230/error-resource-mapping-not-found-make-sure-crds-are-installed-first
# https://kubernetes.io/docs/reference/using-api/deprecation-guide/#ingress-v122

#   annotations:
#     kubernetes.io/ingress.class: nginx

# Warning: annotation "kubernetes.io/ingress.class" is deprecated, please use 'spec.ingressClassName' instead
# Error from server (InternalError): error when creating "service_nginx_with_ingress.yaml": Internal error occurred: failed calling webhook "validate.nginx.ingress.kubernetes.io": failed to call webhook: Post "https://ingress-nginx-controller-admission.ingress-nginx.svc:443/networking/v1/ingresses?timeout=10s": tls: failed to verify certificate: x509: certificate signed by unknown authority
# -------------------------/DEPRECATED


# -------------------------DEPRECATED
# apiVersion: networking.k8s.io/v1
# kind: Ingress
# metadata:
#   name: ingress-nginx-with-ingress
#   labels:
#     name: ingress-nginx-with-ingress
# spec:
#   rules:
#     - host: ingress.nginx.local
#       http:
#         paths:
#           - path: /
#             backend:
#               serviceName: service-nginx-with-ingress
#               servicePort: 80
# -------------------------/DEPRECATED
```

```bash

# error 1 Ingress Old
# replicaset.apps/pod-nginx-with-ingress created
# service/service-nginx-with-ingress created
# error: resource mapping not found for name: "ingress-nginx-with-ingress" namespace: "" from "service_nginx_with_ingress.yaml": no matches for kind "Ingress" in version "networking.k8s.io/v1beta1"
# ensure CRDs are installed first



# error 2 Ingress New

# ubuntu@YOUR-VM-NAME:~/KUBERNETES_FILE/service$ cd /home/ubuntu/KUBERNETES_FILE/service &&
# kubectl create -f service_nginx_with_ingress.yaml  --namespace default
# replicaset.apps/pod-nginx-with-ingress created
# service/service-nginx-with-ingress created
# Error from server (InternalError): error when creating "service_nginx_with_ingress.yaml": Internal error occurred: failed calling webhook "validate.nginx.ingress.kubernetes.io": failed to call webhook: Post "https://ingress-nginx-controller-admission.ingress-nginx.svc:443/networking/v1/ingresses?timeout=10s": tls: failed to verify certificate: x509: certificate signed by unknown authority


# https://youtu.be/8Xans2UrL4A?list=PL-CtdCApEFH8XrWyQAyRd6d_CKwxD8Ime&t=696
# https://www.youtube.com/watch?v=8Xans2UrL4A&list=PL-CtdCApEFH8XrWyQAyRd6d_CKwxD8Ime&index=32
```










https://stackoverflow.com/questions/66236346/kubernetes-apiversion-networking-k8s-io-v1-issue-with-ingress (SOLVED HRSNYA)











ISSUE pod/ingress-nginx-admission NOT INSTALLED


https://stackoverflow.com/questions/61365202/nginx-ingress-service-ingress-nginx-controller-admission-not-found



# -------------------------------
 
## Nginx Ingress: service "ingress-nginx-controller-admission" not found

kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission


# https://kubernetes.github.io/ingress-nginx/deploy/