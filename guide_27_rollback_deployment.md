rollback deployment = cara paling mudah agar tidak terjadi error terlalu lama adalah rollback ke deployment sebelumnya


rolback otomatis ke versi sebelumnya , tanpa harus manual



kubernetes rollout

```bash

kubectl rollout command                      |   Keterangan
_______________________________________________________________________________________
kubectl rollout history object name          |   melihat history rollout
kubectl rollout pause object name            |   Menanda sebagai pause
kubectl rollout resume object name           |   Resume pause
kubectl rollout restart object name          |   Merestart rollout
kubectl rollout status object name           |   Melihat status rollout
kubectl rollout undo object name             |   Undo ke rollout sebelumnya



NOTE  : tidak semua punya kemampuan untul rollout hanya deployments , daemonsets, statefulsets

kubectl rollout

# Manage the rollout of one or many resources.

#  Valid resource types include:

#   *  deployments
#   *  daemonsets
#   *  statefulsets

# Examples:
#   # Rollback to the previous deployment
#   kubectl rollout undo deployment/abc

#   # Check the rollout status of a daemonset
#   kubectl rollout status daemonset/foo

#   # Restart a deployment
#   kubectl rollout restart deployment/abc

#   # Restart deployments with the 'app=nginx' label
#   kubectl rollout restart deployment --selector=app=nginx

# Available Commands:
#   history       View rollout history
#   pause         Mark the provided resource as paused
#   restart       Restart a resource
#   resume        Resume a paused resource
#   status        Show the status of the rollout
#   undo          Undo a previous rollout

# Usage:
#   kubectl rollout SUBCOMMAND [options]

# Use "kubectl rollout <command> --help" for more information about a given command.
# Use "kubectl options" for a list of global command-line options (applies to all commands).


```



Rollback Deployment

```bash
kubectl rollout undo deployment dployment_name
```


Contoh :
[deployment-update-again.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/examples/deployment-update-again.yaml)


```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nodejs-web
  labels:
    name: nodejs-web
spec:
  replicas: 3
  selector:
    matchLabels:
      name: nodejs-web
  template:
    metadata:
      name: nodejs-web
      labels:
        name: nodejs-web
    spec:
      containers:
        - name: nodejs-web
          image: khannedy/nodejs-web:3
          ports:
            - containerPort: 3000
```


COBA


```bash
# kubectl delete all --all #(DONT USE)
kubectl rollout history deployment nodejs-web
# deployment.apps/nodejs-web
# REVISION  CHANGE-CAUSE
# 1         <none>
# 2         <none>

kubectl rollout status deployment nodejs-web

# deployment "nodejs-web" successfully rolled out 
#<!--- artinya deployment sebelumnya success



mkdir -p /home/ubuntu/KUBERNETES_FILE/service &&
cd /home/ubuntu/KUBERNETES_FILE/service &&
nano service_deployment_nodejs_web_again.yaml

# rubah  khannedy/nodejs-web:2 menjadi khannedy/nodejs-web:3
```

NOTE : hanya update nodejs-web nya saja
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nodejs-web
  labels:
    name: nodejs-web
spec:
  revisionHistoryLimit: 10
  replicas: 3
  selector:
    matchLabels:
      app-selector: nodejs-web
  template:
    metadata:
      name: nodejs-web
      labels:
        app-selector: nodejs-web
    spec:
      containers:
        - name: nodejs-web
          image: khannedy/nodejs-web:3
          ports:
            - containerPort: 3000
```

```bash
cd /home/ubuntu/KUBERNETES_FILE/service &&
kubectl apply -f service_deployment_nodejs_web_again.yaml  --namespace default
# deployment.apps/nodejs-web configured

kubectl rollout status deployment nodejs-web
# deployment "nodejs-web" successfully rolled out



kubectl rollout history deployment nodejs-web
# deployment.apps/nodejs-web
# REVISION  CHANGE-CAUSE
# 1         <none>
# 2         <none>
# 3         <none>

minikube service nodejs-web-service 

|-----------|--------------------|-------------|---------------------------|
| NAMESPACE |        NAME        | TARGET PORT |            URL            |
|-----------|--------------------|-------------|---------------------------|
| default   | nodejs-web-service |        3000 | http://192.168.49.2:30001 |
|-----------|--------------------|-------------|---------------------------|
# * Opening service default/nodejs-web-service in default browser...
#   http://192.168.49.2:30001



kubectl port-forward --address 0.0.0.0 service/nodejs-web-service 30001:3000 

  # http://<YOUR_IP_PUBLIC>:30001/


# Application 3.0 
# (aplikasi sudah naik V3)
```


ROLLBACK
```bash
kubectl rollout undo deployment nodejs-web
# deployment.apps/nodejs-web rolled back
kubectl rollout status deployment nodejs-web
# deployment "nodejs-web" successfully rolled out

kubectl rollout history deployment nodejs-web
# deployment.apps/nodejs-web
# REVISION  CHANGE-CAUSE
# 1         <none>
# 3         <none>
# 4         <none> <!---- JADI VERSI 4 (karena dia melakukan undo dari versi 3 ke versi 2, dalam kondisi update)

minikube service nodejs-web-service 

|-----------|--------------------|-------------|---------------------------|
| NAMESPACE |        NAME        | TARGET PORT |            URL            |
|-----------|--------------------|-------------|---------------------------|
| default   | nodejs-web-service |        3000 | http://192.168.49.2:30001 |
|-----------|--------------------|-------------|---------------------------|
# * Opening service default/nodejs-web-service in default browser...
#   http://192.168.49.2:30001

kubectl port-forward --address 0.0.0.0 service/nodejs-web-service 30001:3000 

  # http://<YOUR_IP_PUBLIC>:30001/


# Application 2.0
# balik lagi ke versi 2


kubectl delete -f service_deployment_nodejs_web.yaml

kubectl delete all --all 

```




