# mlflow-deployment: Автоматизация MLOps на Yandex Cloud

## Структура проекта

```

mlflow-deployment/
├── docker-compose.yml       \# Конфигурация Docker Compose для MLflow, PostgreSQL и сервировки модели
├── Dockerfile.mlflow        \# Dockerfile для сервера MLflow
├── Dockerfile.model         \# Dockerfile для сервировки модели
├── scripts/
│   └── train_model.py       \# Скрипт для обучения и логирования модели
├── .github/
│   └── workflows/
│       └── deploy.yml       \# CI/CD-пайплайн для GitHub Actions
├── .env                     \# Локальные переменные окружения (не коммитится)

```

---

## Требования

- Docker и Docker Compose
- Аккаунт Yandex Cloud с:
  - Настроенным Container Registry
  - Разрешениями на создание вычислительных инстансов
  - Ролями: `storage.editor`, `compute.admin`, `container-registry.admin`
- S3-бакет в Yandex Cloud (например, `mlflow-artifact-bucket`) с ключами доступа
- Репозиторий GitHub с настроенными секретами

---

## Установка

1. **Клонируйте репозиторий:**
```

git clone <URL_вашего_репозитория>
cd mlflow-deployment

```

2. **Создайте файл `.env`:**
```

echo "AWS_ACCESS_KEY_ID=your_access_key" >> .env
echo "AWS_SECRET_ACCESS_KEY=your_secret_key" >> .env

```

3. **Настройте секреты GitHub:**
В настройках репозитория (Settings > Secrets and variables > Actions) добавьте:
- `YC_TOKEN`: OAuth-токен Yandex Cloud
- `YC_CLOUD_ID`: ID облака
- `YC_FOLDER_ID`: ID папки
- `YC_REGISTRY_USER`: Пользователь Container Registry
- `YC_REGISTRY_PASSWORD`: Пароль Container Registry
- `YC_REGISTRY_ID`: ID Container Registry
- `AWS_ACCESS_KEY_ID`: Ключ доступа S3
- `AWS_SECRET_ACCESS_KEY`: Секретный ключ S3

4. **Обучите модель:**
- Запустите сервисы:
  ```
  docker-compose up --build
  ```
- Выполните скрипт обучения:
  ```
  docker-compose exec mlflow python scripts/train_model.py
  ```
- Скопируйте Run ID из вывода и замените `placeholder_run_id` в `Dockerfile.model` на актуальный Run ID.

---

## Использование

### Локальное тестирование

- Запустите сервисы:
```

docker-compose up --build

```
- Откройте интерфейс MLflow: [http://localhost:5000](http://localhost:5000)
- Протестируйте endpoint модели:
```

curl -X POST -H "Content-Type: application/json" \
-d '{"columns": ["sepal_length", "sepal_width", "petal_length", "petal_width"], "data": [[5.1, 3.5, 1.4, 0.2]]}' \
http://localhost:8000/invocations

```

### Развертывание через CI/CD

- Зафиксируйте изменения и отправьте в ветку `main`:
```

git add .
git commit -m "Развертывание MLflow"
git push origin main

```
- Пайплайн GitHub Actions (`deploy.yml`) выполнит:
- Сборку Docker-образов (`mlflow` и `model`)
- Загрузку образов в Yandex Container Registry
- Развертывание сервисов на вычислительной инстансе Yandex Cloud с использованием Docker Compose

---

## Почему MLflow?

MLflow играет ключевую роль в этом MLOps-процессе:

- **Отслеживание экспериментов:**  
Скрипт `train_model.py` логирует параметры, метрики и модели (например, модель Iris) в PostgreSQL, обеспечивая централизованное хранение и воспроизводимость экспериментов.

- **Хранение артефактов:**  
Yandex Cloud S3 используется для масштабируемого и безопасного хранения артефактов моделей, таких как сериализованные файлы scikit-learn.

- **Сервировка моделей:**  
Контейнер `model-serving` разворачивает модель как REST API с помощью MLflow, упрощая интеграцию с внешними приложениями.

- **Интеграция с CI/CD:**  
Автоматизация через GitHub Actions минимизирует ручной труд, обеспечивая консистентность окружений и быстрое развертывание обновлений.

- **Воспроизводимость и совместная работа:**  
Централизованное хранение метаданных (PostgreSQL) и артефактов (S3) позволяет командам легко обмениваться результатами и возвращаться к предыдущим версиям моделей.

---

## Соответствие требованиям 

- **Docker Compose:** Используется для управления сервисами MLflow, PostgreSQL и сервировки модели.
- **Контейнеризация модели:** Модель развертывается в отдельном контейнере через `Dockerfile.model`.
- **CI/CD:** Пайплайн GitHub Actions автоматизирует сборку и развертывание.
```

