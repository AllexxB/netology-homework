### Задание 1

**Что нужно сделать**

Создать Deployment приложения, использующего локальный PV, созданный вручную.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
Файл [Dep-1.yaml](./Dep-1.yaml)
```
apiVersion : apps/v1
kind: Deployment
metadata:
  name: dep1
  labels:
    app: main
spec:
  replicas: 1
  selector:
    matchLabels:
      app: main
  template:
    metadata:
      labels:
        app: main
    spec:
      containers:
        - name: busybox
          image: busybox
          command: ['sh', '-c', 'while true; do watch -n 5 date >> /test/output.txt; sleep 5; done']
          volumeMounts:
          - mountPath: /test
            name: volume
        - name: multitool
          image: wbitt/network-multitool
          volumeMounts:
          - mountPath: /test
            name: volume
          env:
          - name: HTTP_PORT
            value: "80"
          ports:
          - containerPort: 80
            name: http-port
      volumes:
      - name: volume
        persistentVolumeClaim:
          claimName: pvc

```
2. Создать PV и PVC для подключения папки на локальной ноде, которая будет использована в поде.
Файл [pv.yaml](./pv.yaml)
```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv
spec:
  storageClassName: ""
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /test/pv
  persistentVolumeReclaimPolicy: Delete
```
Файл [pvc.yaml](./pvc.yaml)
```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc
spec:
  storageClassName: ""
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```
3. Продемонстрировать, что multitool может читать файл, в который busybox пишет каждые пять секунд в общей директории. 
```
user@k8s:~$ kubectl get pods
NAME                    READY   STATUS    RESTARTS   AGE
multitool-czwch         1/1     Running   0          9m48s
dep1-558b48b5c4-7ll6l   2/2     Running   0          7m56s
user@k8s:~$ kubectl exec dep1-558b48b5c4-7ll6l -c multitool  -- tail -n 2 /test/output.txt

Thu Oct 19 11:33:17 UTC 2023
user@k8s:~$ 
```
4. Удалить Deployment и PVC. Продемонстрировать, что после этого произошло с PV. Пояснить, почему.
```
user@k8s:~$ kubectl get deployments
NAME   READY   UP-TO-DATE   AVAILABLE   AGE
dep1   1/1     1            1           10m
user@k8s:~$ kubectl delete deployments dep1 
deployment.apps "dep1" deleted
user@k8s:~$ kubectl get pvc
NAME   STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
pvc    Bound    pv       1Gi        RWO                           11m
user@k8s:~$ kubectl delete pvc pvc
persistentvolumeclaim "pvc" deleted
user@k8s:~$ kubectl get pv
NAME   CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM         STORAGECLASS   REASON   AGE
pv     1Gi        RWO            Delete           Failed   default/pvc                           11m
user@k8s:~$ 
```
#### PV не удалился тк это отдельный элемент кластера и не удаляется при удалении PVC.

5. Продемонстрировать, что файл сохранился на локальном диске ноды. Удалить PV.  Продемонстрировать что произошло с файлом после удаления PV. Пояснить, почему.
```
ser@k8s:~$ ls /test/pv/output.txt
/test/pv/output.txt
user@k8s:~$ kubectl delete pv pv
persistentvolume "pv" deleted
user@k8s:~$ ls /test/pv/output.txt
/test/pv/output.txt
user@k8s:~$ 

```
#### Файл локально не удалился даже не смотря на параметр в манифесте pv.yaml persistentVolumeReclaimPolicy: Delete, т.к. в лекции указано, что при удалении pv и таком параметре просиходит удаление ресурсов, но работает только в облачных решениях.

5. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

------

### Задание 2

**Что нужно сделать**

Создать Deployment приложения, которое может хранить файлы на NFS с динамическим созданием PV.

1. Включить и настроить NFS-сервер на MicroK8S.
2. Создать Deployment приложения состоящего из multitool, и подключить к нему PV, созданный автоматически на сервере NFS.
Файл [Dep-2.yaml](./Dep-2.yaml)
```
apiVersion : apps/v1
kind: Deployment
metadata:
  name: multitool
  labels:
    app: main
spec:
  replicas: 1
  selector:
    matchLabels:
      app: main
  template:
    metadata:
      labels:
        app: main
    spec:
      containers:
        - name: busybox
          image: busybox
          command: ['sh', '-c', 'while true; do watch -n 5 date >> /test/output.txt; sleep 5; done']
          volumeMounts:
          - mountPath: /test
            name: volume2
        - name: multitool
          image: wbitt/network-multitool
          volumeMounts:
          - mountPath: /test
            name: volume2
          env:
          - name: HTTP_PORT
            value: "80"
          ports:
          - containerPort: 80
            name: http-port
      volumes:
      - name: volume2
        persistentVolumeClaim:
          claimName: my-pvc
```
Файл [pvc-nfs.yaml](./pvc-nfs.yaml)
```
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  storageClassName: nfs-csi
  accessModes: [ReadWriteOnce]
  resources:
    requests:
      storage: 1Gi
```
Файл [sc-nfs.yaml](./sc-nfs.yaml)
```
---
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: nfs-csi
provisioner: nfs.csi.k8s.io
parameters:
  server: 127.0.0.1
  share: /srv/nfs
reclaimPolicy: Delete
volumeBindingMode: Immediate
mountOptions:
  - hard
  - nfsvers=4.1
```
3. Продемонстрировать возможность чтения и записи файла изнутри пода. 
```
user@k8s:~$ kubectl get po
NAME                         READY   STATUS    RESTARTS   AGE
multitool-659558c775-rqr8l              2/2     Running   0          4m3s
user@k8s:~$
user@k8s:~$ kubectl exec multitool-659558c775-rqr8l -c multitool  -- tail -n 2 /test/output.txt

Thu Oct 19 11:48:17 UTC 2023
user@k8s:~$ 
```

4. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

------
