# Lesson DB Module: Універсальний RDS модуль з повним CI/CD

## Опис проекту

Цей проект реалізує повний CI/CD-процес з універсальним RDS модулем, який підтримує:

-   **Jenkins** - для автоматичної збірки Docker-образів
-   **Helm** - для управління Kubernetes додатками
-   **Terraform** - для інфраструктури як код
-   **Argo CD** - для GitOps автоматизації розгортання
-   **RDS** - універсальний модуль для баз даних (PostgreSQL/MySQL, RDS/Aurora)

## Структура проекту

```
final-project/
├── main.tf                          # Головний файл Terraform
├── backend.tf                       # Налаштування S3 backend
├── outputs.tf                       # Виводи ресурсів
├── variables.tf                     # Змінні Terraform
├── terraform.tfvars.example         # Приклад конфігурації
├── modules/
│   ├── s3-backend/                  # S3 + DynamoDB модуль
│   ├── vpc/                         # VPC модуль
│   ├── ecr/                         # ECR модуль
│   ├── eks/                         # EKS модуль
│   ├── rds/                         # RDS модуль (головний фокус)
│   ├── jenkins/                     # Jenkins модуль
│   └── argo_cd/                     # Argo CD модуль
└── charts/
    └── django-app/                  # Helm chart для Django
```

### Необхідні AWS політики:

-   AmazonS3FullAccess
-   AmazonDynamoDBFullAccess
-   AmazonEC2FullAccess
-   AmazonEC2ContainerRegistryFullAccess
-   AmazonEKSFullAccess
-   AmazonRDSFullAccess
-   IAMFullAccess

## 🚀 Швидкий старт

### 1. Підготовка

```bash
# Клонуйте репозиторій
git clone <repository-url>
cd final-project

# Створіть terraform.tfvars файл
cp terraform.tfvars.example terraform.tfvars
```

### 2. Налаштування

Відредагуйте `terraform.tfvars` файл:

```hcl
# Основні налаштування
use_aurora = false  # true для Aurora, false для звичайного RDS
rds_engine = "postgres"  # postgres або mysql
rds_instance_class = "db.t3.micro"
rds_database_name = "mydb"
rds_master_username = "admin"
rds_master_password = ""  # Залиште порожнім для автогенерації
```

### 3. Розгортання

```bash
# Ініціалізація Terraform
terraform init

# Планування розгортання
terraform plan

# Застосування змін
terraform apply
```

## RDS Модуль

### Функціонал RDS модуля

Модуль `modules/rds/` реалізує універсальний підхід до створення баз даних:

#### 1. Підтримка двох типів баз даних:

-   **Звичайний RDS** (`use_aurora = false`) - створює `aws_db_instance`
-   **Aurora кластер** (`use_aurora = true`) - створює `aws_rds_cluster` + інстанси

#### 2. Підтримка двигунів:

-   **PostgreSQL** - з автоматичним вибором версії
-   **MySQL** - з автоматичним вибором версії

#### 3. Автоматичне створення ресурсів:

-   **DB Subnet Group** - для ізоляції в приватних підмережах
-   **Security Group** - з налаштованими правилами доступу
-   **Parameter Group** - з базовими параметрами (max_connections, log_statement, work_mem)

#### 4. Aurora Serverless підтримка:

-   Автопауза для економії коштів
-   Масштабування за потребою
-   Налаштування min/max capacity

## CI/CD Процес

### 1. Jenkins Pipeline

Jenkins автоматично:

-   Збирає Docker образ з Django додатком
-   Пушить образ в Amazon ECR
-   Оновлює тег в Helm chart
-   Пушить зміни в GitHub

### 2. Argo CD Application

Argo CD:

-   Відстежує зміни в GitHub репозиторії
-   Автоматично синхронізує Helm chart
-   Розгортає оновлення в EKS кластер

### 3. RDS Integration

RDS модуль інтегрується з CI/CD:

-   База даних створюється автоматично при розгортанні
-   Підтримує як звичайні RDS, так і Aurora кластери
-   Автоматично налаштовує безпеку та мережу

## Доступ до сервісів

### Доступ до Jenkins

1. Отримайте LoadBalancer IP:

```bash
kubectl get svc -n jenkins jenkins
```

2. Отримайте пароль адміністратора:

```bash
kubectl -n jenkins get secret jenkins -o jsonpath='{.data.jenkins-admin-password}'
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("received_password"))
```

3. Відкрийте Jenkins UI: `http://<LOADBALANCER_IP>`
4. Логін: `admin`

### Доступ до Argo CD

1. Отримайте LoadBalancer IP:

```bash
kubectl get svc -n argocd
```

2. Отримайте пароль адміністратора:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}'
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("received_password"))
```

3. Відкрийте Argo CD UI: `https://<LOADBALANCER_IP>`
4. Логін: `admin`

### Доступ до RDS

1. Отримайте endpoint бази даних:

```bash
terraform output rds_instance_endpoint
# або для Aurora
terraform output aurora_cluster_endpoint
```

2. Отримайте пароль:

```bash
terraform output -raw rds_connection_string
```

## 📋 Використання RDS модуля

### Базове використання

```hcl
module "rds" {
  source = "./modules/rds"

  # Основна конфігурація
  use_aurora = false
  engine     = "postgres"
  instance_class = "db.t3.micro"

  # База даних
  database_name   = "mydb"
  master_username = "admin"
  master_password = "secure-password"

  # Мережа
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Безпека
  allowed_cidr_blocks = ["10.0.0.0/16"]

  tags = {
    Environment = "production"
  }
}
```

### Aurora кластер

```hcl
module "rds" {
  source = "./modules/rds"

  # Aurora конфігурація
  use_aurora = true
  engine     = "postgres"
  instance_class = "db.r5.large"

  # Aurora специфічні налаштування
  aurora_cluster_instances = 2
  aurora_auto_pause = false

  # Решта конфігурації...
}
```

### Aurora Serverless

```hcl
module "rds" {
  source = "./modules/rds"

  # Aurora Serverless
  use_aurora = true
  engine     = "postgres"

  # Serverless налаштування
  aurora_auto_pause = true
  aurora_seconds_until_auto_pause = 300
  aurora_max_capacity = 16
  aurora_min_capacity = 2

  # Решта конфігурації...
}
```

## 🔧 Змінні модуля RDS

### Основні змінні

| Змінна               | Тип      | За замовчуванням | Опис                                              |
| -------------------- | -------- | ---------------- | ------------------------------------------------- |
| `use_aurora`         | `bool`   | `false`          | Створити Aurora кластер замість звичайного RDS    |
| `rds_engine`         | `string` | `"postgres"`     | Тип бази даних (postgres, mysql)                  |
| `rds_engine_version` | `string` | `""`             | Версія двигуна (порожня для автоматичного вибору) |
| `rds_instance_class` | `string` | `"db.t3.micro"`  | Клас інстансу                                     |
| `rds_multi_az`       | `bool`   | `false`          | Увімкнути Multi-AZ розгортання                    |

### Конфігурація бази даних

| Змінна                | Тип      | За замовчуванням | Опис                                       |
| --------------------- | -------- | ---------------- | ------------------------------------------ |
| `rds_database_name`   | `string` | `"mydb"`         | Назва бази даних                           |
| `rds_master_username` | `string` | `"admin"`        | Мастер користувач                          |
| `rds_master_password` | `string` | `""`             | Мастер пароль (порожній для автогенерації) |

### Конфігурація сховища

| Змінна                      | Тип      | За замовчуванням | Опис                             |
| --------------------------- | -------- | ---------------- | -------------------------------- |
| `rds_allocated_storage`     | `number` | `20`             | Розмір сховища (GB)              |
| `rds_max_allocated_storage` | `number` | `100`            | Максимальний розмір сховища (GB) |
| `rds_storage_type`          | `string` | `"gp2"`          | Тип сховища                      |
| `rds_storage_encrypted`     | `bool`   | `true`           | Шифрування сховища               |

### Мережева конфігурація

| Змінна                        | Тип            | За замовчуванням | Опис                      |
| ----------------------------- | -------------- | ---------------- | ------------------------- |
| `rds_allowed_cidr_blocks`     | `list(string)` | `[]`             | Дозволені CIDR блоки      |
| `rds_allowed_security_groups` | `list(string)` | `[]`             | Дозволені security groups |

### Aurora специфічні змінні

| Змінна                            | Тип      | За замовчуванням | Опис                               |
| --------------------------------- | -------- | ---------------- | ---------------------------------- |
| `aurora_cluster_instances`        | `number` | `1`              | Кількість інстансів в кластері     |
| `aurora_auto_pause`               | `bool`   | `false`          | Увімкнути автопаузу для Serverless |
| `aurora_seconds_until_auto_pause` | `number` | `300`            | Секунди до автопаузи               |
| `aurora_max_capacity`             | `number` | `16`             | Максимальна потужність Serverless  |
| `aurora_min_capacity`             | `number` | `2`              | Мінімальна потужність Serverless   |

## 📤 Outputs модуля RDS

### Загальні outputs

| Output                | Опис                       |
| --------------------- | -------------------------- |
| `rds_database_name`   | Назва бази даних           |
| `rds_master_username` | Мастер користувач          |
| `rds_port`            | Порт бази даних            |
| `rds_engine`          | Двигун бази даних          |
| `rds_engine_version`  | Версія двигуна             |
| `rds_use_aurora`      | Чи використовується Aurora |

### RDS Instance outputs (коли use_aurora = false)

| Output                  | Опис                  |
| ----------------------- | --------------------- |
| `rds_instance_id`       | ID RDS інстансу       |
| `rds_instance_endpoint` | Endpoint RDS інстансу |
| `rds_instance_address`  | Адреса RDS інстансу   |

### Aurora Cluster outputs (коли use_aurora = true)

| Output                           | Опис                            |
| -------------------------------- | ------------------------------- |
| `aurora_cluster_id`              | ID Aurora кластера              |
| `aurora_cluster_endpoint`        | Endpoint Aurora кластера        |
| `aurora_cluster_reader_endpoint` | Reader endpoint Aurora кластера |

### Безпека та мережа

| Output                  | Опис                          |
| ----------------------- | ----------------------------- |
| `rds_security_group_id` | ID security group             |
| `rds_connection_string` | Рядок підключення (sensitive) |

## Налаштування параметрів

Модуль автоматично створює parameter groups з базовими налаштуваннями:

### PostgreSQL параметри

-   `max_connections` - Максимальна кількість з'єднань
-   `log_statement` - Рівень логування SQL запитів
-   `work_mem` - Робоча пам'ять для операцій (MB)

### MySQL параметри

-   `max_connections` - Максимальна кількість з'єднань

## Безпека

Модуль автоматично створює:

-   Security Group з налаштованими правилами доступу
-   DB Subnet Group для ізоляції в приватних підмережах
-   Шифрування сховища (за замовчуванням увімкнено)
-   Parameter Groups з безпечними налаштуваннями

## Вартість

### RDS Instance (db.t3.micro)

-   ~$15-20/місяць за базову конфігурацію

### Aurora Cluster (db.r5.large)

-   ~$200-300/місяць за кластер з 2 інстансами

### Aurora Serverless

-   ~$10-50/місяць залежно від використання

## Команди для перевірки

### Перевірка EKS кластера

```bash
# Оновлення kubeconfig
aws eks update-kubeconfig --region eu-central-1 --name final-project-eks

# Перевірка нод
kubectl get nodes

# Перевірка подів
kubectl get pods -A
```

### Перевірка Jenkins

```bash
# Статус Jenkins
kubectl get pods -n jenkins

# Логи Jenkins
kubectl logs -n jenkins -l app.kubernetes.io/name=jenkins
```

### Перевірка Argo CD

```bash
# Статус Argo CD
kubectl get pods -n argocd

# Список додатків
kubectl get applications -n argocd
```

### Перевірка RDS

```bash
# Список RDS інстансів
aws rds describe-db-instances --query 'DBInstances[].{ID:DBInstanceIdentifier,Engine:Engine,Status:DBInstanceStatus,Endpoint:Endpoint.Address}' --output table

# Список Aurora кластерів
aws rds describe-db-clusters --query 'DBClusters[].{ID:DBClusterIdentifier,Engine:Engine,Status:Status,Endpoint:Endpoint}' --output table

# Перевірка підключення до бази
psql -h <endpoint> -U admin -d mydb
# або для MySQL
mysql -h <endpoint> -u admin -p mydb
```

### Перевірка Django додатку

```bash
# Статус додатку
kubectl get pods -l app=django-app

# Сервіси
kubectl get svc -l app=django-app

# Логи додатку
kubectl logs -l app=django-app
```

## 🧹 Очищення ресурсів

```bash
# Видалення Helm релізів
helm uninstall django -n default
helm uninstall jenkins -n jenkins
helm uninstall argo-cd -n argocd

# Видалення інфраструктури
terraform destroy
```

## Troubleshooting

### Jenkins не може підключитися до GitHub

1. Перевірте GitHub PAT в credentials
2. Перевірте IAM роль для Jenkins
3. Перевірте логи Jenkins

### Argo CD не синхронізує зміни

1. Перевірте статус Application в UI
2. Перевірте доступ до GitHub репозиторію
3. Перевірте логи Argo CD

### RDS не створюється

1. Перевірте права доступу до RDS
2. Перевірте чи існують підмережі в VPC
3. Перевірте чи не перевищено ліміти AWS

### Django додаток не підключається до RDS

1. Перевірте чи існує RDS інстанс
2. Перевірте security group правила
3. Перевірте правильність connection string

### Aurora кластер не створюється

1. Перевірте чи підтримується обраний instance class
2. Перевірте чи не перевищено ліміти Aurora
3. Перевірте правильність параметрів

## 📚 Додаткова документація

-   [AWS RDS Documentation](https://docs.aws.amazon.com/rds/)
-   [AWS Aurora Documentation](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/)
-   [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
