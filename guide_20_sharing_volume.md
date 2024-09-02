sharing volume  =  1 pod bisa bnyk container , bisa sharing pod ke beberapa container

sharing directory antar container  di dalam pod

Contoh :
[sharing-volume.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/examples/sharing-volume.yaml)



```yaml
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
      volumes:
        - name: html
          emptyDir: {}
      containers:
        - name: nodejs-writer
          image: khannedy/nodejs-writer
          volumeMounts:
            - mountPath: /app/html
              name: html
        - name: nginx
          image: nginx
          ports:
            - containerPort: 80
          volumeMounts:
            - mountPath: /usr/share/nginx/html
              name: html

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
    - port: 8080
      targetPort: 80
      nodePort: 30001

```

COBA

```bash
kubectl delete all --all
kubectl delete ingress ingress-nginx-with-ingress
kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission ##(SOLVED VALIDATE)


mkdir -p /home/ubuntu/KUBERNETES_FILE/service && 
cd /home/ubuntu/KUBERNETES_FILE/service && 
nano service_sharing_volume.yaml
```


```bash
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: rs-webserver
spec:
  replicas: 3
  selector:
    matchLabels:
      app-selector: rs-webserver
  template:
    metadata:
      name: rs-webserver
      labels:
        app-selector: rs-webserver
    spec:
      volumes:
        - name: html
          emptyDir: {}
      containers:
        - name: nodejs-writer
          image: khannedy/nodejs-writer
          volumeMounts:
            - mountPath: /app/html
              name: html
        - name: nginx-320
          image: nginx:stable-alpine3.20
          ports:
            - containerPort: 80
          volumeMounts:
            - mountPath: /usr/share/nginx/html
              name: html

# NOTE :
# volume name : html   
# artinya /app/html == /usr/share/nginx/html

---

apiVersion: v1
kind: Service
metadata:
  name: service-webserver
spec:
  type: NodePort
  selector:
    app-selector: rs-webserver
  ports:
    - port: 8080
      targetPort: 80
      nodePort: 30001

# NOTE : 
# jadi container yg di expose adalah nginx, tapi yang membuat file htmlnya adalah nodejs-writer

```



```bash
cd /home/ubuntu/KUBERNETES_FILE/service &&
kubectl create -f service_sharing_volume.yaml  --namespace default


kubectl get all
# NAME                     READY   STATUS    RESTARTS   AGE
# pod/rs-webserver-29c5q   2/2     Running   0          11s
# pod/rs-webserver-m5z6k   2/2     Running   0          11s
# pod/rs-webserver-sr4kd   2/2     Running   0          11s

# NAME                    TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
# service/kubernetes      ClusterIP   10.96.0.1      <none>        443/TCP          34s
# service/nginx-service   NodePort    10.103.90.54   <none>        8080:30001/TCP   11s

# NAME                           DESIRED   CURRENT   READY   AGE
# replicaset.apps/rs-webserver   3         3         3       12s


# mencoba akses

minikube service service-webserver
# |-----------|-------------------|-------------|---------------------------|
# | NAMESPACE |       NAME        | TARGET PORT |            URL            |
# |-----------|-------------------|-------------|---------------------------|
# | default   | service-webserver |        8080 | http://192.168.49.2:30001 |
# |-----------|-------------------|-------------|---------------------------|
# * Opening service default/service-webserver in default browser...
#   http://192.168.49.2:30001


curl http://192.168.49.2:30001 # <----- hanya bisa NODE/VM jaringan local
# http://<YOUR_IP_PUBLIC>:30001 # <----- public tidak bisa kecuali test forward atau deploy

```


pada konfigurasi

```yaml

apiVersion: v1
kind: Service
metadata:
  name: service-webserver
spec:
  type: NodePort
  selector:
    app-selector: rs-webserver
  ports:
    - port: 8080 # <--- PORT INTERNAL KUBERNATES EXPOSE
      targetPort: 80 # <--- PORT CONTAINER/POD
      nodePort: 30001 # <--- PORT NODE/VM LOCAL EXPOSE

```

supaya bisa dibuka di ip lain
```bash
kubectl port-forward --address 0.0.0.0 service/service-webserver 30001:8080 #(HANYA UNTUK  TEST)
# Fri Aug 23 2024 07:50:17 GMT+0000 (Coordinated Universal Time)


kubectl exec -it nodejs-writer -- /bin/sh

/# ls /app/html
# index.html
/# cat /app/html/index.html
# <html><body>Fri Aug 23 2024 07:10:16 GMT+0000 (Coordinated Universal Time)</body></html>/app/html 



```