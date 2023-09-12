# Домашнее задание к занятию «Введение в микросервисы»

## Задача 1: Интернет Магазин

Руководство крупного интернет-магазина, у которого постоянно растёт пользовательская база и количество заказов, рассматривает возможность переделки своей внутренней   ИТ-системы на основе микросервисов. 

Вас пригласили в качестве консультанта для оценки целесообразности перехода на микросервисную архитектуру. 

Опишите, какие выгоды может получить компания от перехода на микросервисную архитектуру и какие проблемы нужно решить в первую очередь.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
## Преимущества при переходе на микросервисы:
1. Масштабируемость - можно масштабировать отдельные сервисы независмо друг от друга, тем самым более экономно расходовать ресурсы.
2. Надежность - отказ одного из сервисов не приведет к отказу системы в целом.
3. Разделение на команды по компетенциям и зонам ответственности по каждому сервису
4. Ускорение процесса разработки, т.к. над каждым отдельным сервисом трудится своя команда независимо и доставка новых функций или исправлений более оперативная.
5. Быстрое тестирование и быстырые циклы обновления и повторного развертывания
6. Возможность использовать разные технологии, в том числе можно переписать микросервис на другом языке программирования или с использованием другого стека технологий.

## Проблемы, которые нужно решить:
1. Организация команд и распределение зон ответственности по сервисам для работы автономно друг от друга.
2. Разделение моноллита на микросервисы в зависимости от функционала
3. Настройка логирования, мониторинга и документирования каждого микросервиса.
4. Переходный период - возможная эксплуатация сразу двух систем.
5. Необходима стандартизация api, обратная и прямая совместимость.
6. Необходима настройка версионирования микросервисов и хранения артефактов.