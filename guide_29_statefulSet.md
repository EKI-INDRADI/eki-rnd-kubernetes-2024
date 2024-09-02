statefulSet

pod, replicaset,replicationController,Deployment digunakan utnuk aplikasi stateless



stateless =  kita tidak meyinpan state atau data, jadi jika di tengah jalan aplikasi kita di hapus dan dibuat ulang tidak akan bermasalah.

contoh database = stateful


stateful = bisa menyimpan data dan tidak sembarang di hapus di tengah jalan  ketika kita melakukan update aplikasi




stateless = hewan ternak (tidak peduli siapa yg mati), yang penting bs di ganti oleh hewan baru

stateful = adalah hewan perliharaan (tidak bs di ganti dengan gampang, hrs di rawat / di cari hewan yang sama sesuai karateristiknya)
- nama pod konsisten
- network stabil
- persisten volum yg stabil untuk tiap pod
- jika ada pod mati, maka statefulset akan membuat pod baru dgn nama dan informasi yang sama dengan pod yg mati

statefulset memiliki kemampuan untuk menambahkan volume claim template



membuat statefulset
```bash
kubectl create -f statuefulset.yaml

kubectl get statefulsets

kubectl describe statefulset name_statefulset

kubectl delete statefulset name_statefulset

# https://youtu.be/NWr7_BggPCA?list=PL-CtdCApEFH8XrWyQAyRd6d_CKwxD8Ime&t=53

```


Template :
[statefulset.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/templates/statefulset.yaml)

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: name-stateful
  labels:
    name: name-stateful
spec:
  # https://github.com/kubernetes/kubernetes/issues/69608
  serviceName: name-stateful-service
  replicas: 3
  selector:
    matchLabels:
      name: name-stateful
  volumeClaimTemplates:
    - metadata:
        name: name-stateful-volume-claim
      spec:
        accessModes:
          - ReadWriteOnce
        volumeMode: Filesystem
        resources:
          requests:
            storage: 1Gi
  template:
    metadata:
      name: name-stateful
      labels:
        name: name-stateful
    spec:
      containers:
        - name: name-stateful
          image: image/name-stateful
          volumeMounts:
            - mountPath: /app/data
              name: name-stateful-volume-claim
```

Contoh :
[statefulset.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/examples/statefulset.yaml)

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nodejs-stateful-volume
spec:
  accessModes:
    - ReadWriteOnce
  capacity:
    storage: 5Gi
  hostPath:
    path: /data/location

---

apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: nodejs-stateful
  labels:
    name: nodejs-stateful
spec:
  # https://github.com/kubernetes/kubernetes/issues/69608
  serviceName: nodejs-stateful-service
  replicas: 3
  selector:
    matchLabels:
      name: nodejs-stateful
  volumeClaimTemplates:
    - metadata:
        name: nodejs-stateful-volume-claim
      spec:
        accessModes:
          - ReadWriteOnce
        volumeMode: Filesystem
        resources:
          requests:
            storage: 1Gi
  template:
    metadata:
      name: nodejs-stateful
      labels:
        name: nodejs-stateful
    spec:
      containers:
        - name: nodejs-stateful
          image: khannedy/nodejs-stateful
          env:
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
          volumeMounts:
            - mountPath: /app/data
              name: nodejs-stateful-volume-claim
```




```bash
kubectl delete all --all

mkdir -p /home/ubuntu/KUBERNETES_FILE/service &&
cd /home/ubuntu/KUBERNETES_FILE/service &&
nano service_stateful_set.yaml

kubectl delete -f service_stateful_set.yaml
```

NOTE : statefulset mirip buat deployment
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nodejs-stateful-volume
spec:
  accessModes:
    - ReadWriteOnce
  capacity:
    storage: 5Gi
  hostPath:
    path: /data/location

---

apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: nodejs-stateful
  labels:
    name: nodejs-stateful
spec:
  # https://github.com/kubernetes/kubernetes/issues/69608
  serviceName: nodejs-stateful-service
  replicas: 3
  selector:
    matchLabels:
      app-selector: nodejs-stateful
  volumeClaimTemplates:
    - metadata:
        name: nodejs-stateful-volume-claim
      spec:
        accessModes:
          - ReadWriteOnce
        volumeMode: Filesystem
        resources:
          requests:
            storage: 1Gi
  template:
    metadata:
      name: nodejs-stateful
      labels:
        app-selector: nodejs-stateful
    spec:
      containers:
        - name: nodejs-stateful
          image: khannedy/nodejs-stateful
          env:
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
          volumeMounts:
            - mountPath: /app/data
              name: nodejs-stateful-volume-claim
```

```bash
cd /home/ubuntu/KUBERNETES_FILE/service &&
kubectl create -f service_stateful_set.yaml  --namespace default
# persistentvolume/nodejs-stateful-volume created
# statefulset.apps/nodejs-stateful created

kubectl get all 

# pod/nodejs-stateful-0   1/1     Running   0          33s
# pod/nodejs-stateful-1   1/1     Running   0          25s
# pod/nodejs-stateful-2   1/1     Running   0          19s

# NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
# service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   4m6s

# NAME                               READY   AGE
# statefulset.apps/nodejs-stateful   3/3     33s


kubectl get pvc
# NAME                                             STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
# nodejs-stateful-volume-claim-nodejs-stateful-0   Bound    pvc-e37bfe06-4d15-4b7d-a674-bb28195ee0ab   1Gi        RWO            standard       <unset>                 2m23s
# nodejs-stateful-volume-claim-nodejs-stateful-1   Bound    pvc-2f198cc7-eccc-4f31-b88b-2841fe3bc7bd   1Gi        RWO            standard       <unset>                 2m15s
# nodejs-stateful-volume-claim-nodejs-stateful-2   Bound    pvc-42d23868-0e9b-4ab3-8cae-533b5b967623   1Gi        RWO            standard       <unset>                 2m9s



kubectl delete pod nodejs-stateful-1
# pod "nodejs-stateful-1" deleted

#  NAME                    READY   STATUS    RESTARTS   AGE
# pod/nodejs-stateful-0   1/1     Running   0          10m
# pod/nodejs-stateful-1   1/1     Running   0          4m21s <!---- secara otomatis akan membuat dengan nama sama berbeda dengan replicaset dengan nama berbeda
# pod/nodejs-stateful-2   1/1     Running   0          10m

# NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
# service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   14m

# NAME                               READY   AGE
# statefulset.apps/nodejs-stateful   3/3     10m


```