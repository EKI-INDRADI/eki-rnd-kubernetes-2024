
services = resource untuk membuat satu gerbang untuk mengakses satu atau lebih pod

service memiliki ip dan port


pod bisa bertambah,berkurang,atau berpindah, tanpa harus menggangu client


services = jumbatan / gerbang

===============
https://www.youtube.com/watch?v=pG_5jdKn0lI&list=PL-CtdCApEFH8XrWyQAyRd6d_CKwxD8Ime&index=25
jika mengakses pod langsung tanpa service hrs tau lokasi pod masing2
misal ada 3 pod , karena langsung hanya 1, ketika 1 nya mati akan ikut mati dan akan pindah

tidak ada direct access ke pod ( tidak di sarankan)
===============

service akan menjembatani  otomatis ke pod walaupun pod nya bnyk dan beberapa mati akan tetap 1 url

service akan mendistribusikan traffik ke pod secara imbang
servicec akan menggunakan label selector untuk mengetahui pod di belakang service tsb



```bash
kubectl get service
kubectl delete service service_name
```




menakses service
```bash
kubectl exec pod_name -it -- /bin/sh   #-it interactive  , /bin/sh or /bin/bash

#lalu di dalamnya bs mengakses curl

curl http://cluster-ip:port/ # hanya bs di akses di dalem cluster kubernetesnya

```

Template : 
[service.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/templates/service.yaml)

```yml
apiVersion: v1
kind: Service
metadata:
  name: service-name
spec:
  selector:
    label-key1: label-value1
  ports:
  - port: 8080 #-> host port
    targetPort: 80 #-> container port
```


Contoh (cara membuat 1 configurasi file dengan 3 resource): 
[service-nginx.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/examples/service-nginx.yaml)

```yml
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
    - port: 8080
      targetPort: 80

---

apiVersion: v1
kind: Pod
metadata:
  name: curl
  labels:
    name: curl
spec:
  containers:
    - name: curl
      image: khannedy/nginx-curl
```



## ----------------------

## 0. delete all
```bash
kubectl delete all --all --namespace default

kubectl get all --namespace default
```


 NOTE :   
 ```yml
 selector:
    app-selector: rs-nginxsrv-app-selector

  labels:
    app-selector: rs-nginxsrv-app-selector
```

wajib sama baik itu pod service , dll

## 1. create replicase set pod
## (tidak harus buat replicaset untuk membuat service cukup buat pod saja)
<!-- 
```bash
mkdir -p /home/ubuntu/KUBERNETES_FILE/replica_set && 
cd /home/ubuntu/KUBERNETES_FILE/replica_set && 
nano rs_nginxsrv.yaml
```

```yml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: rs-nginxsrv
spec:
  replicas: 3
  selector:
    matchLabels:
      app-selector: rs-nginxsrv-app-selector
  template:
    metadata:
      name: rs-nginxsrv
      labels:
        app-selector: rs-nginxsrv-app-selector
    spec:
      containers:
        - name: nginx-320
          image: nginx:stable-alpine3.20
          ports:
            - containerPort: 80
```

```bash
cd /home/ubuntu/KUBERNETES_FILE/replica_set &&
kubectl create -f rs_nginxsrv.yaml --namespace default
```
 -->

## 2. create service

<!-- 
```bash
mkdir -p /home/ubuntu/KUBERNETES_FILE/service && 
cd /home/ubuntu/KUBERNETES_FILE/service && 
nano service_nginxsrv.yaml
```

```yml
apiVersion: v1
kind: Service
metadata:
  name: service-nginxsrv
spec:
  selector:
    app-selector: rs-nginxsrv-app-selector
  ports:
    - port: 8080
      targetPort: 80
```

```bash
cd /home/ubuntu/KUBERNETES_FILE/service &&
kubectl create -f service_nginxsrv.yaml --namespace default
``` -->


## 3. create pod (install curl)
<!-- 
```bash
mkdir -p /home/ubuntu/KUBERNETES_FILE/pod && 
cd /home/ubuntu/KUBERNETES_FILE/pod && 
nano pod_nginxsrv_curl.yaml
```

```yml
apiVersion: v1
kind: Pod
metadata:
  name: pod-nginxsrv-curl
  labels:
    name: curl
spec:
  containers:
    - name: curl
      image: khannedy/nginx-curl
```

[khannedy/nginx-curl](KUBERNETES\images_docker\nginx-curl)

NOTE : ini hanya container untuk keperluan curl doang

```bash
cd /home/ubuntu/KUBERNETES_FILE/pod &&
kubectl create -f pod_nginxsrv_curl.yaml --namespace default
``` -->



## 1~3 GABUNG

```bash
mkdir -p /home/ubuntu/KUBERNETES_FILE/service && 
cd /home/ubuntu/KUBERNETES_FILE/service && 
nano service_nginxsrv_all.yaml
```

```yml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: rs-nginxsrv
spec:
  replicas: 3
  selector:
    matchLabels:
      app-selector: rs-nginxsrv-app-selector
      # name: nginx
  template:
    metadata:
      name: rs-nginxsrv
      labels:
        app-selector: rs-nginxsrv-app-selector
        # name: nginx
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
  name: service-nginxsrv
spec:
  selector:
    app-selector: rs-nginxsrv-app-selector
    # name: nginx
  ports:
    - port: 8080
      targetPort: 80

---

apiVersion: v1
kind: Pod
metadata:
  name: pod-nginxsrv-curl
  labels:
    app-selector: pod-nginxsrv-curl
    # name: curl
spec:
  containers:
    - name: curl
      image: khannedy/nginx-curl
```

```bash
cd /home/ubuntu/KUBERNETES_FILE/service &&
kubectl create -f service_nginxsrv_all.yaml --namespace default


kubectl get all
# NAME                    READY   STATUS    RESTARTS   AGE
# pod/pod-nginxsrv-curl   1/1     Running   0          26s
# pod/rs-nginxsrv-fc4qb   1/1     Running   0          26s
# pod/rs-nginxsrv-gkfkm   1/1     Running   0          26s
# pod/rs-nginxsrv-mhz7k   1/1     Running   0          26s

# NAME                       TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)    AGE
# service/kubernetes         ClusterIP   10.96.0.1     <none>        443/TCP    41s
# service/service-nginxsrv   ClusterIP   10.98.1.124   <none>        8080/TCP   26s

# NAME                          DESIRED   CURRENT   READY   AGE
# replicaset.apps/rs-nginxsrv   3         3         3       26s

kubectl get services
# NAME               TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)    AGE
# kubernetes         ClusterIP   10.96.0.1     <none>        443/TCP    99s
# service-nginxsrv   ClusterIP   10.98.1.124   <none>        8080/TCP   84s

# NOTE : pada get service ada CLUSTER IP dan PORT , cara mengaksesnya  10.98.1.124:8080 , CLUSTER IP hanya bs di akses cluster kubernetes

# contoh curl http://10.98.1.124:8080  <<--- tidak akan berfungsi

```

# Mengakses Service SECARA MANUAL
cara mengakses cluster ip kubernetes dengan masuk ke dalam pod
```bash
kubectl exec -it pod-nginxsrv-curl -- /bin/sh  # ex : OS alpine
# kubectl exec -it pod-nginxsrv-curl -- /bin/bash  # ex : OS ubuntu

# /bin/sh karena menggunakan OS alpine , kalo ubuntu /bin/bash

# ketika sudah masuk 


/# curl http://10.98.1.124:8080/ 

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

/# exit


kubectl delete all --all 
```



# Mengakses Service SECARA OTOMATIS

https://www.youtube.com/watch?v=JG7qYCcpzGo&list=PL-CtdCApEFH8XrWyQAyRd6d_CKwxD8Ime&index=27
https://youtu.be/JG7qYCcpzGo?list=PL-CtdCApEFH8XrWyQAyRd6d_CKwxD8Ime

ada 2 cara
1. menggunakan environment variable
2. menggunakan DNS


# ---- 1. menggunakan environment variable

melihat environemtn variable (UNIX), jika OS linux ketik "env" di terminal akan muncul semua environment
```bash
kubectl exec pod_name -- env
```

jalankan kembali


```bash
mkdir -p /home/ubuntu/KUBERNETES_FILE/service && 
cd /home/ubuntu/KUBERNETES_FILE/service && 
nano service_nginxsrv_all.yaml
```

```yml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: rs-nginxsrv
spec:
  replicas: 3
  selector:
    matchLabels:
      app-selector: rs-nginxsrv-app-selector
      # name: nginx
  template:
    metadata:
      name: rs-nginxsrv
      labels:
        app-selector: rs-nginxsrv-app-selector
        # name: nginx
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
  name: service-nginxsrv
spec:
  selector:
    app-selector: rs-nginxsrv-app-selector
    # name: nginx
  ports:
    - port: 8080
      targetPort: 80

---

apiVersion: v1
kind: Pod
metadata:
  name: pod-nginxsrv-curl
  labels:
    app-selector: pod-nginxsrv-curl
    # name: curl
spec:
  containers:
    - name: curl
      image: khannedy/nginx-curl
```

```bash
cd /home/ubuntu/KUBERNETES_FILE/service &&
kubectl create -f service_nginxsrv_all.yaml --namespace default

kubectl get all
# NAME                    READY   STATUS    RESTARTS   AGE
# pod/pod-nginxsrv-curl   1/1     Running   0          18s
# pod/rs-nginxsrv-mkpjx   1/1     Running   0          18s
# pod/rs-nginxsrv-tgmrh   1/1     Running   0          18s
# pod/rs-nginxsrv-v8rwj   1/1     Running   0          18s

# NAME                       TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
# service/kubernetes         ClusterIP   10.96.0.1       <none>        443/TCP    7m8s
# service/service-nginxsrv   ClusterIP   10.110.54.146   <none>        8080/TCP   18s

# NAME                          DESIRED   CURRENT   READY   AGE
# replicaset.apps/rs-nginxsrv   3         3         3       18s
```


```bash
kubectl exec -it pod-nginxsrv-curl -- /bin/sh  # ex : OS alpine
# kubectl exec -it pod-nginxsrv-curl -- /bin/bash  # ex : OS ubuntu

# ketika sudah masuk 

/# env
# KUBERNETES_PORT=tcp://10.96.0.1:443
# SERVICE_NGINXSRV_SERVICE_HOST=10.110.54.146
# SERVICE_NGINXSRV_PORT_8080_TCP_ADDR=10.110.54.146
# KUBERNETES_SERVICE_PORT=443
# HOSTNAME=pod-nginxsrv-curl
# SERVICE_NGINXSRV_PORT_8080_TCP_PORT=8080
# SERVICE_NGINXSRV_PORT_8080_TCP_PROTO=tcp
# SHLVL=1
# HOME=/root
# SERVICE_NGINXSRV_PORT=tcp://10.110.54.146:8080
# SERVICE_NGINXSRV_SERVICE_PORT=8080
# PKG_RELEASE=1
# SERVICE_NGINXSRV_PORT_8080_TCP=tcp://10.110.54.146:8080
# TERM=xterm
# KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
# NGINX_VERSION=1.17.10
# PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# KUBERNETES_PORT_443_TCP_PORT=443
# NJS_VERSION=0.3.9
# KUBERNETES_PORT_443_TCP_PROTO=tcp
# KUBERNETES_SERVICE_PORT_HTTPS=443
# KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
# KUBERNETES_SERVICE_HOST=10.96.0.1

/# env | grep SERVICE_NGINXSRV # <----  TERGANTUNG DARI NAMA SERVICE YG DI BUAT

# apiVersion: v1
# kind: Service
# metadata:
#   name: service-nginxsrv # <----

# SERVICE_NGINXSRV_SERVICE_HOST=10.110.54.146
# SERVICE_NGINXSRV_PORT_8080_TCP_ADDR=10.110.54.146
# SERVICE_NGINXSRV_PORT_8080_TCP_PORT=8080
# SERVICE_NGINXSRV_PORT_8080_TCP_PROTO=tcp
# SERVICE_NGINXSRV_PORT=tcp://10.110.54.146:8080
# SERVICE_NGINXSRV_SERVICE_PORT=8080
# SERVICE_NGINXSRV_PORT_8080_TCP=tcp://10.110.54.146:8080


# maka yang akan digunakan adalah
# SERVICE_NGINXSRV_SERVICE_HOST
# SERVICE_NGINXSRV_SERVICE_PORT

/# exit

kubectl delete all --all 
```

maka yang akan digunakan adalah untuk memanggil nya bs menggunakan
SERVICE_NGINXSRV_SERVICE_HOST & SERVICE_NGINXSRV_SERVICE_PORT


jadi cara memanggilnya

```bash

curl http://$SERVICE_NGINXSRV_SERVICE_HOST:$SERVICE_NGINXSRV_SERVICE_PORT

# / # curl http://$SERVICE_NGINXSRV_SERVICE_HOST:$SERVICE_NGINXSRV_SERVICE_PORT
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

```

# ---- 2. menggunakan DNS (recomended lebih mudah dan aman, jika terjadi perubahan Ip dan env, dll)

https://youtu.be/JG7qYCcpzGo?list=PL-CtdCApEFH8XrWyQAyRd6d_CKwxD8Ime&t=290

```bash

service_name.namespace_name.svc.cluster.local

```

jadi cara memanggilnya

```bash

curl http://service-nginxsrv.default.svc.cluster.local:8080
# / # curl http://service-nginxsrv.default.svc.cluster.local:8080
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

exit

```




# untuk melihat semua endpoint

```bash

kubectl get endpoints
# NAME               ENDPOINTS                                         AGE
# kubernetes         192.168.49.2:8443                                 32m
# service-nginxsrv   10.244.0.126:80,10.244.0.127:80,10.244.0.128:80   25m
```


## EXTERNAL SERVICE =============================================================================

https://youtu.be/IOX2stxBw7k?list=PL-CtdCApEFH8XrWyQAyRd6d_CKwxD8Ime
https://www.youtube.com/watch?v=IOX2stxBw7k&list=PL-CtdCApEFH8XrWyQAyRd6d_CKwxD8Ime&index=28


service  = gateway internal pod, tapi bs juga untuk external pod


```bash

kubectl describe service service_name


# kubectl describe service  service-nginxsrv
# Name:                     service-nginxsrv
# Namespace:                default
# Labels:                   <none>
# Annotations:              <none>
# Selector:                 app-selector=rs-nginxsrv-app-selector
# Type:                     ClusterIP
# IP Family Policy:         SingleStack
# IP Families:              IPv4
# IP:                       10.110.54.146
# IPs:                      10.110.54.146
# Port:                     <unset>  8080/TCP
# TargetPort:               80/TCP
# Endpoints:                10.244.0.132:80,10.244.0.130:80,10.244.0.131:80
# Session Affinity:         None
# Internal Traffic Policy:  Cluster
# Events:                   <none>

kubectl get endpoints service_name

# kubectl get endpoints service-nginxsrv
# NAME               ENDPOINTS                                         AGE
# service-nginxsrv   10.244.0.130:80,10.244.0.131:80,10.244.0.132:80   17h

```
Template : 

[service-with-endpoint.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/templates/service-with-endpoint.yaml)
```yml
apiVersion: v1
kind: Service
metadata:
  name: external-service
  labels:
    label-key1: label-value1
spec:
  ports:
    - port: 80

---

apiVersion: v1
kind: Endpoints
metadata:
  name: external-service
  labels:
    label-key1: label-value1
subsets:
  - addresses:
      - ip: 11.11.11.11
      - ip: 22.22.22.22 #kalo ada 2 IP
    ports:
      - port: 80
```

[service-with-domain.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/templates/service-with-domain.yaml)

```yml
apiVersion: v1
kind: Service
metadata:
  name: external-service
  labels:
    label-key1: label-value1
spec:
  type: ExternalName
  externalName: example.com
  ports:
    - port: 80
```

Contoh :

[service-example.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/examples/service-example.yaml)


```yml
apiVersion: v1
kind: Service
metadata:
  name: example-service
  labels:
    name: example-service
spec:
  type: ExternalName
  externalName: example.com
  ports:
    - port: 80

---

apiVersion: v1
kind: Pod
metadata:
  name: curl
  labels:
    name: curl
spec:
  containers:
    - name: curl
      image: khannedy/nginx-curl
```



CONTOH SERVICE WITH DOMAIN


```bash
kubectl delete all --all 


mkdir -p /home/ubuntu/KUBERNETES_FILE/service && 
cd /home/ubuntu/KUBERNETES_FILE/service && 
nano service_example_with_external_name.yaml
```

```yml
apiVersion: v1
kind: Service
metadata:
  name: service-example-with-external-name
  labels:
    name: service-example-with-external-name
spec:
  type: ExternalName
  externalName: example.com
  ports:
    - port: 80

---

apiVersion: v1
kind: Pod
metadata:
  name: pod-example-with-external-name-curl
  labels:
    name: pod-example-with-external-name-curl
spec:
  containers:
    - name: curl
      image: khannedy/nginx-curl
```

```bash
cd /home/ubuntu/KUBERNETES_FILE/service &&
kubectl create -f service_example_with_external_name.yaml --namespace default
kubectl get endpoints
# kubernetes   192.168.49.2:8443   3m36s
#tidak ada endtpoints karena tidak tidak punya endpoint pod
kubectl get all
# NAME                                      READY   STATUS    RESTARTS   AGE
# pod/pod-example-with-external-name-curl   1/1     Running   0          2m37s

# NAME                                         TYPE           CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
# service/kubernetes                           ClusterIP      10.96.0.1    <none>        443/TCP   3m57s
# service/service-example-with-external-name   ExternalName   <none>       example.com   80/TCP    2m37s

```


```bash
kubectl exec -it pod-example-with-external-name-curl -- /bin/sh 

curl http://service-example-with-external-name.default.svc.cluster.local  # << DNS TIDAK AKAN BERFUNGSI JIKA menggunakan DOMAIN , karena telah di forward


# <?xml version="1.0" encoding="iso-8859-1"?>
# <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
#          "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
# <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
#         <head>
#                 <title>404 - Not Found</title>
#         </head>
#         <body>
#                 <h1>404 - Not Found</h1>
#         </body>
# </html>

curl http://example.com # << DOMAIN
# <!doctype html>
# <html>
# <head>
#     <title>Example Domain</title>

#     <meta charset="utf-8" />
#     <meta http-equiv="Content-type" content="text/html; charset=utf-8" />
#     <meta name="viewport" content="width=device-width, initial-scale=1" />
#     <style type="text/css">
#     body {
#         background-color: #f0f0f2;
#         margin: 0;
#         padding: 0;
#         font-family: -apple-system, system-ui, BlinkMacSystemFont, "Segoe UI", "Open Sans", "Helvetica Neue", Helvetica, Arial, sans-serif;

#     }
#     div {
#         width: 600px;
#         margin: 5em auto;
#         padding: 2em;
#         background-color: #fdfdff;
#         border-radius: 0.5em;
#         box-shadow: 2px 3px 7px 2px rgba(0,0,0,0.02);
#     }
#     a:link, a:visited {
#         color: #38488f;
#         text-decoration: none;
#     }
#     @media (max-width: 700px) {
#         div {
#             margin: 0 auto;
#             width: auto;
#         }
#     }
#     </style>
# </head>

# <body>
# <div>
#     <h1>Example Domain</h1>
#     <p>This domain is for use in illustrative examples in documents. You may use this
#     domain in literature without prior coordination or asking for permission.</p>
#     <p><a href="https://www.iana.org/domains/example">More information...</a></p>
# </div>
# </body>
# </html>

```

## mengekspose service 
agar menjadi external, hanya untuk pegetest an aja, dalam case nyala tidak akan pernah expose sebuah port
tujuannya untuk dapat akses external kubernetes melalui service


default type service :

ClusterIp (default) = di dalam internal kubernetes cluster
ExternalName = nembak extenal domain / virtual domain (example.com)
NodePort = mengespose service pada setiap IP Node dan port yang sama <NodeIp>:<NodePort>, dapat mengakses dari luar cluster melalui <NodeIp>:<NodePort>
LoadBalancer = mengespose service secara external yg di sediakan oleh layanan cloud


mengekspose service ke internal = ClusterIp (call by ip / env / DNS)

mengekspose service dari dalam ke keluar  = ExternalName

mengekspose service dari luar ke dalam = NodePort atau LoadBalancer


cara mengekspose service

NodePort = NodePort akan meneruskan request ke service yg di tuju
LoadBalancer = LoadBalancer akan meneruskan request ke NodePort dan lanjut ke service yg di tuju
Ingress = mengekspose service tapi hanya di level HTTP (TANPA PORT)

