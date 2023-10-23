# Описание playbook site.yml

## Основное

Playbook выполняет установку и первоначальную конфигурацию:
1. Clickhouse
2. Vector

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






