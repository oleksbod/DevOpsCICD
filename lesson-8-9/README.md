# Lesson-8-9: Повний CI/CD з Jenkins + Helm + Terraform + Argo CD

## Опис проекту

Цей проект реалізує повний CI/CD-процес з використанням:

-   **Jenkins** - для автоматичної збірки Docker-образів
-   **Helm** - для управління Kubernetes додатками
-   **Terraform** - для інфраструктури як код
-   **Argo CD** - для GitOps автоматизації розгортання

## Структура проекту

```
lesson-8-9/
├── main.tf                          # Головний файл Terraform
├── backend.tf                       # Налаштування S3 backend
├── outputs.tf                       # Виводи ресурсів
├── Jenkinsfile                      # CI/CD pipeline
├── modules/
│   ├── s3-backend/                  # S3 + DynamoDB модуль
│   ├── vpc/                         # VPC модуль
│   ├── ecr/                         # ECR модуль
│   ├── eks/                         # EKS модуль
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
-   IAMFullAccess

## Встановлення

### 1. Підготовка робочої директорії

```bash
# Перейдіть в директорію проекту
cd lesson-8-9
```

### 2. Налаштування змінних

Створіть файл `terraform.tfvars`:

```hcl
github_token    = "your_github_pat_token"
github_username = "your_github_username"
```

### 3. Bootstrap S3 Backend

```bash
# Спочатку закоментуйте backend.tf
terraform init
terraform apply -target="module.s3_backend"
```

### 4. Увімкнення backend.tf

```bash
# Розкоментуйте backend.tf
terraform init -reconfigure
```

### 5. Розгортання інфраструктури

```bash
terraform apply
```

## Використання

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
5. Пароль: (з команди вище)

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
5. Пароль: (з команди вище)

### Налаштування Jenkins

1. Увійдіть в Jenkins UI
2. Перейдіть в "Manage Jenkins" → "Manage Credentials"
3. Додайте GitHub Personal Access Token:
    - Kind: Username with password
    - Username: ваш GitHub username
    - Password: ваш GitHub PAT
    - ID: `github-token`

### Запуск CI/CD Pipeline

1. У Jenkins UI знайдіть job "goit-django-docker"
2. Натисніть "Build Now"
3. Pipeline автоматично:
    - Збере Docker образ з Django додатком
    - Запушить образ в Amazon ECR
    - Оновить тег в Helm chart
    - Запушить зміни в GitHub

### Перевірка в Argo CD

1. Відкрийте Argo CD UI
2. Перевірте статус додатку "django-app"
3. Argo CD автоматично синхронізує зміни з GitHub

## CI/CD Процес

### 1. Jenkins Pipeline (Jenkinsfile)

```groovy
pipeline {
  agent {
    kubernetes {
      // Kaniko + Git контейнери
    }
  }

  stages {
    stage('Build & Push Docker Image') {
      // Збірка образу з Kaniko
      // Пуш в ECR
    }

    stage('Update Chart Tag in Git') {
      // Оновлення тегу в values.yaml
      // Пуш змін в GitHub
    }
  }
}
```

### 2. Argo CD Application

-   Відстежує зміни в GitHub репозиторії
-   Автоматично синхронізує Helm chart
-   Розгортає оновлення в EKS кластер

## Команди для перевірки

### Перевірка EKS кластера

```bash
# Оновлення kubeconfig
aws eks update-kubeconfig --region eu-central-1 --name lesson-8-9-eks

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

### Перевірка Django додатку

```bash
# Статус додатку
kubectl get pods -l app=django-app

# Сервіси
kubectl get svc -l app=django-app

# Логи додатку
kubectl logs -l app=django-app
```

## Видалення ресурсів

Після перевірки обов'язково видаліть ресурси:

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

### Django додаток не запускається

1. Перевірте чи існує Docker образ в ECR
2. Перевірте правильність тегу в values.yaml
3. Перевірте логи подів

## Корисні посилання

-   [Jenkins Kubernetes Plugin](https://plugins.jenkins.io/kubernetes/)
-   [Argo CD Documentation](https://argo-cd.readthedocs.io/)
-   [AWS EKS Documentation](https://docs.aws.amazon.com/eks/)
-   [Helm Documentation](https://helm.sh/docs/)
