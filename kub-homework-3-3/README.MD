# Домашнее задание к занятию «Как работает сеть в K8s»

### Цель задания

Настроить сетевую политику доступа к подам.

### Чеклист готовности к домашнему заданию

1. Кластер K8s с установленным сетевым плагином Calico.

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Документация Calico](https://www.tigera.io/project-calico/).
2. [Network Policy](https://kubernetes.io/docs/concepts/services-networking/network-policies/).
3. [About Network Policy](https://docs.projectcalico.org/about/about-network-policy).

-----

### Задание 1. Создать сетевую политику или несколько политик для обеспечения доступа

1. Создать deployment'ы приложений frontend, backend и cache и соответсвующие сервисы.


2. В качестве образа использовать network-multitool.
3. Разместить поды в namespace App.
4. Создать политики, чтобы обеспечить доступ frontend -> backend -> cache. Другие виды подключений должны быть запрещены.
5. Продемонстрировать, что трафик разрешён и запрещён.

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

deployments.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: multitool
        image: wbitt/network-multitool
        resources:
          limits:
            cpu: "0.5"
            memory: "100Mi"
          requests:
            cpu: "0.25"
            memory: "50Mi"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  namespace: app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: multitool
        image: wbitt/network-multitool
        resources:
          limits:
            cpu: "0.5"
            memory: "100Mi"
          requests:
            cpu: "0.25"
            memory: "50Mi"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cache
  namespace: app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: cache
  template:
    metadata:
      labels:
        app: cache
    spec:
      containers:
      - name: multitool
        image: wbitt/network-multitool
        resources:
          limits:
            cpu: "0.5"
            memory: "100Mi"
          requests:
            cpu: "0.25"
            memory: "50Mi"
```
services.yaml

```yaml
---
apiVersion: v1
kind: Service
metadata:
  name: frontend-service
  namespace: app
spec:
  selector:
    app: frontend
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80

---
apiVersion: v1
kind: Service
metadata:
  name: backend-service
  namespace: app
spec:
  selector:
    app: backend
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80

---
apiVersion: v1
kind: Service
metadata:
  name: cache-service
  namespace: app
spec:
  selector:
    app: cache
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80

```

user@master:~$ kubectl create namespace app
namespace/app created
user@master:~$ kubectl get ns
NAME              STATUS   AGE
app               Active   10s
default           Active   7d1h
kube-flannel      Active   7d
kube-node-lease   Active   7d1h
kube-public       Active   7d1h
kube-system       Active   7d1h
user@master:~$



user@master:~$ kubectl apply -f deployments.yaml
deployment.apps/frontend created
deployment.apps/backend created
deployment.apps/cache created
user@master:~$ kubectl apply -f services.yaml
service/frontend-service created
service/backend-service created
service/cache-service created
user@master:~$ kubectl get pods -n app
NAME                        READY   STATUS    RESTARTS   AGE
backend-68c75fdbf7-nfkn7    1/1     Running   0          19s
cache-68d6b77c7f-h6cds      1/1     Running   0          19s
frontend-787fd44db9-9n5zl   1/1     Running   0          19s
user@master:~$




Politics.yaml
```yaml
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-to-backend
  namespace: app
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
  - Ingress  
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: frontend  

---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-backend-to-cache
  namespace: app
spec:
  podSelector:
    matchLabels:
      app: cache  
  policyTypes:
  - Ingress  
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: backend  
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all-to-frontend
  namespace: app
spec:
  podSelector:
    matchLabels:
      app: frontend  
  policyTypes:
  - Ingress  
  ingress: []  

```

```
user@master:~$ kubectl apply -f Politics.yaml 
networkpolicy.networking.k8s.io/allow-frontend-to-backend created
networkpolicy.networking.k8s.io/allow-backend-to-cache created
networkpolicy.networking.k8s.io/deny-all-to-frontend created
user@master:~$
```


```
user@master:~$ kubectl get pods -n app -o wide
NAME                        READY   STATUS    RESTARTS   AGE   IP           NODE    NOMINATED NODE   READINESS GATES
backend-68c75fdbf7-nfkn7    1/1     Running   0          20m   10.244.4.3   node4   <none>           <none>
cache-68d6b77c7f-h6cds      1/1     Running   0          20m   10.244.2.2   node2   <none>           <none>
frontend-787fd44db9-9n5zl   1/1     Running   0          20m   10.244.3.1   node3   <none>           <none>
user@master:~$ kubectl -n app exec cache-68d6b77c7f-h6cds -- curl backend-service
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:02 --:--:--     0^C
user@master:~$ kubectl -n app exec backend-68c75fdbf7-nfkn7 -- curl frontend-service
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:04 --:--:--     0^C
user@master:~$ kubectl -n app exec frontend-787fd44db9-9n5zl -- curl cache-service
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:03 --:--:--     0^C
user@master:~$
```