output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.app.id
}

output "public_ip" {
  description = "EC2 public IP for SSH"
  value       = aws_instance.app.public_ip
}

output "iam_role_name" {
  description = "IAM role attached to the EC2 instance"
  value       = aws_iam_role.ec2.name
}

output "cloudwatch_log_group" {
  description = "CloudWatch log group for Flask app logs"
  value       = aws_cloudwatch_log_group.app.name
}

output "health_url" {
  description = "Health check endpoint"
  value = local.enable_https ? "https://${var.domain_name}/health" : (
    var.enable_alb ? "http://${aws_lb.app[0].dns_name}/health" : "http://${aws_instance.app.public_ip}:${var.app_port}/health"
  )
}

output "app_url" {
  description = "Primary application URL"
  value = local.enable_https ? "https://${var.domain_name}" : (
    var.enable_alb ? "http://${aws_lb.app[0].dns_name}" : "http://${aws_instance.app.public_ip}:${var.app_port}"
  )
}

output "alb_dns_name" {
  description = "Load balancer DNS name (only when enable_alb = true)"
  value       = var.enable_alb ? aws_lb.app[0].dns_name : null
}

output "ssh_command" {
  description = "Example SSH command (update path to your .pem file)"
  value       = "ssh -i C:\\Users\\nikita.asrani\\Downloads\\test.pem ubuntu@${aws_instance.app.public_ip}"
}
