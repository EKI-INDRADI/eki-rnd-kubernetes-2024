multi container pod



pod =  bnyk container



jadi arti2 saat

pod 
container1 port 80
container2 port 80

itu gak bs, HARUS BEDA



```bash
kubectl delete all --all
kubectl delete ingress ingress-nginx-with-ingress
kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission ##(SOLVED VALIDATE)


```


Contoh :
[multi-container-pod.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/examples/multi-container-pod.yaml)


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
        - name: nodejs-web
          image: khannedy/nodejs-web
          ports:
            - containerPort: 3000

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
      name: nginx
    - port: 3000
      targetPort: 3000
      name: nodejs-web

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

COBA

```bash
kubectl delete all --all
kubectl delete ingress ingress-nginx-with-ingress
kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission ##(SOLVED VALIDATE)


mkdir -p /home/ubuntu/KUBERNETES_FILE/service && 
cd /home/ubuntu/KUBERNETES_FILE/service && 
nano service_multi_conditainer_pod.yaml
```


```bash
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: pod-web-api
spec:
  replicas: 3
  selector:
    matchLabels:
      app-selector: app-pod-web-api
  template:
    metadata:
      name: pod-web-api
      labels:
        app-selector: app-pod-web-api
    spec:
      containers:
        - name: web-nginx
          image: nginx:stable-alpine3.20
          ports:
            - containerPort: 80
        - name: api-nodejs
          image: khannedy/nodejs-web
          ports:
            - containerPort: 3000



---

apiVersion: v1
kind: Service
metadata:
  name: service-web-api
spec:
  selector:
    app-selector: app-pod-web-api
  ports:
    - port: 8080
      targetPort: 80
      name: web-nginx
    - port: 3000
      targetPort: 3000
      name: api-nodejs

---

apiVersion: v1
kind: Pod
metadata:
  name: pod-curl
  labels:
     app-selector: app-pod-curl
spec:
  containers:
    - name: curl-trigger
      image: khannedy/nginx-curl
```

```bash
cd /home/ubuntu/KUBERNETES_FILE/service &&
kubectl create -f service_multi_conditainer_pod.yaml  --namespace default

kubectl get  all
# NAME                    READY   STATUS    RESTARTS   AGE
# pod/pod-curl            1/1     Running   0          6m53s
# pod/pod-web-api-589x4   2/2     Running   0          6m54s
# pod/pod-web-api-pbwhv   2/2     Running   0          6m54s
# pod/pod-web-api-xrq6h   2/2     Running   0          6m54s

# NAME                      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)             AGE
# service/kubernetes        ClusterIP   10.96.0.1       <none>        443/TCP             7m24s
# service/service-web-api   ClusterIP   10.111.20.225   <none>        8080/TCP,3000/TCP   6m53s

# NAME                          DESIRED   CURRENT   READY   AGE
# replicaset.apps/pod-web-api   3         3         3       6m54s



kubectl exec -it pod-curl -- /bin/sh

/# curl  httP://10.111.20.225:8080
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

/# curl  httP://10.111.20.225:3000
# Hello World
```