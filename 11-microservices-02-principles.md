
# Домашнее задание к занятию «Микросервисы: принципы»

Вы работаете в крупной компании, которая строит систему на основе микросервисной архитектуры.
Вам как DevOps-специалисту необходимо выдвинуть предложение по организации инфраструктуры для разработки и эксплуатации.

## Задача 1: API Gateway 

Предложите решение для обеспечения реализации API Gateway. Составьте сравнительную таблицу возможностей различных программных решений. На основе таблицы сделайте выбор решения.

Решение должно соответствовать следующим требованиям:
- маршрутизация запросов к нужному сервису на основе конфигурации,
- возможность проверки аутентификационной информации в запросах,
- обеспечение терминации HTTPS.

| Решение | Маршрутизация запросов | Проверка аутентификации | Терминация HTTPS |
|---------|-----------------------|--------------------------|------------------|
| Apigee  | Да                    | Да                       | Да               |
| Tyk     | Да                    | Да                       | Да               |
| Kong    | Да                    | Да                       | Да               |
| Nginx   | Да                    | Да                       | Да               |


Все решения удовлетворяют критериям в задаче, но выбор должен основываться на доп параметрах, таких как: стоимость решения, наличие поддержки, удобства использования в уже сущ. инфраструктуре.
Пэтому мой выбор был бы  nginx, т.к. он бесплатен, хорошо документирован, имеет активное сообщество пользователей, есть платные планы поддержки.
## Задача 2: Брокер сообщений

Составьте таблицу возможностей различных брокеров сообщений. На основе таблицы сделайте обоснованный выбор решения.

Решение должно соответствовать следующим требованиям:
- поддержка кластеризации для обеспечения надёжности,
- хранение сообщений на диске в процессе доставки,
- высокая скорость работы,
- поддержка различных форматов сообщений,
- разделение прав доступа к различным потокам сообщений,
- простота эксплуатации.

Обоснуйте свой выбор.

| Брокер сообщений | Поддержка кластеризации | Хранение сообщений на диске | Производительность | Поддержка различных форматов сообщений | Разделение прав доступа | Простота эксплуатации |
| --- | --- | --- | --- | --- | --- | --- |
| Apache Kafka | Да | Да | Высокая | Да | Да | Сложно |
| RabbitMQ | Да | Да | Средняя | Да | Да | Просто |
| ActiveMQ | Да | Да | Средняя | Да | Да | Просто |
| Redis | Да | Нет | Высокая | Да | Да | Просто |

На основании таблицы выбрал бы Apache Kafka, в том числе как и наиболее используемое решение и имеет большой набор инструментов и библиотек.