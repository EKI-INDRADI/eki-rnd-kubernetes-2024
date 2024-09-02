secret  = untuk sesitif data

configmap dianggap tidak sensitif, di simpan di etcd, etcd untuk menyimpan kubernates config



secret seperti configmap berisikan  data key=value


kubernetes menyimpan secret secara aman, 
dgn cara mendistribusikan secara node yang memang hanya membutuhkan  secret tsb

secret di simpan di memory dan tidak pernah di taro di pisikal storages dan di encrypt

singkatnya

configmap digunakan untuk configurasi yang tidak sensitif
seceret digunakan untuk configurasi sensitif



create  secret
```bash
kubectl create -f secret.yaml

kubectl describe secret secret_name

kubectl delete secret secret_name
```



Template :
[secret.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/templates/secret.yaml)


```yaml
apiVersion: v1
kind: Secret
metadata:
  name: configmap-name
data:
  ENV: base64(VALUE) #<<< base64 bukan function , tapi manual base64 lalu paste
stringData:
  ENV: VALUE
```

Contoh :
[secret.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/examples/secret.yaml)


```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: nodejs-env-config
data:
  APPLICATION: My Cool Application

---

apiVersion: v1
kind: Secret
metadata:
  name: nodejs-env-secret
stringData:
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
            # - configMapRef:
            #     name: nodejs-env-config  #support multi configmap
            - secretRef:
                name: nodejs-env-secret
            # - secretRef:
            #     name: nodejs-env-secret  #support multi secret

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

coba

```bash
kubectl delete all --all


mkdir -p /home/ubuntu/KUBERNETES_FILE/service && 
cd /home/ubuntu/KUBERNETES_FILE/service && 
nano service_secret.yaml
```

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: nodejs-env-config
data:
  APPLICATION: My Cool Application

---

apiVersion: v1
kind: Secret
metadata:
  name: nodejs-env-secret
stringData:
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
      app-selector: nodejs-env
  template:
    metadata:
      name: nodejs-env
      labels:
        app-selector: nodejs-env
    spec:
      containers:
        - name: nodejs-env
          image: khannedy/nodejs-env
          ports:
            - containerPort: 3000
          envFrom:
            - configMapRef:
                name: nodejs-env-config
            # - configMapRef:
            #     name: nodejs-env-config  #support multi configmap
            - secretRef:
                name: nodejs-env-secret
            # - secretRef:
            #     name: nodejs-env-secret  #support multi secret

---

apiVersion: v1
kind: Service
metadata:
  name: nodejs-env-service
spec:
  type: NodePort
  selector:
    app-selector: nodejs-env
  ports:
    - port: 3000
      targetPort: 3000
      nodePort: 30001

```




```bash
cd /home/ubuntu/KUBERNETES_FILE/service &&
kubectl create -f service_secret.yaml  --namespace default

# configmap/nodejs-env-config created
# secret/nodejs-env-secret created
# replicaset.apps/nodejs-env created
# service/nodejs-env-service created


kubectl get all

# NAME                   READY   STATUS    RESTARTS   AGE
# pod/nodejs-env-b2h2m   1/1     Running   0          2m34s
# pod/nodejs-env-cwh2x   1/1     Running   0          2m34s
# pod/nodejs-env-nxfj5   1/1     Running   0          2m34s

# NAME                         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
# service/kubernetes           ClusterIP   10.96.0.1       <none>        443/TCP          4m56s
# service/nodejs-env-service   NodePort    10.99.232.214   <none>        3000:30001/TCP   2m34s

# NAME                         DESIRED   CURRENT   READY   AGE
# replicaset.apps/nodejs-env   3         3         3       2m34s


kubectl get configmap

kubectl describe configmap nodejs-env-config
# onfigmap nodejs-env-config
# Name:         nodejs-env-config
# Namespace:    default
# Labels:       <none>
# Annotations:  <none>

# Data
# ====
# APPLICATION:
# ----
# My Cool Application


# BinaryData
# ====


kubectl get secret
# NAME                TYPE     DATA   AGE
# nodejs-env-secret   Opaque   1      3m30s


kubectl describe secret nodejs-env-secret 

# secret nodejs-env-secret
# Name:         nodejs-env-secret
# Namespace:    default
# Labels:       <none>
# Annotations:  <none>

# Type:  Opaque

# Data
# ====
# VERSION:  5 bytes



kubectl exec -it nodejs-env-b2h2m -- /bin/sh

/# env
# KUBERNETES_PORT=tcp://10.96.0.1:443
# KUBERNETES_SERVICE_PORT=443
# NODE_VERSION=12.16.1
# HOSTNAME=nodejs-env-b2h2m
# YARN_VERSION=1.22.0
# SHLVL=1
# HOME=/root
# NODEJS_ENV_SERVICE_PORT_3000_TCP_ADDR=10.99.232.214
# NODEJS_ENV_SERVICE_PORT_3000_TCP_PORT=3000
# NODEJS_ENV_SERVICE_PORT_3000_TCP_PROTO=tcp
# VERSION=1.0.0                        # < ------------ DI AMBIL DARI SECRET
# TERM=xterm
# KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
# PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# NODEJS_ENV_SERVICE_PORT_3000_TCP=tcp://10.99.232.214:3000
# KUBERNETES_PORT_443_TCP_PORT=443
# NODEJS_ENV_SERVICE_SERVICE_HOST=10.99.232.214
# KUBERNETES_PORT_443_TCP_PROTO=tcp
# APPLICATION=My Cool Application      # < ------------ DI AMBIL DARI CONFIGMAP
# NODEJS_ENV_SERVICE_SERVICE_PORT=3000
# NODEJS_ENV_SERVICE_PORT=tcp://10.99.232.214:3000
# KUBERNETES_SERVICE_PORT_HTTPS=443
# KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
# KUBERNETES_SERVICE_HOST=10.96.0.1
/# exit


minikube service nodejs-env-service
# |-----------|--------------------|-------------|---------------------------|
# | NAMESPACE |        NAME        | TARGET PORT |            URL            |
# |-----------|--------------------|-------------|---------------------------|
# | default   | nodejs-env-service |        3000 | http://192.168.49.2:30001 |
# |-----------|--------------------|-------------|---------------------------|
# * Opening service default/nodejs-env-service in default browser...
#   http://192.168.49.2:30001 (IP LOCAL)


kubectl port-forward --address 0.0.0.0 service/nodejs-env-service 30001:3000 
# {
#   "application": "My Cool Application",
#   "version": "1.0.0",
#   "env": {
#     "KUBERNETES_PORT": "tcp://10.96.0.1:443",
#     "KUBERNETES_SERVICE_PORT": "443",
#     "NODE_VERSION": "12.16.1",
#     "HOSTNAME": "nodejs-env-b2h2m",
#     "YARN_VERSION": "1.22.0",
#     "SHLVL": "1",
#     "HOME": "/root",
#     "NODEJS_ENV_SERVICE_PORT_3000_TCP_ADDR": "10.99.232.214",
#     "NODEJS_ENV_SERVICE_PORT_3000_TCP_PORT": "3000",
#     "NODEJS_ENV_SERVICE_PORT_3000_TCP_PROTO": "tcp",
#     "VERSION": "1.0.0",
#     "KUBERNETES_PORT_443_TCP_ADDR": "10.96.0.1",
#     "PATH": "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
#     "NODEJS_ENV_SERVICE_PORT_3000_TCP": "tcp://10.99.232.214:3000",
#     "KUBERNETES_PORT_443_TCP_PORT": "443",
#     "NODEJS_ENV_SERVICE_SERVICE_HOST": "10.99.232.214",
#     "KUBERNETES_PORT_443_TCP_PROTO": "tcp",
#     "APPLICATION": "My Cool Application",
#     "NODEJS_ENV_SERVICE_SERVICE_PORT": "3000",
#     "NODEJS_ENV_SERVICE_PORT": "tcp://10.99.232.214:3000",
#     "KUBERNETES_SERVICE_PORT_HTTPS": "443",
#     "KUBERNETES_PORT_443_TCP": "tcp://10.96.0.1:443",
#     "KUBERNETES_SERVICE_HOST": "10.96.0.1",
#     "PWD": "/"
#   }
# }
#
#  http://<YOUR_IP_PUBLIC>:30001 (IP PUBLIC)


kubectl delete all --all
kubectl delete configmap nodejs-env-config
kubectl delete secret nodejs-env-secret 
```