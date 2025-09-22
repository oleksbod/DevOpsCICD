resource "aws_ecr_repository" "repo" {
  name = var.ecr_name
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
  force_delete = true
  tags = { Name = var.ecr_name }
}
