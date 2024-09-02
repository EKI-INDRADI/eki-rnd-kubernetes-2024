

menampilkan semua resource yg ada pada kubernetes

get
```bash
kubectl get all 
kubectl get all --namespace default
```

delete
```bash
kubectl delete all --all # semua akan terhapus untuk service2 yang di butuhkan kubernetes akan tetap ada (terbuat ulang otomatis
kubectl delete all --all --namespace default

```