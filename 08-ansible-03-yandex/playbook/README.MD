# Описание playbook site.yml

## Основное

Playbook выполняет установку и первоначальную конфигурацию:
1. Clickhouse
2. Vector
3. Lighthouse

Установка выполняется на разные хосты, перечисленные в [prod.yml](inventory/prod.yml)

Требования к хостам: RPM-based Linux distribution

## Установка Clickhouse

в файле [group_vars/clickhouse/vars.yml](group_vars/clickhouse/vars.yml) задается:
1. версия
2. пакеты для установки

Описание tasks:
* Get clickhouse distrib      - скачивание дистрибутива в текущую директорию
* Install clickhouse packages - установка пакетов
* Create database             - создание БД
* хэндлер Start clickhouse service используется для принудителного запуска сервиса clickhouse

## Установка Vector

в файле [group_vars/vector/vars.yml](group_vars/vector/vars.yml) задается:
1. версия (vector_version)
2. директория установки (vector_path)
3. директория хранения данных (vector_data_path)
4. конфигурационный файл (vector_config)

Описание tasks:
* Create directory - создание директории установки
* Get distr - скачивание дистрибутива
* Unarchive files - распаковка файлов
* Create a symlink - создание ссылки на директорию установки
* Create init file - создание init файла из [шаблона](templates/vector.service.j2)
* creating directory for vector data - создание директории для данных
* Creating config for Vector - создание config файла из [шаблона](templates/vector.toml.j2)
* Creating service for vector - разрешение и запуск сервиса vector

## Установка Lighthouse

в файле [group_vars/lighthouse/vars.yml](group_vars/lighthouse/vars.yml) задается:

nginx:

1. Путь для файла репозитория.
2. Путь ко корневой директории.
3. Путь до конфига по умолчанию.

lighthouse:

1. Директорию для дистрибутива.
2. Путь для архива с дистрибутивом.
3. ссылка на дистрибутив.

Описание tasks:

lighthouse:
* Create directory lighthouse - создание директории
* Get lighthouse distrib - скачивание дистрибутива
* Unarchive lighthouse - распаковка файлов
* Apply nginx config - применение конфига и рестарт nginx

nginx:

* Add repo nginx - добавление репозитория
* Install nginx - установка
* Configuring service nginx - создание сервиса







