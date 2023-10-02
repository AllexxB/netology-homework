# Домашнее задание к занятию «Хранение в K8s. Часть 1»



### Задание 1 

**Что нужно сделать**

Создать Deployment приложения, состоящего из двух контейнеров и обменивающихся данными.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
Файл [Dep-1.yaml](./Dep-1.yaml)
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: testapps
spec:
  replicas: 1
  selector:
    matchLabels:
      app: testapps
  template:
    metadata:
      labels:
        app: testapps
    spec:
      containers:
        - name: busybox
          image: busybox
          command: ["/bin/sh", "-c", "while true; do echo Test! >> /output/test.txt; sleep 5; done"]
          volumeMounts:
            - name: test-volume
              mountPath: /output
        - name: multitool
          image: wbitt/network-multitool:latest
          env:
            - name: HTTP_PORT
              value: "1180"
            - name: HTTPS_PORT
              value: "11443"
          ports:
            - containerPort: 1180
              name: http-port
            - containerPort: 11443
              name: https-port
          volumeMounts:
            - name: test-volume
              mountPath: /input
      volumes:
        - name: test-volume
          emptyDir: {}
```

2. Сделать так, чтобы busybox писал каждые пять секунд в некий файл в общей директории.
3. Обеспечить возможность чтения файла контейнером multitool.
4. Продемонстрировать, что multitool может читать файл, который периодоически обновляется.
5. Предоставить манифесты Deployment в решении, а также скриншоты или вывод команды из п. 4.

```
user@k8s:~$ kubectl apply -f Dep-1.yaml 
deployment.apps/testapps created
user@k8s:~$ kubectl get po -o wide
NAME                        READY   STATUS    RESTARTS   AGE   IP           NODE   NOMINATED NODE   READINESS GATES
testapps-786884588c-69lqs   2/2     Running   0          33s   10.1.77.62   k8s    <none>           <none>
user@k8s:~$ kubectl exec -it pods/testapps-786884588c-69lqs -c multitool -- cat /input/test.txt
Test!
Test!
Test!
Test!
user@k8s:~$

```
------

### Задание 2

**Что нужно сделать**

Создать DaemonSet приложения, которое может прочитать логи ноды.

1. Создать DaemonSet приложения, состоящего из multitool.

Файл [Deam-1.yaml](./Deam-1.yaml)
```
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: multitool
  labels:
    app: multitool
spec:
  selector:
    matchLabels:
      app: multitool
  template:
    metadata:
      labels:
        app: multitool
    spec:
      containers:
        - name: multitool
          image: wbitt/network-multitool:latest
          env:
            - name: HTTP_PORT
              value: "1180"
            - name: HTTPS_PORT
              value: "11443"
          ports:
            - containerPort: 1180
              name: http-port
            - containerPort: 11443
              name: https-port
          volumeMounts:
            - name: log-volume
              mountPath: /var/log/syslog
      volumes:
        - name: log-volume
          hostPath:
            path: /var/log/syslog
```
2. Обеспечить возможность чтения файла `/var/log/syslog` кластера MicroK8S.
3. Продемонстрировать возможность чтения файла изнутри пода.
4. Предоставить манифесты Deployment, а также скриншоты или вывод команды из п. 2.
```
ser@k8s:~$ kubectl apply -f Deam-1.yaml 
daemonset.apps/multitool created
user@k8s:~$ kubectl get po -o wide
NAME              READY   STATUS    RESTARTS   AGE   IP          NODE   NOMINATED NODE   READINESS GATES
multitool-ltbd6   1/1     Running   0          17s   10.1.77.3   k8s    <none>           <none>
user@k8s:~$ kubectl exec -it pods/multitool-ltbd6 -- tail -n 5 /var/log/syslog
Oct  2 12:15:24 k8s systemd[1]: run-containerd-runc-k8s.io-3397f026cf7d664f4aea7a24cb31eacd7c094cff3ebb266b1f48eea29573cdd0-runc.mzrXOz.mount: Succeeded.
Oct  2 12:15:24 k8s microk8s.daemon-containerd[665]: time="2023-10-02T12:15:24.972717603Z" level=info msg="Container exec \"87eed2f9f604a15c55be4227a4a7296acbd49a664f8c032f4572af20927b010b\" stdin closed"
Oct  2 12:15:24 k8s microk8s.daemon-containerd[665]: time="2023-10-02T12:15:24.974069874Z" level=error msg="Failed to resize process \"87eed2f9f604a15c55be4227a4a7296acbd49a664f8c032f4572af20927b010b\" console for container \"3397f026cf7d664f4aea7a24cb31eacd7c094cff3ebb266b1f48eea29573cdd0\"" error="cannot resize a stopped container: unknown"
Oct  2 12:15:31 k8s systemd[2310]: run-containerd-runc-k8s.io-3397f026cf7d664f4aea7a24cb31eacd7c094cff3ebb266b1f48eea29573cdd0-runc.XN07T6.mount: Succeeded.
Oct  2 12:15:31 k8s systemd[1]: run-containerd-runc-k8s.io-3397f026cf7d664f4aea7a24cb31eacd7c094cff3ebb266b1f48eea29573cdd0-runc.XN07T6.mount: Succeeded.
user@k8s:~$

```


------


