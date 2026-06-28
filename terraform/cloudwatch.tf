resource "aws_cloudwatch_log_group" "app" {
  name              = "/${var.project_name}/flask-app"
  retention_in_days = 7

  tags = {
    Name    = "${var.project_name}-flask-logs"
    Project = var.project_name
  }
}
