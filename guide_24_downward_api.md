downward api = congiruasi  manual bs pake configmap / secret 

konfigurasi yang dinamis seperti POD dan NODE


downword api = memungkinkan mengambil info dari pod dan Node melalui variable


ini bukan   restfulapi , ini hanya cara untuk ambil informasi dari pod dan node


metadata
requests.cpu = jumlah cpu yang di resquest
requests.memory = jumlah memory yang di request
limits.cpu = jumlah limit maksimal cpu
limits.memory = jumlah limit maksimal memory
metadata.name =  nama pod
metadata.namespace = namespace pod
metadata.uid = id pod
metadata.labels['<KEY>'] =  label pod
metadata.annotations['<KEY>'] = Annotation pod
status.podIP = IP address POD
spec.servicecAccountName =  Nama service account pod
spec.nodeName =  Nama node
status.hostIP = IP address node



TUJUAN = MEMBUAT ENV BERDASARKAN DATA KUBERNETES 

Contoh : 
[downward-api.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/examples/downward-api.yaml)



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
          env:
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
            - name: POD_NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
            - name: POD_IP
              valueFrom:
                fieldRef:
                  fieldPath: status.podIP
            - name: POD_NODE
              valueFrom:
                fieldRef:
                  fieldPath: spec.nodeName
            - name: POD_NODE_IP
              valueFrom:
                fieldRef:
                  fieldPath: status.hostIP
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


COBA



```bash
kubectl delete all --all


mkdir -p /home/ubuntu/KUBERNETES_FILE/service && 
cd /home/ubuntu/KUBERNETES_FILE/service && 
nano service_downward_api.yaml
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
          env:
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
            - name: POD_NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
            - name: POD_IP
              valueFrom:
                fieldRef:
                  fieldPath: status.podIP
            - name: POD_NODE
              valueFrom:
                fieldRef:
                  fieldPath: spec.nodeName
            - name: POD_NODE_IP
              valueFrom:
                fieldRef:
                  fieldPath: status.hostIP
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
kubectl create -f service_downward_api.yaml  --namespace default

# configmap/nodejs-env-config created
# replicaset.apps/nodejs-env created
# service/nodejs-env-service created



kubectl get all

# NAME                   READY   STATUS    RESTARTS   AGE
# pod/nodejs-env-g6knl   1/1     Running   0          37s
# pod/nodejs-env-mfbz8   1/1     Running   0          37s
# pod/nodejs-env-tc7jk   1/1     Running   0          37s

# NAME                         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
# service/kubernetes           ClusterIP   10.96.0.1      <none>        443/TCP          43s
# service/nodejs-env-service   NodePort    10.99.126.33   <none>        3000:30001/TCP   36s

# NAME                         DESIRED   CURRENT   READY   AGE
# replicaset.apps/nodejs-env   3         3         3       37s


kubectl exec -it nodejs-env-tc7jk -- /bin/sh    #next

/# env
# POD_IP=10.244.1.183
# KUBERNETES_SERVICE_PORT=443
# KUBERNETES_PORT=tcp://10.96.0.1:443
# NODE_VERSION=12.16.1
# HOSTNAME=nodejs-env-tc7jk
# YARN_VERSION=1.22.0
# SHLVL=1
# HOME=/root
# NODEJS_ENV_SERVICE_PORT_3000_TCP_ADDR=10.99.126.33
# NODEJS_ENV_SERVICE_PORT_3000_TCP_PORT=3000
# NODEJS_ENV_SERVICE_PORT_3000_TCP_PROTO=tcp
# VERSION=1.0.0
# TERM=xterm
# POD_NAME=nodejs-env-tc7jk
# KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
# PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# NODEJS_ENV_SERVICE_PORT_3000_TCP=tcp://10.99.126.33:3000
# KUBERNETES_PORT_443_TCP_PORT=443
# NODEJS_ENV_SERVICE_SERVICE_HOST=10.99.126.33
# KUBERNETES_PORT_443_TCP_PROTO=tcp
# POD_NODE=minikube
# APPLICATION=My Cool Application
# NODEJS_ENV_SERVICE_PORT=tcp://10.99.126.33:3000
# NODEJS_ENV_SERVICE_SERVICE_PORT=3000
# KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
# KUBERNETES_SERVICE_PORT_HTTPS=443
# POD_NAMESPACE=default
# KUBERNETES_SERVICE_HOST=10.96.0.1
# PWD=/
# POD_NODE_IP=192.168.49.2

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
# Forwarding from 0.0.0.0:30001 -> 3000

#  http://<YOUR_IP_PUBLIC>:30001 (IP PUBLIC)

# {
#   "application": "My Cool Application",
#   "version": "1.0.0",
#   "env": {
#     "POD_IP": "10.244.1.181",
#     "KUBERNETES_PORT": "tcp://10.96.0.1:443",
#     "KUBERNETES_SERVICE_PORT": "443",
#     "NODE_VERSION": "12.16.1",
#     "HOSTNAME": "nodejs-env-g6knl",
#     "YARN_VERSION": "1.22.0",
#     "SHLVL": "1",
#     "HOME": "/root",
#     "NODEJS_ENV_SERVICE_PORT_3000_TCP_ADDR": "10.99.126.33",
#     "NODEJS_ENV_SERVICE_PORT_3000_TCP_PORT": "3000",
#     "NODEJS_ENV_SERVICE_PORT_3000_TCP_PROTO": "tcp",
#     "VERSION": "1.0.0",
#     "POD_NAME": "nodejs-env-g6knl",
#     "KUBERNETES_PORT_443_TCP_ADDR": "10.96.0.1",
#     "PATH": "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
#     "NODEJS_ENV_SERVICE_PORT_3000_TCP": "tcp://10.99.126.33:3000",
#     "KUBERNETES_PORT_443_TCP_PORT": "443",
#     "NODEJS_ENV_SERVICE_SERVICE_HOST": "10.99.126.33",
#     "KUBERNETES_PORT_443_TCP_PROTO": "tcp",
#     "POD_NODE": "minikube",
#     "APPLICATION": "My Cool Application",
#     "NODEJS_ENV_SERVICE_SERVICE_PORT": "3000",
#     "NODEJS_ENV_SERVICE_PORT": "tcp://10.99.126.33:3000",
#     "KUBERNETES_SERVICE_PORT_HTTPS": "443",
#     "KUBERNETES_PORT_443_TCP": "tcp://10.96.0.1:443",
#     "POD_NAMESPACE": "default",
#     "KUBERNETES_SERVICE_HOST": "10.96.0.1",
#     "PWD": "/",
#     "POD_NODE_IP": "192.168.49.2"
#   }
# }
#



kubectl delete all --all
kubectl delete configmap nodejs-env-config
kubectl delete secret nodejs-env-secret 
```