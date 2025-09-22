# 🚀 Quick Start Guide - Final DevOps Project

## ⚡ Швидкий старт за 5 хвилин

### 1. Підготовка (1 хвилина)

```bash
# Клонування репозиторію
git clone https://github.com/oleksbod/DevOpsCICD.git
cd DevOpsCICD/final-project

# Налаштування конфігурації
cp terraform.tfvars.example terraform.tfvars

# Налаштування Django .env
cd Django
cp env.example .env
```

**Редагуйте `terraform.tfvars`:**

```hcl
github_token    = "your-github-pat-token"
github_username = "your-github-username"
rds_master_password = "your-secure-password"
```

**Редагуйте `Django/.env`:**

```bash
SECRET_KEY=your-django-secret-key
DB_PASSWORD=your-database-password
POSTGRES_PASSWORD=your-database-password
```

### 2. Розгортання (3 хвилини)

```bash
# Ініціалізація
terraform init

# Розгортання
terraform apply -auto-approve
```

### 3. Налаштування kubectl (30 секунд)

```bash
# Отримання команди
terraform output eks_kubeconfig_command

# Виконання команди
aws eks update-kubeconfig --region eu-central-1 --name final-project-eks
```

### 4. Перевірка (30 секунд)

```bash
# Статус подів
kubectl get pods -A

# Статус сервісів
kubectl get svc -A
```

## 🔗 Доступ до сервісів

### Jenkins

```bash
kubectl port-forward svc/jenkins 8080:8080 -n jenkins
```

**URL:** http://localhost:8080
**Логін:** admin
**Пароль:** `kubectl -n jenkins get secret jenkins -o jsonpath='{.data.jenkins-admin-password}' | base64 -d`

### Argo CD

```bash
kubectl port-forward svc/argo-cd-argocd-server 8081:443 -n argocd
```

**URL:** https://localhost:8081
**Логін:** admin
**Пароль:** `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d`

### Prometheus

```bash
kubectl port-forward svc/prometheus-kube-prometheus-prometheus 9090:80 -n monitoring
```

**URL:** http://localhost:9090

### Grafana

```bash
kubectl port-forward svc/grafana 3000:80 -n monitoring
```

**URL:** http://localhost:3000
**Логін:** admin
**Пароль:** admin123

### Django App

```bash
kubectl port-forward svc/django-app 8000:80
```

**URL:** http://localhost:8000

## 🧪 Тестування

### Health Check

```bash
curl http://localhost:8000/health/
```

### Metrics

```bash
curl http://localhost:8000/metrics/
```

### API Endpoints

```bash
# Health check
curl http://localhost:8000/health/

# Metrics
curl http://localhost:8000/metrics/

# API (потребує аутентифікації)
curl -X POST http://localhost:8000/api/login/ \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin"}'
```

## 🧹 Очищення

```bash
# Видалення всіх ресурсів
terraform destroy -auto-approve
```

## 🆘 Швидка допомога

### Проблема: Jenkins не запускається

```bash
kubectl get pods -n jenkins
kubectl logs -n jenkins -l app.kubernetes.io/name=jenkins
```

### Проблема: Argo CD не синхронізує

```bash
kubectl get applications -n argocd
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-server
```

### Проблема: Prometheus не збирає метрики

```bash
kubectl get servicemonitor -A
kubectl port-forward svc/prometheus-kube-prometheus-prometheus 9090:80 -n monitoring
# Відкрити http://localhost:9090/targets
```

### Проблема: Django не підключається до БД

```bash
kubectl logs -l app=django-app
terraform output rds_instance_endpoint
```

## 📊 Моніторинг

### Перевірка метрик

```bash
# Prometheus targets
kubectl port-forward svc/prometheus-kube-prometheus-prometheus 9090:80 -n monitoring
# Відкрити http://localhost:9090/targets

# Grafana dashboards
kubectl port-forward svc/grafana 3000:80 -n monitoring
# Відкрити http://localhost:3000
```

### Корисні команди

```bash
# Статус всіх подів
kubectl get pods -A

# Логи додатку
kubectl logs -l app=django-app

# Опис поду
kubectl describe pod <pod-name>

# Статус сервісів
kubectl get svc -A

# Статус ingress
kubectl get ingress -A
```

## 🎯 Наступні кроки

1. **Налаштуйте GitHub PAT** в Jenkins
2. **Створіть Argo CD Application** для автоматичного деплою
3. **Налаштуйте Grafana дашборди** для моніторингу
4. **Додайте алерти** в Prometheus
5. **Налаштуйте backup** для RDS

---

**💡 Порада:** Використовуйте `kubectl get events --sort-by=.metadata.creationTimestamp` для перегляду останніх подій в кластері.
