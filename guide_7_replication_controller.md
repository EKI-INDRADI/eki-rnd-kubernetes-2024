replication controller = memastikan bahwa pod selalu berjalan

real case jarang bikin pod hanya 1 dalam aplikasi , biasanya minimal 2 atau bisa lebih

replication controller untuk buat pod dalam jumlah tertentu, jika ada hilang/mati pada pod maka auto akan mengganti sama persis

berbeda dengan create manual pod , jika masalah hilang hrs manual create pod lagi



create pod menggunakan replication controller = memastikan podnya akan selalu ada, jika terjadi masalah / error replication controller akan membuat pod ke node yg lain

label selector = penanda pod
replica count = jumlah pod yg harus berjalan
pod tempalte = configurasi untuk menjalankan pod

[replication-controller.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/templates/replication-controller.yaml)


```yml
apiVersion: v1
kind: ReplicationController
metadata:
  name: nama-replication-controller
  labels:
    label-key1: label-value1 
  annotations:
    annotation-key1: annotation-value1
spec:
  replicas: 3
  selector:
    label-key1: label-value1
  template:
    metadata:
      name: nama-pod
      labels:
        label-key1: label-value1
    spec:
      containers:
        - name: container-name
          image: image-name
          ports:
            - containerPort: 80
          readinessProbe:
            httpGet:
              path: /health
              port: 80
            initialDelaySeconds: 0
            periodSeconds: 10
            failureThreshold: 3
            successThreshold: 1
            timeoutSeconds: 1
```

NOTE :
replcation controler bs di tambahkan label dan annotation

pada selector & labels  <label-key1>: <label-value1> WAJIB SAMA karena untuk keperluan selector replication


```yml
#   selector:
    <label-key1>: <label-value1>
#   template:
#     metadata:
#       name: nama-pod
#       labels:
        <label-key1>: <label-value1>
```

```bash
mkdir -p /home/ubuntu/KUBERNETES_FILE/replication_controller && 
cd /home/ubuntu/KUBERNETES_FILE/replication_controller && 
nano rc_nginx.yaml
```


```yml
apiVersion: v1
kind: ReplicationController
metadata:
  name: rc-nginx
spec:
  replicas: 3
  selector:
   app-selector: rc-nginx-app-selector
  template:
    metadata:
      name: rc-nginx
      labels:
       app-selector: rc-nginx-app-selector
    spec:
      containers:
        - name: nginx-320
          image: nginx:stable-alpine3.20
          ports:
            - containerPort: 80
```


```bash
cd /home/ubuntu/KUBERNETES_FILE/replication_controller &&
kubectl create -f rc_nginx.yaml --namespace default

```


melihat replication controller dan pod nya

``` bash
kubectl get replicationcontrollers
#or
kubectl get replicationcontroller
#or
kubectl get rc

#NAME       DESIRED   CURRENT   READY   AGE
#rc-nginx   3         3         3       97s

kubectl get pod --namespace default

#NAME                     READY   STATUS             RESTARTS         AGE
#nginx-with-probe         1/1     Running            0                144m
#nginx-with-probe-error   0/1     CrashLoopBackOff   48 (2m41s ago)   125m
#rc-nginx-m7gqg           1/1     Running            0                5m22s
#rc-nginx-mwz5j           1/1     Running            0                5m22s
#rc-nginx-x6p4b           1/1     Running            0                5m22s



# NOTE : TEST DELETE POD DALAM KONDISI REPLICATION, TETAP AKAN TERBUAT KEMBALI

kubectl delete pod rc-nginx-x6p4b --namespace default
#kubectl delete pod rc-nginx-x6p4b --namespace default
#pod "rc-nginx-x6p4b" deleted


kubectl get pod --namespace default

#NAME                     READY   STATUS             RESTARTS       AGE
#nginx-with-probe         1/1     Running            0              148m
#nginx-with-probe-error   0/1     CrashLoopBackOff   50 (18s ago)   128m
#rc-nginx-m7gqg           1/1     Running            0              8m44s
#rc-nginx-mwz5j           1/1     Running            0              8m44s
#rc-nginx-tzq5z           1/1     Running            0              7s

```


hapus relication controller

```bash

kubectl get rc --namespace default
#NAME       DESIRED   CURRENT   READY   AGE
#rc-nginx   3         3         3       16m

kubectl delete rc rc_name
# delete with pod in label selector
 
kubectl delete rc rc_name --cascade=false
# delete without pod in label selector

# ex : kubectl delete rc rc-nginx
kubectl get rc
kubectl get pod
```



NOTE : ketika menghapus replication controller secara otomatis pod yang berada pada label selectornya akan terhapus, 

jika ingin tanpa menghapus POD nya maka tambahkan opsi --cascade=false


```bash
cd /home/ubuntu/KUBERNETES_FILE/replication_controller &&
kubectl create -f rc_nginx.yaml --namespace default

kubectl get rc
kubectl get pod

kubectl delete rc rc-nginx --cascade=false
#warning: --cascade=false is deprecated (boolean value) and can be replaced with --cascade=orphan.
#replicationcontroller "rc-nginx" deleted

cd /home/ubuntu/KUBERNETES_FILE/replication_controller &&
kubectl create -f rc_nginx.yaml --namespace default
kubectl delete rc rc-nginx --cascade=orphan


#NOTE : jika menggunakan cascade tidak akan hilang pod nya

#ubuntu@AZRN-VM-SV-PROD-KUBERNETES:~/KUBERNETES_FILE/replication_controller$ kubectl get rc
#No resources found in default namespace.

#ubuntu@AZRN-VM-SV-PROD-KUBERNETES:~/KUBERNETES_FILE/replication_controller$ kubectl get pod
#NAME                     READY   STATUS             RESTARTS         AGE
#nginx-with-probe         1/1     Running            0                163m
#nginx-with-probe-error   0/1     CrashLoopBackOff   54 (3m48s ago)   143m
#rc-nginx-6mcjm           1/1     Running            0                2m17s
#rc-nginx-9mszq           1/1     Running            0                2m17s
#rc-nginx-rbpjd           1/1     Running            0                2m17s


```