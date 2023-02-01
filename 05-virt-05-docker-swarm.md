

## Задача 1

Дайте письменые ответы на следующие вопросы:

- В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
- Какой алгоритм выбора лидера используется в Docker Swarm кластере?
- Что такое Overlay Network?

## Задача 2

Создать ваш первый Docker Swarm кластер в Яндекс.Облаке

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker node ls
```
```shell
alex@DESKTOP-SBHASL4:~/homework/05-virt-05-docker-swarm/src/terraform$ ssh centos@158.160.59.125
[centos@node01 ~]$ sudo docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
6sjguie5eh9fj59b3k0pzw94d *   node01.netology.yc   Ready     Active         Leader           20.10.23
tlpqqg2uzs5gaapbuo6bamkat     node02.netology.yc   Ready     Active         Reachable        20.10.23
mdewqsxg2hgkhjq2cevf326tx     node03.netology.yc   Ready     Active         Reachable        20.10.23
4q7gs1tyzxulyax0okg7haffw     node04.netology.yc   Ready     Active                          20.10.23
ll1jmzol3x1x98o3xl9v8fosw     node05.netology.yc   Ready     Active                          20.10.23
y2p0m25u6vxfmgow0kl6igmwn     node06.netology.yc   Ready     Active                          20.10.23
```
## Задача 3

Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker service ls
```
```shell
[centos@node01 ~]$ sudo docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
deill5i5l4uz   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0
ws2100bjcxo7   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
45b3ax2sbmlk   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest
szvv5ai4ga5c   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest
ufryba4a78nm   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4
uawmx9og7fc5   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0
jxligko9ijxf   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0
tdlbxga9ajmq   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0
```
## Задача 4 (*)

Выполнить на лидере Docker Swarm кластера команду (указанную ниже) и дать письменное описание её функционала, что она делает и зачем она нужна:
```
# см.документацию: https://docs.docker.com/engine/swarm/swarm_manager_locking/
docker swarm update --autolock=true
```

