environment variable  tujuannya = untuk envonment data konfigurasi atau deploy sandbox/production , dll


environment varibale untuk pod

contoh konfigurasi :


Template :
[pod-with-environment-variable.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/templates/pod-with-environment-variable.yaml)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-name
  labels:
    label-key1: label-value1
    label-key2: label-value2
    label-key3: label-value3
spec:
  containers:
    - name: container-name
      image: image-name
      ports:
        - containerPort: 80
      env:
        - name: ENV_NAME
          value: "ENV VALUE"
```


Contoh :
[environment-variable.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/examples/environment-variable.yaml)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nodejs-writer
  labels:
    name: nodejs-writer
spec:
  volumes:
    - name: html
      emptyDir: {}
  containers:
    - name: nodejs-writer
      image: khannedy/nodejs-writer
      volumeMounts:
        - mountPath: /app/folder-from-env
          name: html
      env:
        - name: HTML_LOCATION
          value: /app/folder-from-env
```




COBA

```bash
kubectl delete all --all


mkdir -p /home/ubuntu/KUBERNETES_FILE/pod && 
cd /home/ubuntu/KUBERNETES_FILE/pod && 
nano pod_envrontment_variable.yaml
```


```bash
apiVersion: v1
kind: Pod
metadata:
  name: nodejs-writer
  labels:
    name: nodejs-writer
spec:
  volumes:
    - name: html
      emptyDir: {}
  containers:
    - name: nodejs-writer
      image: khannedy/nodejs-writer
      volumeMounts: #<---------------- EXPOSE VOLUME KE DIR
        - mountPath: /app/folder-from-env
          name: html
      env: #<---------------- SET ENV PADA CONTAINER IMAGE NODEJS (keperluan rubah ENV pada nodejs)
        - name: HTML_LOCATION
          value: /app/folder-from-env

```

pada container images :  khannedy/nodejs-writer , ada kodingan proccess.env

[nodejs-writer](./KUBERNETES/images_docker/nodejs-writer/app.js)


app.js
```js
const fs = require("fs");
const process = require("process");
let location = process.env.HTML_LOCATION; // <------- ENV bisa di set melalui konfigurasi kubernetes

if (!location) {
    location = "/app/html"
}

setInterval(() => {
    const date = new Date();
    const html = `<html><body>${date}</body></html>`;

    fs.writeFile(location + "/index.html", html, err => {
        if (err) {
            console.log("Failed write file")
        } else {
            console.log("Success write file")
        }
    })

}, 5000);


```

```bash
cd /home/ubuntu/KUBERNETES_FILE/pod &&
kubectl create -f pod_envrontment_variable.yaml  --namespace default

kubectl exec -it nodejs-writer -- /bin/sh

/# env
# KUBERNETES_PORT=tcp://10.96.0.1:443
# KUBERNETES_SERVICE_PORT=443
# NODE_VERSION=12.16.1
# HOSTNAME=nodejs-writer
# YARN_VERSION=1.22.0
# SHLVL=1
# HOME=/root
# HTML_LOCATION=/app/folder-from-env <--- ini ENV yg berasal dari konfigurasi yaml pod
# TERM=xterm
# KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
# PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# KUBERNETES_PORT_443_TCP_PORT=443
# KUBERNETES_PORT_443_TCP_PROTO=tcp
# KUBERNETES_SERVICE_PORT_HTTPS=443
# KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
# KUBERNETES_SERVICE_HOST=10.96.0.1
# PWD=/

/# ls /app/folder-from-env
# index.html

/# cat /app/folder-from-env/index.html
# <html><body>Fri Aug 23 2024 08:40:04 GMT+0000 (Coordinated Universal Time)</body></html>/ #

/# exit

```
