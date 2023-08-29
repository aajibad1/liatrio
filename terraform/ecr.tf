resource "aws_ecr_repository" "liatrio-ecr" {
  name = "liatrio"
  image_scanning_configuration {
    scan_on_push = true
  }
}

output "ecr_image_url" {
  value = aws_ecr_repository.liatrio-ecr.repository_url
}

