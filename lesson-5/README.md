# Lesson-5 Terraform AWS Infrastructure

## Модулі:

-   **s3-backend**: S3 bucket + DynamoDB для state
-   **vpc**: VPC + підмережі + IGW + маршрутизація
-   **ecr**: Elastic Container Registry

## Команди:

1. Закоментовуємо backend.tf і запускаємо команди:

```
terraform init
terraform apply
```

2. Розкоментовуємо backend.tf і запускаємо:
   `terraform init -reconfigure`

Команди:

-   `terraform init` - ініціалізація
-   `terraform init -reconfigure` - переконфігурація
-   `terraform plan` - план
-   `terraform apply` - виконання
-   `terraform destroy` - видалення
