# Frontend (Flutter)

Этот фронтенд — веб-интерфейс для системы мониторинга Docker-контейнеров. Реализован на Flutter с поддержкой BLoC, Dio, go_router, интернационализации и чистой архитектуры. Интерфейс получает информацию о контейнерах через REST API: IP, пинг, дата последнего успешного отклика и пр.

---

## Стек технологий

| Технология                       | Назначение                    |
| -------------------------------- | ----------------------------- |
| **Flutter**                      | Кроссплатформенная разработка |
| **Dio**                          | Расширенный HTTP-клиент       |
| **BLoC / flutter_bloc**          | Управление состоянием         |
| **go_router**                    | Маршрутизация                 |
| **intl / flutter_localizations** | Интернационализация           |
| **json_serializable**            | Генерация моделей из JSON     |
| **equatable**                    | Сравнение объектов в BLoC     |

---

## Структура проекта

```
lib/
├── generated/            # Сгенерированные файлы локализации
├── l10n/                 # Файлы локализаций (.arb)
├── main.dart             # Точка входа в приложение
└── src/
    ├── core/
    │   ├── constants/        # Константы API и сети
    │   ├── presentation/
    │   │   ├── bloc/         # Общие BLoC-модули (авторизация, темы)
    │   │   └── widgets/      # Общие виджеты UI
    │   ├── router/           # Навигация и маршрутизация
    │   └── styles/           # Тема и стили
    └── features/
        ├── authorization/    # Модуль авторизации
        │   ├── data/         # Репозитории и модели
        │   ├── domain/       # Сущности и абстракции
        │   └── presentation/ # Интерфейс логина
        └── container_list/   # Список контейнеров
            ├── data/         # Сетевой слой и модели
            ├── domain/       # UseCase и сущности
            └── presentation/ # Страницы и BLoC управления контейнерами
```

---

## Запуск проекта

```bash
flutter pub get
flutter run -d chrome
```

> Приложение адаптировано под Web. Поддержка других платформ может быть ограничена.

---

## Локализация

Файлы локализации находятся в `l10n/`, сгенерированные классы — в `generated/`.

Поддерживаемые языки:

- 🇺🇸 English
- 🇷🇺 Русский

Пример использования:

```dart
AppLocalizations.of(context).auth_title;
```

---

## REST API

Все взаимодействия идут через `Dio` и обёрнуты в репозитории.

Пример:

```dart
final containers = await containerRepository.getContainers();
```

Репозитории находятся в `features/container_list/data/repositories`.

---

## BLoC архитектура

Каждая фича имеет собственный BLoC-модуль. Пример: `ContainerListBloc`.

```dart
BlocProvider(
  create: (_) => ContainerListBloc(containerRepository)..add(FetchContainers()),
  child: ContainerListPage(),
)
```

---

## Модели и сериализация

Модели используют `json_serializable` и `equatable`. Пример: `container_model.dart`.

Генерация:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Навигация

Навигация построена на `go_router`. Основной конфиг — `src/core/router/app_router.dart`.

```dart
GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ContainerListPage(),
    ),
  ],
);
```

---

## Тестирование

BLoC-модули покрываются unit-тестами. Поддержка моков репозиториев.

---

## Вклад

Сделайте `fork`, создайте `branch`, создайте `PR`. Используйте форматтер:

```bash
flutter format .
```
