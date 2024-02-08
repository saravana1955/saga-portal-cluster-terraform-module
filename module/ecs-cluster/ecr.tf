
resource "aws_ecr_repository" "ecr" {
  name         = "${var.service_name}-${var.environment}"
  force_delete = var.ecr_force_delete
  image_scanning_configuration {
    scan_on_push = true
  }
}
