service load balancer 
service ini tidak bisa di akses di minikube 

https://www.youtube.com/watch?v=zYFvp0_8q0o&list=PL-CtdCApEFH8XrWyQAyRd6d_CKwxD8Ime&index=31

https://youtu.be/zYFvp0_8q0o?list=PL-CtdCApEFH8XrWyQAyRd6d_CKwxD8Ime

```bash
CLOUD LB         | KUBERNETES CLUSTER                                                    |
LB1           -> | SERVICE1:XX1 <> SERVICE1:XX2 (EXPOSE PORT) ->   POD_With_nodePort:XX1 |
                 |                                            ->   Pod_with_nodePort:XX2 |
LB2           -> | SERVICE2:XX1 <> SERVICE2:XX2 (EXPOSE PORT) ->   POD_With_nodePort:XX1 |
                 |                                            ->   Pod_with_nodePort:XX2 |
```


Template : 
[service-with-loadbalancer.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/templates/service-with-loadbalancer.yaml)

```bash
apiVersion: v1
kind: Service
metadata:
  name: service-name
  labels:
    label-key1: label-value1
spec:
  type: LoadBalancer
  selector:
    label-key1: label-value1
  ports:
    - port: 80
      targetPort: 80
```


Contoh :
[service-nginx-loadbalancer.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/examples/service-nginx-loadbalancer.yaml)

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
  type: LoadBalancer
  selector:
    name: nginx
  ports:
    - port: 80
      targetPort: 80

```


 type: LoadBalancer  <--- harap diperhatikan pada service


COBA SERVICE NGINX WITH LOADBALANCER




```bash
kubectl delete all --all 

mkdir -p /home/ubuntu/KUBERNETES_FILE/service && 
cd /home/ubuntu/KUBERNETES_FILE/service && 
nano service_nginx_with_load_balancer.yaml
```

```yml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: pod-nginx-with-load-balancer
spec:
  replicas: 3
  selector:
    matchLabels:
      app-selector: app-pod-nginx-with-load-balancer
  template:
    metadata:
      name: pod-nginx-with-load-balancer
      labels:
        app-selector: app-pod-nginx-with-load-balancer
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
  name: service-nginx-with-load-balancer
spec:
  type: LoadBalancer
  selector:
    app-selector: app-pod-nginx-with-load-balancer
  ports:
    - port: 80
      targetPort: 80
```


pada 

```yml
  ports:
    - port: 80
      targetPort: 80
      # nodePort: 30001
```

nodePort (expose port) tidak perlu dibuat diservice loadbalancer karena akan auto generate dari loadbalancer

==================== PADA SERVICE WAJIB SAMA NAMA SELECTOR YG DI POD NYA

```yml
#---------- POD
#....
#....
  selector:
    matchLabels:
      app-selector: app-pod-nginx-with-load-balancer
  template:
    metadata:
      name: pod-nginx-with-load-balancer
      labels:
        app-selector: app-pod-nginx-with-load-balancer
#....
#....


#---------- SERVICE
#....
#....
spec:
  type: LoadBalancer
  selector:
    app-selector: app-pod-nginx-with-load-balancer
#....
#....
```
==================== / PADA SERVICE WAJIB SAMA NAMA SELECTOR YG DI POD NYA



```bash
cd /home/ubuntu/KUBERNETES_FILE/service &&
kubectl create -f service_nginx_with_load_balancer.yaml --namespace default

kubectl get all

# NAME                                     READY   STATUS    RESTARTS   AGE
# pod/pod-nginx-with-load-balancer-h7c9f   1/1     Running   0          12s
# pod/pod-nginx-with-load-balancer-t4nx4   1/1     Running   0          12s
# pod/pod-nginx-with-load-balancer-zhbvj   1/1     Running   0          12s

# NAME                                       TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
# service/kubernetes                         ClusterIP      10.96.0.1       <none>        443/TCP        40s
# service/service-nginx-with-load-balancer   LoadBalancer   10.111.58.174   <pending>     80:32414/TCP   12s

# NAME                                           DESIRED   CURRENT   READY   AGE
# replicaset.apps/pod-nginx-with-load-balancer   3         3         3       12s



# 80:32414/TCP   <<< ini adalah nodePort nya (tidak perlu di setup di configurasi)
# EXTERNAL-IP <pending> karena tidak bs di test di local harus di cloud yang ada loadbalancernya

minikube service service-nginx-with-load-balancer

# |-----------|----------------------------------|-------------|---------------------------|
# | NAMESPACE |               NAME               | TARGET PORT |            URL            |
# |-----------|----------------------------------|-------------|---------------------------|
# | default   | service-nginx-with-load-balancer |          80 | http://192.168.49.2:32414 |
# |-----------|----------------------------------|-------------|---------------------------|
# * Opening service default/service-nginx-with-load-balancer in default browser...
#   http://192.168.49.2:32414

curl http://192.168.49.2:32414

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


kubectl delete all --all 

```