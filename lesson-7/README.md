# Lesson-7: EKS + ECR + Helm (Django) — eu-central-1

## 0) IAM доступи (користувач terraform)

-   Політики: AmazonS3FullAccess, AmazonDynamoDBFullAccess, AmazonEC2FullAccess,
    AmazonEC2ContainerRegistryFullAccess, AmazonEKSFullAccess, IAMFullAccess (для ролей EKS)
-   Налаштувати AWS CLI:
    `aws configure → region: eu-central-1`

## 1) Bootstrap backend.tf

-   Спочатку закоментувати backend.tf.
-   `terraform init`
-   Створити тільки S3 + DynamoDB для стейта:
    `terraform apply -target="module.s3_backend"`

## 2) Увімкнути backend.tf

-   Розкоментувати backend.tf
-   `terraform init -reconfigure`

## 3) Розгорнути всю інфру

`terraform apply`

Outputs:

-   ecr_repo_url
-   eks_cluster_name
-   eks_cluster_endpoint

## 4) Пуш Docker-образу в ECR

-   Отримати реєстр
    `$ECR_REGISTRY = (terraform output -raw ecr_repo_url).Split("/")[0]`

-   Логін у ECR
    `aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin $ECR_REGISTRY`

-   ЗОтримати повний репозиторій
    `$ECR_REPO = terraform output -raw ecr_repo_url`

-   Build образу
    `docker build -t django-app:latest ../lesson-4/django`

-   Retag під ECR
    `docker tag django-app:latest $ECR_REPO:latest`

-   Push у ECR
    `docker push $ECR_REPO:latest`

## 5) kubectl доступ до EKS

Після того як Terraform створить кластер, потрібно підключити `kubectl`, щоб керувати Kubernetes.

1. Отримання назви кластера:
   `$CLUSTER = terraform output -raw eks_cluster_name`

2. Оновлення kubeconfig
   `aws eks update-kubeconfig --region eu-central-1 --name $CLUSTER`

3. Перевірка

```
kubectl get nodes
kubectl get pods -A
```

## 6) Helm деплой

```
$ECR = terraform output -raw ecr_repo_url

helm upgrade --install django .\charts\django-app `
  --set "image.repository=$ECR" `
  --set "image.tag=latest"

```

-   Подивитися деплоймент і поди

```
kubectl get deployments
kubectl get pods -o wide
```

-   Подивитися сервіс (LoadBalancer)
    `kubectl get svc`

-   Перевірити HPA (autoscaling)
    `kubectl get hpa`

## 7) Destroy

`helm uninstall django`
`terraform destroy`
