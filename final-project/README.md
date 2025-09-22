# Final DevOps Project: Повна CI/CD інфраструктура з моніторингом

## 📋 Опис проекту

Цей проект реалізує повну DevOps інфраструктуру з автоматизацією CI/CD, моніторингом та безпекою. Включає всі необхідні компоненти для сучасного розгортання додатків у хмарі.

### 🏗️ Архітектура

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   GitHub Repo   │    │   Jenkins CI    │    │   Argo CD       │
│                 │───▶│                 │───▶│   GitOps        │
│   Source Code   │    │   Build & Test  │    │   Deployment    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │
                                ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   ECR Registry  │    │   EKS Cluster   │    │   RDS Database  │
│                 │◀───│                 │───▶│                 │
│   Docker Images │    │   Kubernetes    │    │   PostgreSQL    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │
                                ▼
┌─────────────────┐    ┌─────────────────┐
│   Prometheus    │    │   Grafana       │
│   Metrics       │───▶│   Dashboards    │
│   Collection    │    │   Monitoring    │
└─────────────────┘    └─────────────────┘
```

## 🚀 Компоненти системи

### Інфраструктура

-   **AWS VPC** - ізольована мережа з публічними та приватними підмережами
-   **EKS** - Kubernetes кластер для оркестрації контейнерів
-   **RDS** - PostgreSQL база даних (з підтримкою Aurora)
-   **ECR** - приватний реєстр Docker образів
-   **S3 + DynamoDB** - зберігання Terraform стану

### CI/CD

-   **Jenkins** - автоматична збірка, тестування та деплой
-   **Argo CD** - GitOps автоматизація розгортання
-   **Helm** - управління Kubernetes додатками

### Моніторинг

-   **Prometheus** - збір метрик та моніторинг
-   **Grafana** - візуалізація метрик та дашборди
-   **Alertmanager** - система сповіщень

### Безпека

-   **SAST** - статичний аналіз коду (Bandit)
-   **DAST** - динамічний аналіз безпеки (OWASP ZAP)
-   **Container Security** - сканування образів (Trivy)
-   **IAM** - управління доступом та ролями

## 📁 Структура проекту

```
final-project/
├── main.tf                          # Головний файл Terraform
├── backend.tf                       # Налаштування S3 backend
├── outputs.tf                       # Виводи ресурсів
├── variables.tf                     # Змінні Terraform
├── terraform.tfvars                 # Конфігурація проекту
├── terraform.tfvars.example         # Приклад конфігурації
├── modules/                         # Terraform модулі
│   ├── s3-backend/                  # S3 + DynamoDB
│   ├── vpc/                         # VPC та мережа
│   ├── ecr/                         # ECR реєстр
│   ├── eks/                         # EKS кластер
│   ├── rds/                         # RDS база даних
│   ├── jenkins/                     # Jenkins CI
│   ├── argo_cd/                     # Argo CD GitOps
│   ├── prometheus/                  # Prometheus моніторинг
│   └── grafana/                     # Grafana візуалізація
├── charts/                          # Helm charts
│   └── django-app/                  # Django додаток
└── Django/                          # Django додаток
    ├── app/                         # Код додатку
    ├── Dockerfile                   # Docker образ
    ├── docker-compose.yml           # Локальна розробка
    ├── Jenkinsfile                  # CI/CD пайплайн
    └── nginx/                       # Nginx конфігурація
```

## 🛠️ Встановлення та налаштування

### Передумови

1. **AWS CLI** налаштований з правами доступу
2. **Terraform** >= 1.5.0
3. **kubectl** для роботи з Kubernetes
4. **Helm** для управління додатками
5. **Docker** для збірки образів

### Необхідні AWS політики

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": ["s3:*", "dynamodb:*", "ec2:*", "eks:*", "rds:*", "ecr:*", "iam:*"],
            "Resource": "*"
        }
    ]
}
```

### 1. Клонування репозиторію

```bash
git clone https://github.com/oleksbod/DevOpsCICD.git
cd DevOpsCICD/final-project
```

### 2. Налаштування конфігурації

```bash
# Копіюємо приклад конфігурації
cp terraform.tfvars.example terraform.tfvars

# Редагуємо конфігурацію
nano terraform.tfvars

# Налаштування Django .env файлу
cd Django
cp env.example .env
nano .env
```

**Обов'язкові змінні для налаштування:**

**terraform.tfvars:**

```hcl
# GitHub Configuration
github_token    = "your-github-pat-token"
github_username = "your-github-username"

# RDS Configuration
rds_master_password = "your-secure-password"
```

**Django/.env:**

```bash
# Django Configuration
DEBUG=True
SECRET_KEY=your-django-secret-key

# Database Configuration
DB_NAME=mydb
DB_USER=dbadmin
DB_PASSWORD=your-database-password
DB_HOST=db
DB_PORT=5432

# PostgreSQL Configuration
POSTGRES_DB=mydb
POSTGRES_USER=dbadmin
POSTGRES_PASSWORD=your-database-password
```

### 3. Розгортання інфраструктури

```bash
# Ініціалізація Terraform
terraform init

# Планування розгортання
terraform plan

# Застосування змін
terraform apply
```

### 4. Налаштування kubectl

```bash
# Отримуємо команду з outputs
terraform output eks_kubeconfig_command

# Виконуємо команду
aws eks update-kubeconfig --region eu-central-1 --name final-project-eks
```

## 🔍 Перевірка розгортання

### Перевірка EKS кластера

```bash
# Статус нод
kubectl get nodes

# Статус подів
kubectl get pods -A

# Статус сервісів
kubectl get svc -A
```

### Перевірка Jenkins

```bash
# Статус Jenkins
kubectl get pods -n jenkins

# Отримання паролю адміністратора
kubectl -n jenkins get secret jenkins -o jsonpath='{.data.jenkins-admin-password}' | base64 -d

# Доступ до Jenkins UI
kubectl port-forward svc/jenkins 8080:8080 -n jenkins
```

**Jenkins UI:** http://localhost:8080

-   **Логін:** admin
-   **Пароль:** (отриманий вище)

### Перевірка Argo CD

```bash
# Статус Argo CD
kubectl get pods -n argocd

# Отримання паролю адміністратора
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d

# Доступ до Argo CD UI
kubectl port-forward svc/argo-cd-argocd-server 8081:443 -n argocd
```

**Argo CD UI:** https://localhost:8081

-   **Логін:** admin
-   **Пароль:** (отриманий вище)

### Перевірка Prometheus

```bash
# Статус Prometheus
kubectl get pods -n monitoring

# Доступ до Prometheus UI
kubectl port-forward svc/prometheus-kube-prometheus-prometheus 9090:80 -n monitoring
```

**Prometheus UI:** http://localhost:9090

### Перевірка Grafana

```bash
# Статус Grafana
kubectl get pods -n monitoring

# Доступ до Grafana UI
kubectl port-forward svc/grafana 3000:80 -n monitoring
```

**Grafana UI:** http://localhost:3000

-   **Логін:** admin
-   **Пароль:** admin123

### Перевірка Django додатку

```bash
# Статус додатку
kubectl get pods -l app=django-app

# Сервіси
kubectl get svc -l app=django-app

# Логи додатку
kubectl logs -l app=django-app
```

## 📊 Моніторинг та метрики

### Prometheus метрики

Додаток автоматично експортує метрики на `/metrics/` endpoint:

-   **HTTP запити** - кількість та час відповіді
-   **Database з'єднання** - статус підключення до БД
-   **System ресурси** - CPU, пам'ять, диск
-   **Custom метрики** - бізнес-логіка додатку

### Grafana дашборди

Автоматично імпортуються дашборди:

-   **Kubernetes Cluster Monitoring** (ID: 7249)
-   **Kubernetes Pod Monitoring** (ID: 6417)
-   **Node Exporter Full** (ID: 1860)

### Налаштування алертів

Prometheus налаштований для відстеження:

-   Високого CPU використання
-   Недоступності сервісів
-   Помилок бази даних
-   Перевищення лімітів пам'яті

## 🔒 Безпека

### SAST (Static Application Security Testing)

Jenkins пайплайн включає:

-   **Bandit** - аналіз Python коду
-   **Trivy** - сканування Docker образів
-   **Gitleaks** - пошук секретів у коді

### DAST (Dynamic Application Security Testing)

-   **OWASP ZAP** - автоматичне тестування веб-додатку
-   **Nikto** - базове сканування безпеки
-   **Nuclei** - шаблони атак

### Container Security

-   **Non-root user** - додаток запускається не від root
-   **Read-only filesystem** - захист від модифікації
-   **Security contexts** - обмеження привілеїв
-   **Image scanning** - перевірка вразливостей

## 🚀 CI/CD Pipeline

### Jenkins Pipeline етапи

1. **Checkout** - отримання коду з Git
2. **Build** - збірка Docker образу
3. **Security Scan** - SAST аналіз
4. **Push to ECR** - завантаження образу
5. **Update Chart** - оновлення Helm chart
6. **Deploy to Staging** - розгортання на staging
7. **DAST Scan** - динамічне тестування
8. **Deploy to Production** - розгортання в продакшн

### Argo CD Application

Автоматично синхронізує:

-   Helm chart з GitHub репозиторію
-   Оновлення конфігурації
-   Rollback при помилках
-   Health checks

## 📈 Автомасштабування

### Horizontal Pod Autoscaler (HPA)

```yaml
minReplicas: 1
maxReplicas: 3
targetCPUUtilizationPercentage: 70
targetMemoryUtilizationPercentage: 80
```

### Vertical Pod Autoscaler (VPA)

Автоматично налаштовує:

-   CPU requests/limits
-   Memory requests/limits
-   На основі історичних даних

## 🗄️ База даних

### RDS PostgreSQL

-   **Engine:** PostgreSQL 15.14
-   **Instance:** db.t3.micro
-   **Storage:** 20GB GP2
-   **Backup:** 7 днів
-   **Encryption:** Enabled

### Aurora (опціонально)

```hcl
use_aurora = true
aurora_cluster_instances = 2
aurora_auto_pause = true
```

## 💰 Вартість

### Щомісячні витрати (приблизно)

-   **EKS Cluster:** ~$70
-   **EC2 Instances (2x t3.large):** ~$60
-   **RDS (db.t3.micro):** ~$15
-   **Load Balancers:** ~$20
-   **Storage (EBS):** ~$10
-   **Data Transfer:** ~$5

**Загальна вартість:** ~$180/місяць

## 🧪 Тестування

### Локальне тестування

```bash
cd Django
docker-compose up -d
```

### Тестування в Kubernetes

```bash
# Деплой тестового додатку
helm install django-test ./charts/django-app --namespace test

# Перевірка статусу
kubectl get pods -n test

# Тестування API
curl http://localhost:8000/health/
curl http://localhost:8000/metrics/
```

## 🔧 Troubleshooting

### Часті проблеми

#### Jenkins не може підключитися до GitHub

```bash
# Перевірка credentials
kubectl get secret github-token -n jenkins

# Перевірка IAM ролі
kubectl describe sa jenkins-sa -n jenkins
```

#### Argo CD не синхронізує

```bash
# Перевірка статусу Application
kubectl get applications -n argocd

# Логи Argo CD
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-server
```

#### Prometheus не збирає метрики

```bash
# Перевірка ServiceMonitor
kubectl get servicemonitor -A

# Перевірка Prometheus targets
kubectl port-forward svc/prometheus-kube-prometheus-prometheus 9090:80 -n monitoring
# Відкрити http://localhost:9090/targets
```

#### Django додаток не підключається до RDS

```bash
# Перевірка RDS endpoint
terraform output rds_instance_endpoint

# Перевірка security groups
kubectl describe pod django-app-xxx
```

## 📚 Додаткова документація

-   [AWS EKS Documentation](https://docs.aws.amazon.com/eks/)
-   [Prometheus Documentation](https://prometheus.io/docs/)
-   [Grafana Documentation](https://grafana.com/docs/)
-   [Jenkins Documentation](https://www.jenkins.io/doc/)
-   [Argo CD Documentation](https://argo-cd.readthedocs.io/)
-   [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

## 👥 Автори

-   **Oleksandr** - _Initial work_ - [oleksbod](https://github.com/oleksbod)

## 🙏 Подяки

-   AWS за безкоштовний tier
-   Prometheus community за відмінний інструмент моніторингу
-   Grafana team за красиві дашборди
-   Jenkins community за CI/CD платформу
-   Argo CD team за GitOps рішення

---

**УВАГА!** Після тестування обов'язково видаліть ресурси командою `terraform destroy` для уникнення непередбачуваних витрат.
