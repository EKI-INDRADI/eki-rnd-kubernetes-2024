persistent volume = mirip  dgn volume,  tapi cara kerja berbeda, sedikit lbih ribet dari volume  tapi ada beberapa benefit ketika menggunakan persistent volume (lebih gampang di manage volumenya)

<!-- https://kubernetes.io/docs/concepts/storage/persistent-volumes/ -->

jenis2 persistence volume

HostPasth = berkas disimpan di NODE, tidak dirokemndasikan di production, hanya untuk testing (dikhawatirkan NODE/vm mati / tidak bs di akses )

GCEPersistentDIsk =  Google Cloud Persistence Disk
AWSElasticBlockStore = Amazone Web Service Persistentence Disk
AzureFile/AzureDisk, Microsoft Azure Persistence DIsk
dan lain2



jika volum biasa hanya mounting volume ke pod, tapi jika persisten volume ada beberapa tahapan

tahapan persisten volume
1. membaut persistent volume
2. membuat persistent volume claim
3. Menambahkan Persisten Volume Claim ke pod


persistent volume = adanya GARANSI VOLUME

``` bash

                  | KUBERNETES CLUSTER
__________________|____________________________________
CLOUD             | POD C     | POD B     | POD A     |
__________________|___________|___________|___________|
                  |           |           |           |
Clouud Storage    | Claim 2GB | Claim 2GB | Claim 2GB | <---- di garansi akan claim storage 2GB
__________________|___________|___________|___________|
      ^                 |            |           |
      |           ______v____________v___________v_____
      |_________ |  Persaistent Storage 10GB          |
                 |____________________________________|
                 
```



membuat persistent volume / claim

```bash
kubectl create -f persistent_volume.yaml

#melihat persistent volume 

kubectl get pv 

kubectl describe pv name_pv


#melihat persistent volume Claim

kubectl get pvc 

kubectl describe pvc namapvc

#delete persistent volume

kubectl delete pv namapv


#delete persistent volume claim

kubectl delete pvc namapvc

```



Template :
[persistent-volume.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/templates/persistent-volume.yaml)

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: persistent-volume-name
spec:
  accessModes:
    - ReadWriteOnce
  capacity:
    storage: 5Gi
  hostPath:
    path: /data/location

---

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: persistent-volume-claim-name
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  resources:
    requests:
      storage: 1Gi
```

Contoh :
[persistent-volume.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/examples/persistent-volume.yaml)

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nodejs-writer-volume
spec:
  accessModes:
    - ReadWriteOnce # / ReadWriteMany / ReadOnlyMany
  capacity:
    storage: 5Gi
  hostPath: # / azureDisk,dll
    path: /data/location

---

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nodejs-writer-volume-claim
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem # / Block
  resources:
    requests:
      storage: 1Gi

---

apiVersion: v1
kind: Pod
metadata:
  name: nodejs-writer
  labels:
    name: nodejs-writer
spec:
  volumes:
    - name: html
      persistentVolumeClaim:
        claimName: nodejs-writer-volume-claim
  containers:
    - name: nodejs-writer
      image: khannedy/nodejs-writer
      volumeMounts:
        - mountPath: /app/html
          name: html
```


COBA


```bash
kubectl delete all --all

mkdir -p /home/ubuntu/KUBERNETES_FILE/service &&
cd /home/ubuntu/KUBERNETES_FILE/service &&
nano service_persistent_volume.yaml

kubectl delete -f service_persistent_volume.yaml
kubectl delete pv nodejs-writer-volume
kubectl delete pvc nodejs-writer-volume-claim


```

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nodejs-writer-volume
spec:
  accessModes:
    - ReadWriteOnce
  capacity:
    storage: 5Gi
  hostPath:
    path: /data/location

---

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nodejs-writer-volume-claim
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  resources:
    requests:
      storage: 1Gi

---

apiVersion: v1
kind: Pod
metadata:
  name: nodejs-writer
  labels:
    name: nodejs-writer
spec:
  volumes:
    - name: html
      persistentVolumeClaim:
        claimName: nodejs-writer-volume-claim
  containers:
    - name: nodejs-writer
      image: khannedy/nodejs-writer
      volumeMounts:
        - mountPath: /app/html
          name: html
```

```bash
cd /home/ubuntu/KUBERNETES_FILE/service &&
kubectl create -f service_persistent_volume.yaml  --namespace default

# persistentvolume/nodejs-writer-volume created
# persistentvolumeclaim/nodejs-writer-volume-claim created
# pod/nodejs-writer created


kubectl get -f service_persistent_volume.yaml

# NAME                                    CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
# persistentvolume/nodejs-writer-volume   5Gi        RWO            Retain           Available                          <unset>                          10s

# NAME                                               STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
# persistentvolumeclaim/nodejs-writer-volume-claim   Bound    pvc-81b55d5f-bd4f-4653-8cef-33dd91250779   1Gi        RWO            standard       <unset>                 10s

# NAME                READY   STATUS    RESTARTS   AGE
# pod/nodejs-writer   1/1     Running   0          10s

kubectl exec  -it nodejs-writer -- /bin/sh

/# cd /app/html
/# ls -l
# total 4
# -rw-r--r--    1 root     root            88 Aug 26 09:41 index.html

```