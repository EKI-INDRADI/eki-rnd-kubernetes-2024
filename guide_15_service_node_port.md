## SERVICE NODE PORT (EXPOSE POD BY SERVICE MENGGUNAKAN IP LOCAL)

https://www.youtube.com/watch?v=SZQtVSBuff4&list=PL-CtdCApEFH8XrWyQAyRd6d_CKwxD8Ime&index=30
https://youtu.be/SZQtVSBuff4?list=PL-CtdCApEFH8XrWyQAyRd6d_CKwxD8Ime


ketika menggunakan NodePort , maka NODE (VM) secara otomatis akan memmbuka PORT


kondisi akan sulit ketika memiliki lebih dari 1 NODE (karena lebih dari 1 IP address)



untuk mengetahui port pada NODE
```bash
minikube service service_name

```


Template : 

[service-with-nodeport.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/templates/service-with-nodeport.yaml)

```yml
apiVersion: v1
kind: Service
metadata:
  name: service-name
  labels:
    label-key1: label-value1
spec:
  type: NodePort
  selector:
    label-key1: label-value1
  ports:
    - port: 80
      targetPort: 80
      nodePort: 32767
```

Contoh :
[service-nginx-nodeport.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/examples/service-nginx-nodeport.yaml)


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
  type: NodePort
  selector:
    name: nginx
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30001
```









COBA SERVICE WITH NODE PORT

```bash
kubectl delete all --all 


mkdir -p /home/ubuntu/KUBERNETES_FILE/service && 
cd /home/ubuntu/KUBERNETES_FILE/service && 
nano service_with_node_port.yaml
```

```yml
apiVersion: v1
kind: Service
metadata:
  name: service-with-nodePort
  labels:
    app-selector: app-service-with-nodePort
spec:
  type: NodePort
  selector:
    app-selector: app-service-with-nodePort
  ports:
    - port: 80
      targetPort: 80
      nodePort: 32767
```

```bash
cd /home/ubuntu/KUBERNETES_FILE/service &&
kubectl create -f service_with_node_port.yaml --namespace default
kubectl get endpoints

kubectl get all

```


COBA SERVICE NGINX WITH NODE PORT



```bash
kubectl delete all --all 


mkdir -p /home/ubuntu/KUBERNETES_FILE/service && 
cd /home/ubuntu/KUBERNETES_FILE/service && 
nano service_nginx_with_node_port.yaml
```

```yml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: pod-nginx-with-node-port
spec:
  replicas: 3
  selector:
    matchLabels:
      app-selector: app-pod-nginx-with-node-port
  template:
    metadata:
      name: pod-nginx-with-node-port
      labels:
        app-selector: app-pod-nginx-with-node-port
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
  name: service-nginx-with-node-port
spec:
  type: NodePort
  selector:
    app-selector: app-pod-nginx-with-node-port
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30001
```

==================== PADA SERVICE WAJIB SAMA NAMA SELECTOR YG DI POD NYA

```yml
#---------- POD
#....
#....
  selector:
    matchLabels:
      app-selector: app-pod-nginx-with-node-port
  template:
    metadata:
      name: pod-nginx-with-node-port
      labels:
        app-selector: app-pod-nginx-with-node-port
#....
#....


#---------- SERVICE
#....
#....
spec:
  type: NodePort
  selector:
    app-selector: app-pod-nginx-with-node-port
#....
#....
```
==================== / PADA SERVICE WAJIB SAMA NAMA SELECTOR YG DI POD NYA



```bash
cd /home/ubuntu/KUBERNETES_FILE/service &&
kubectl create -f service_nginx_with_node_port.yaml --namespace default
kubectl get endpoints



<YOUR_IP_PUBLIC>:30001
kubectl get all
# NAME                                 READY   STATUS    RESTARTS   AGE
# pod/pod-nginx-with-node-port-7sg4b   1/1     Running   0          5s
# pod/pod-nginx-with-node-port-9kjwj   1/1     Running   0          5s
# pod/pod-nginx-with-node-port-h57dt   1/1     Running   0          5s

# NAME                                   TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
# service/kubernetes                     ClusterIP   10.96.0.1        <none>        443/TCP        28s
# service/service-nginx-with-node-port   NodePort    10.100.120.239   <none>        80:30001/TCP   4s

# NAME                                       DESIRED   CURRENT   READY   AGE
# replicaset.apps/pod-nginx-with-node-port   3         3         3       5s



minikube service service_name

minikube service service-nginx-with-node-port

# |-----------|------------------------------|-------------|---------------------------|
# | NAMESPACE |             NAME             | TARGET PORT |            URL            |
# |-----------|------------------------------|-------------|---------------------------|
# | default   | service-nginx-with-node-port |          80 | http://192.168.49.2:30001 |
# |-----------|------------------------------|-------------|---------------------------|
# * Opening service default/service-nginx-with-node-port in default browser...
#   http://192.168.49.2:30001


curl  http://192.168.49.2:30001
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
