variable "bucket_name" {
  description = "The name of the S3 bucket for Terraform state"
  type        = string
}

variable "table_name" {
  description = "The name of the DynamoDB table for Terraform locks"
  type        = string
}

variable "tags" {
  description = "Теги для всіх ресурсів"
  type    = map(string)
  default = {
    Project = "lesson-7"
  }
}
