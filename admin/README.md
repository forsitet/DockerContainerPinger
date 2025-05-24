# Admin Service

Сервис аутентификации и управления пользователями, написанный на Django.

## Описание

Admin Service предоставляет API для управления пользователями и аутентификации в системе мониторинга Docker-контейнеров. Сервис реализует следующие функции:

- Регистрация и аутентификация пользователей
- Управление пользовательскими данными
- JWT-токены для авторизации
- Swagger документация API

## Технологии

- Python 3.8+
- Django 5.1
- Django REST Framework
- PostgreSQL
- JWT для аутентификации
- Swagger для документации API

## Структура проекта

```
admin/
├── Auth/           # Приложение аутентификации
├── users/          # Приложение управления пользователями
├── tests/          # Тесты
├── manage.py       # Скрипт управления Django
├── entrypoint.sh   # Скрипт запуска
├── Dockerfile      # Конфигурация Docker
└── requirements.txt # Зависимости Python
```

## Установка и запуск

1. Убедитесь, что у вас установлен Python 3.8 или выше
2. Создайте и активируйте виртуальное окружение:

```bash
python -m venv admin_env
source admin_env/bin/activate  # для Linux/Mac
# или
admin_env\Scripts\activate  # для Windows
```

3. Установите зависимости:

```bash
pip install -r requirements.txt
```

4. Примените миграции:

```bash
python manage.py migrate
```

5. Запустите сервис:

```bash
python manage.py runserver 0.0.0.0:8095
```

## API Документация

Swagger документация доступна по адресу: `http://localhost:8095/swagger/`

## Разработка

### Запуск тестов

```bash
pytest
```

### Сборка Docker-образа

```bash
docker build -t app_auth .
```

## Зависимости

Основные зависимости:

- Django==5.1.7 - веб-фреймворк
- djangorestframework==3.16.0 - REST API
- drf-yasg==1.21.10 - Swagger документация
- psycopg2-binary==2.9 - драйвер PostgreSQL
- pytest>=7.0.0 - тестирование

## Требования к системе

- Python 3.8 или выше
- PostgreSQL
- Доступ к порту 8095
