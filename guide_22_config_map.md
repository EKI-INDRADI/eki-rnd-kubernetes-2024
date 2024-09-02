masalah dari environtment variable adalah , saat menghardcode konfigurasi yaml kubernetesnya artinya kita harus membuat file konfigurasi berbeda2 pada setiap jenis environment

ex : prod, dev, qa


kemungkinanan kesalahan konfigurasi tinggi

ConfigMap = membuat profile konfigurasi, memisahkan konfigurasi yang berisi key=value 


contoh 


App.yaml <--- cukup buat 1 aplikasi yaml

| namespace dev                 | namespace prod                  | namespace qa
| |_ConfigMap                   |  |_ConfigMap                    |  |_ConfigMap
|    |_Env Var  <---app.yaml    |    |_Env Var  <---app.yaml      |    |_Env Var <---app.yaml


```bash

kubectl create -f configmap_name.yaml  --namespace default
kubectl get configmaps
kubectl describe configmaps configmap_name
kubectl delete configmaps configmap_name

```




Template :
[configmaps.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/templates/configmaps.yaml)

```yaml

apiVersion: v1
kind: ConfigMap
data:
  ENV: VALUE
metadata:
  name: configmap-name

```

Contoh :
[configmap.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/examples/configmap.yaml)

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: nodejs-env-config
data:
  APPLICATION: My Cool Application
  VERSION: 1.0.0

---

apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nodejs-env
spec:
  replicas: 3
  selector:
    matchLabels:
      name: nodejs-env
  template:
    metadata:
      name: nodejs-env
      labels:
        name: nodejs-env
    spec:
      containers:
        - name: nodejs-env
          image: khannedy/nodejs-env
          ports:
            - containerPort: 3000
          envFrom:
            - configMapRef:
                name: nodejs-env-config

---

apiVersion: v1
kind: Service
metadata:
  name: nodejs-env-service
spec:
  type: NodePort
  selector:
    name: nodejs-env
  ports:
    - port: 3000
      targetPort: 3000
      nodePort: 30001
```


[khannedy/nodejs-env](./KUBERNETES/images_docker/nodejs-env/app.js)

```js
const http = require('http');
const process = require("process");

const hostname = '0.0.0.0';
const port = 3000;

const server = http.createServer((req, res) => {
    res.statusCode = 200;
    res.setHeader('Content-Type', 'application/json');
    res.end(JSON.stringify({
        application: process.env.APPLICATION,
        version: process.env.VERSION,
        env: process.env
    }));
});

server.listen(port, hostname, () => {
    console.log(`Server running`);
});


```




COBA


```bash
kubectl delete all --all


mkdir -p /home/ubuntu/KUBERNETES_FILE/service && 
cd /home/ubuntu/KUBERNETES_FILE/service && 
nano service_config_map.yaml
```

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: nodejs-env-config
data:
  APPLICATION: My Cool Application
  VERSION: 1.0.0

---

apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nodejs-env
spec:
  replicas: 3
  selector:
    matchLabels:
      name: nodejs-env
  template:
    metadata:
      name: nodejs-env
      labels:
        name: nodejs-env
    spec:
      containers:
        - name: nodejs-env
          image: khannedy/nodejs-env
          ports:
            - containerPort: 3000
          envFrom:
            - configMapRef:
                name: nodejs-env-config

---

apiVersion: v1
kind: Service
metadata:
  name: nodejs-env-service
spec:
  type: NodePort
  selector:
    name: nodejs-env
  ports:
    - port: 3000
      targetPort: 3000
      nodePort: 30001

```


```bash
cd /home/ubuntu/KUBERNETES_FILE/service &&
kubectl create -f service_config_map.yaml  --namespace default


kubectl get all
# NAME                   READY   STATUS    RESTARTS   AGE
# pod/nodejs-env-6kk6s   1/1     Running   0          23s
# pod/nodejs-env-7hfw5   1/1     Running   0          23s
# pod/nodejs-env-z7mdc   1/1     Running   0          23s

# NAME                         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
# service/kubernetes           ClusterIP   10.96.0.1        <none>        443/TCP          41s
# service/nodejs-env-service   NodePort    10.110.156.148   <none>        3000:30001/TCP   23s

# NAME                         DESIRED   CURRENT   READY   AGE
# replicaset.apps/nodejs-env   3         3         3       23s


kubectl get configmap
# NAME                DATA   AGE
# kube-root-ca.crt    1      3d7h
# nodejs-env-config   2      39s

kubectl describe configmap  nodejs-env-config
# Name:         nodejs-env-config
# Namespace:    default
# Labels:       <none>
# Annotations:  <none>

# Data
# ====
# APPLICATION:
# ----
# My Cool Application

# VERSION:
# ----
# 1.0.0


# BinaryData
# ====

# Events:  <none>

kubectl exec -it nodejs-env-6kk6s -- /bin/sh
/# env
# KUBERNETES_SERVICE_PORT=443
# KUBERNETES_PORT=tcp://10.96.0.1:443
# NODE_VERSION=12.16.1
# HOSTNAME=nodejs-env-6kk6s
# YARN_VERSION=1.22.0
# SHLVL=1
# HOME=/root
# NODEJS_ENV_SERVICE_PORT_3000_TCP_ADDR=10.110.156.148
# NODEJS_ENV_SERVICE_PORT_3000_TCP_PORT=3000
# NODEJS_ENV_SERVICE_PORT_3000_TCP_PROTO=tcp
# VERSION=1.0.0
# TERM=xterm
# KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
# PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# NODEJS_ENV_SERVICE_PORT_3000_TCP=tcp://10.110.156.148:3000
# NODEJS_ENV_SERVICE_SERVICE_HOST=10.110.156.148
# KUBERNETES_PORT_443_TCP_PORT=443
# KUBERNETES_PORT_443_TCP_PROTO=tcp
# APPLICATION=My Cool Application
# NODEJS_ENV_SERVICE_SERVICE_PORT=3000
# NODEJS_ENV_SERVICE_PORT=tcp://10.110.156.148:3000
# KUBERNETES_SERVICE_PORT_HTTPS=443
# KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
# KUBERNETES_SERVICE_HOST=10.96.0.1


minikube service nodejs-env-service

# |-----------|--------------------|-------------|---------------------------|
# | NAMESPACE |        NAME        | TARGET PORT |            URL            |
# |-----------|--------------------|-------------|---------------------------|
# | default   | nodejs-env-service |        3000 | http://192.168.49.2:30001 |
# |-----------|--------------------|-------------|---------------------------|
# * Opening service default/nodejs-env-service in default browser...
#   http://192.168.49.2:30001

# kalo jaringan local bisa



kubectl port-forward --address 0.0.0.0 service/nodejs-env-service 30001:3000 

#  http://<YOUR_IP_PUBLIC>:30001


kubectl delete all --all
kubectl delete configmap nodejs-env-config


```