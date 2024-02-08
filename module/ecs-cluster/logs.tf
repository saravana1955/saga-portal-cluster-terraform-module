# logs.tf
# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "cb_log_group" {
  name              = "/${lower(var.service_name)}/ecs/${var.service_name}"
  retention_in_days = 30
  tags              = {
    Name = "/${var.service_name}_log-group_${var.service_name}"
  }
}

resource "aws_cloudwatch_log_stream" "cb_log_stream" {
  name           = "/${var.service_name}_log-stream_${var.service_name}"
  log_group_name = aws_cloudwatch_log_group.cb_log_group.name
}
