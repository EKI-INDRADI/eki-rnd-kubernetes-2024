
probe pengecekan ada 3 di kubernetes

liveness, readiness, startup 


liveness probe = pengecekan periodic pengecheck health, jika tdk sehat = me-restart pod
readiness probe = pengecekan periodic pengecheck health, jika tdk sehat = stop semua traffic pod
startup probe = pengecekan periodic pengecheck health di awal saja, memastikan aplikasi siap untuk berjalan



mekanisme pengecekan probe

HTTP GET = WEB
TCP SOCKET = BUKAN WEB / SOCKET SERVER
Command Exec = command line

[pod-with-probe.yml](https://github.com/khannedy/belajar-kubernetes/blob/master/templates/pod-with-probe.yaml)
```yml
apiVersion: v1
kind: Pod
metadata:
  name: pod-name
  labels:
    label-key1: label-value1
  annotations:
    annotation-key1: annotation-value
    annotation-key2: veri long annotation value, bla bla bla bla bla bla
spec:
  containers:
    - name: container-name
      image: image-name
      ports:
        - containerPort: 80
      livenessProbe:
        httpGet:
          path: /health
          port: 80
        initialDelaySeconds: 0
        periodSeconds: 10
        timeoutSeconds: 1
        successThreshold: 1
        failureThreshold: 3
      readinessProbe:
        httpGet:
          path: /
          port: 80
        initialDelaySeconds: 0
        periodSeconds: 10
        timeoutSeconds: 1
        successThreshold: 1
        failureThreshold: 3
      startupProbe:
        httpGet:
          path: / 
          port: 80
        initialDelaySeconds: 0
        periodSeconds: 10
        timeoutSeconds: 1
        successThreshold: 1
        failureThreshold: 3
```

```bash
mkdir -p /home/ubuntu/KUBERNETES_FILE/pod && 
cd /home/ubuntu/KUBERNETES_FILE/pod && 
nano pod_nginx_with_probe.yaml
```

```yml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-with-probe
spec:
  containers:
    - name: nginx-320
      image: nginx:stable-alpine3.20
      ports:
        - containerPort: 80
      livenessProbe:
        httpGet:
          path: /
          port: 80
        initialDelaySeconds: 5
        periodSeconds: 5
        timeoutSeconds: 1
        successThreshold: 1
        failureThreshold: 3
```

initialDelaySeconds = pertamakali melakukan pengecekan mau nunggu brp detik (jangan 0)
periodSeconds =  periode pengecekannya seberapa sering
timeoutSeconds = kondisi connect di anggap timoutnya brp lama, kalo balikan lebih dari 1 sec maka di anggap tidak sehat
successThreshold = kondisi dari sebelumnya tidak sehat, brp kali pengecekan sehat sampai dia sehat
failureThreshold = brp kali pengecekan gagal sampai dia dianggap tidak sehat dan harus di..... (kalo di livenessProbe restart)


submit pod
```bash

kubectl create -f pod_nginx_with_probe.yaml --namespace default


kubectl get pod
kubectl describe pod nginx-with-probe

kubectl port-forward nginx-with-probe 8081:80 #hanya running di localhost

#or

kubectl port-forward --address 0.0.0.0 nginx-with-probe 8081:80 #hanya running di export public
# <YOUR_IP_PUBLIC>:8081
```




check restart

```bash
kubectl get pod
kubectl describe pod nginx-with-probe

#....
#....
#Containers:
#  nginx-320:
#    Container ID:   docker://f37a6304bacfaa52899d7d86ee82594f177a5fd40e5ca1acbc777911ea347878
#    Image:          nginx:stable-alpine3.20
#    Image ID:       docker-pullable://nginx@sha256:d4d72ee8e6d028c5ad939454164d3645be2d38afb5c352277926a48e24abf4fa
#    Port:           80/TCP
#    Host Port:      0/TCP
#    State:          Running
#      Started:      Tue, 20 Aug 2024 07:03:54 +0000
#    Ready:          True
#    Restart Count:  0
#    Liveness:       http-get http://:80/ delay=5s timeout=1s period=5s #success=1 #failure=3
#    Environment:    <none>
#    Mounts:
#      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-9bxt8 (ro)
#....
#....



# kubectl delete pod nginx-with-probe
```


simulasi error describe pod

```bash
mkdir -p /home/ubuntu/KUBERNETES_FILE/pod && 
cd /home/ubuntu/KUBERNETES_FILE/pod && 
nano pod_nginx_with_probe_error.yaml
```

```yml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-with-probe-error
spec:
  containers:
    - name: nginx-320
      image: nginx:stable-alpine3.20
      ports:
        - containerPort: 80
      livenessProbe:
        httpGet:
          path: /404
          port: 80
        initialDelaySeconds: 5
        periodSeconds: 5
        timeoutSeconds: 1
        successThreshold: 1
        failureThreshold: 3
```

submit pod
```bash

kubectl create -f pod_nginx_with_probe_error.yaml --namespace default

kubectl get pod

kubectl describe pod nginx-with-probe-error

kubectl port-forward --address 0.0.0.0 nginx-with-probe-error 8080:80

# <YOUR_IP_PUBLIC>:8080

#or

curl 0.0.0.0:8080/404 (ssh lagi)




#kubectl get pod             
#NAME                     READY   STATUS             RESTARTS      AGE
#nginx-with-probe         1/1     Running            0             28m
#nginx-with-probe-error   0/1     CrashLoopBackOff   7 (84s ago)   8m44s


kubectl describe pod nginx-with-probe-error


# Events:
#  Type     Reason     Age                    From     Message
#  ----     ------     ----                   ----     -------
#  Warning  Unhealthy  32m (x46 over 62m)     kubelet  Liveness probe failed: HTTP probe failed with statuscode: 404
#  Warning  BackOff    2m49s (x251 over 61m)  kubelet  Back-off restarting failed container nginx-320 in pod nginx-with-probe-error_default(17585df3-42d5-4ff8-9201-949b87d620d0)


```