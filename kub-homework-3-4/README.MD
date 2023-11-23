# Домашнее задание к занятию «Обновление приложений»

### Цель задания

Выбрать и настроить стратегию обновления приложения.

### Чеклист готовности к домашнему заданию

1. Кластер K8s.

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Документация Updating a Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment).
2. [Статья про стратегии обновлений](https://habr.com/ru/companies/flant/articles/471620/).

-----

### Задание 1. Выбрать стратегию обновления приложения и описать ваш выбор

1. Имеется приложение, состоящее из нескольких реплик, которое требуется обновить.
2. Ресурсы, выделенные для приложения, ограничены, и нет возможности их увеличить.
3. Запас по ресурсам в менее загруженный момент времени составляет 20%.
4. Обновление мажорное, новые версии приложения не умеют работать со старыми.
5. Вам нужно объяснить свой выбор стратегии обновления приложения.

#### Решение
Стратегия обновления приложения будет выбрана recreate, т.к. у нас не понятно в какое время ресурс в 20% свободен и нет ограничения на простой сервиса.

### Задание 2. Обновить приложение

1. Создать deployment приложения с контейнерами nginx и multitool. Версию nginx взять 1.19. Количество реплик — 5.

deployment-3-4.yaml
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 5
  strategy:
    type: RollingUpdate
    rollingUpdate:  
      maxSurge: 5
      maxUnavailable: 1
  selector:
    matchLabels:  
      app: nginx
  template:
    metadata:  
      labels:  
        app: nginx
    spec:
      containers:
        - name: nginx-container
          image: nginx:1.19
          ports:  
            - containerPort: 80
        - name: multitool-container
          image: wbitt/network-multitool
          ports:  
            - containerPort: 8080
          env:
            - name: HTTP_PORT  
              value: "8080" 
```

```
user@master:~$ kubectl apply -f deployment-3-4.yaml 
deployment.apps/nginx-deployment configured
user@master:~$ kubectl get po
NAME                               READY   STATUS    RESTARTS   AGE
nginx-deployment-6485ffcb5-d7q9x   2/2     Running   0          8m46s
nginx-deployment-6485ffcb5-jkhzh   2/2     Running   0          8m46s
nginx-deployment-6485ffcb5-t297k   2/2     Running   0          8m46s
nginx-deployment-6485ffcb5-vvmqt   2/2     Running   0          8m46s
nginx-deployment-6485ffcb5-zlnb2   2/2     Running   0          8m46s
user@master:~$ kubectl describe deployment nginx-deployment | grep 'Image:'
    Image:        nginx:1.19
    Image:      wbitt/network-multitool
user@master:~$
```

2. Обновить версию nginx в приложении до версии 1.20, сократив время обновления до минимума. Приложение должно быть доступно.
```
user@master:~$ kubectl apply -f deployment-3-4.yaml 
deployment.apps/nginx-deployment configured
user@master:~$ kubectl get po
NAME                               READY   STATUS              RESTARTS   AGE
nginx-deployment-6485ffcb5-d7q9x   2/2     Running             0          14m
nginx-deployment-6485ffcb5-t297k   2/2     Running             0          14m
nginx-deployment-6485ffcb5-vvmqt   2/2     Running             0          14m
nginx-deployment-6485ffcb5-zlnb2   2/2     Running             0          14m
nginx-deployment-669dccd65-5qwjb   0/2     ContainerCreating   0          3s
nginx-deployment-669dccd65-6tmln   0/2     ContainerCreating   0          3s
nginx-deployment-669dccd65-fb9nb   0/2     ContainerCreating   0          3s
nginx-deployment-669dccd65-gpk6t   0/2     ContainerCreating   0          3s
nginx-deployment-669dccd65-wxw2v   0/2     ContainerCreating   0          3s
user@master:~$ kubectl get po
NAME                               READY   STATUS    RESTARTS   AGE
nginx-deployment-669dccd65-5qwjb   2/2     Running   0          25s
nginx-deployment-669dccd65-6tmln   2/2     Running   0          25s
nginx-deployment-669dccd65-fb9nb   2/2     Running   0          25s
nginx-deployment-669dccd65-gpk6t   2/2     Running   0          25s
nginx-deployment-669dccd65-wxw2v   2/2     Running   0          25s
user@master:~$ kubectl describe deployment nginx-deployment | grep 'Image:'
    Image:        nginx:1.20
    Image:      wbitt/network-multitool
user@master:~$
```
3. Попытаться обновить nginx до версии 1.28, приложение должно оставаться доступным.
```
user@master:~$ kubectl apply -f deployment-3-4.yaml 
deployment.apps/nginx-deployment configured
user@master:~$ kubectl get po
NAME                                READY   STATUS              RESTARTS   AGE
nginx-deployment-669dccd65-5qwjb    2/2     Running             0          112s
nginx-deployment-669dccd65-6tmln    2/2     Running             0          112s
nginx-deployment-669dccd65-fb9nb    2/2     Running             0          112s
nginx-deployment-669dccd65-gpk6t    2/2     Running             0          112s
nginx-deployment-688c49c8cc-b9q4g   0/2     ContainerCreating   0          4s
nginx-deployment-688c49c8cc-gzwfv   0/2     ContainerCreating   0          4s
nginx-deployment-688c49c8cc-lxr2v   0/2     ContainerCreating   0          4s
nginx-deployment-688c49c8cc-ndt7r   0/2     ContainerCreating   0          4s
nginx-deployment-688c49c8cc-xx57s   1/2     ErrImagePull        0          4s
user@master:~$ kubectl get po
NAME                                READY   STATUS             RESTARTS   AGE
nginx-deployment-669dccd65-5qwjb    2/2     Running            0          2m
nginx-deployment-669dccd65-6tmln    2/2     Running            0          2m
nginx-deployment-669dccd65-fb9nb    2/2     Running            0          2m
nginx-deployment-669dccd65-gpk6t    2/2     Running            0          2m
nginx-deployment-688c49c8cc-b9q4g   1/2     ImagePullBackOff   0          12s
nginx-deployment-688c49c8cc-gzwfv   1/2     ImagePullBackOff   0          12s
nginx-deployment-688c49c8cc-lxr2v   1/2     ImagePullBackOff   0          12s
nginx-deployment-688c49c8cc-ndt7r   1/2     ImagePullBackOff   0          12s
nginx-deployment-688c49c8cc-xx57s   1/2     ImagePullBackOff   0          12s
user@master:~$
```
4. Откатиться после неудачного обновления.
```
user@master:~$ kubectl rollout undo deployment/nginx-deployment
deployment.apps/nginx-deployment rolled back
user@master:~$ kubectl get po
NAME                               READY   STATUS    RESTARTS   AGE
nginx-deployment-669dccd65-5qwjb   2/2     Running   0          6m26s
nginx-deployment-669dccd65-6tmln   2/2     Running   0          6m26s
nginx-deployment-669dccd65-fb9nb   2/2     Running   0          6m26s
nginx-deployment-669dccd65-gpk6t   2/2     Running   0          6m26s
nginx-deployment-669dccd65-vxjlv   2/2     Running   0          5s
user@master:~$ kubectl describe deployment nginx-deployment | grep 'Image:'
    Image:        nginx:1.20
    Image:      wbitt/network-multitool
user@master:~$
```

## Дополнительные задания — со звёздочкой*

Задания дополнительные, необязательные к выполнению, они не повлияют на получение зачёта по домашнему заданию. **Но мы настоятельно рекомендуем вам выполнять все задания со звёздочкой.** Это поможет лучше разобраться в материале.   

### Задание 3*. Создать Canary deployment

1. Создать два deployment'а приложения nginx.
2. При помощи разных ConfigMap сделать две версии приложения — веб-страницы.
3. С помощью ingress создать канареечный деплоймент, чтобы можно было часть трафика перебросить на разные версии приложения.

### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.