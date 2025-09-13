# DevOpsCICD

## branch lesson-3

Створіть Bash-скрипт для автоматичного встановлення Docker, Docker Compose, Python і Django, а також запуште його в GitHub у гілку lesson-3.

## branch lesson-4

1. Створіть власний проєкт, що включає:

-   Django — для вебзастосунку.
-   PostgreSQL — для збереження даних.
-   Nginx — для обробки запитів.

2. Використайте Docker і Docker Compose для контейнеризації всіх сервісів.

3. Запуште проєкт у свій репозиторій на GitHub для перевірки.

## branch lesson-5

Вам потрібно налаштувати:

1. Синхронізацію стейт-файлів у S3 з використанням DynamoDB для блокування.

2. Мережеву інфраструктуру (VPC) з публічними та приватними підмережами.

3. ECR (Elastic Container Registry) для зберігання Docker-образів.

Структура проєкту

lesson-5/
│
├── main.tf # Головний файл для підключення модулів
├── backend.tf # Налаштування бекенду для стейтів (S3 + DynamoDB)
├── outputs.tf # Загальне виведення ресурсів
│
├── modules/ # Каталог з усіма модулями
│ │
│ ├── s3-backend/ # Модуль для S3 та DynamoDB
│ │ ├── s3.tf # Створення S3-бакета
│ │ ├── dynamodb.tf # Створення DynamoDB
│ │ ├── variables.tf # Змінні для S3
│ │ └── outputs.tf # Виведення інформації про S3 та DynamoDB
│ │
│ ├── vpc/ # Модуль для VPC
│ │ ├── vpc.tf # Створення VPC, підмереж, Internet Gateway
│ │ ├── routes.tf # Налаштування маршрутизації
│ │ ├── variables.tf # Змінні для VPC
│ │ └── outputs.tf # Виведення інформації про VPC
│ │
│ └── ecr/ # Модуль для ECR
│ ├── ecr.tf # Створення ECR репозиторію
│ ├── variables.tf # Змінні для ECR
│ └── outputs.tf # Виведення URL репозиторію ECR
│
└── README.md # Документація проєкту
