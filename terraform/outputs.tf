output "iam_role_name" {
  description = "IAM role attached to the EC2 instances"
  value       = aws_iam_role.ec2.name
}

output "cloudwatch_log_group" {
  description = "CloudWatch log group for Flask app logs"
  value       = aws_cloudwatch_log_group.app.name
}

output "health_url" {
  description = "Health check endpoint"
  value = local.enable_https ? "https://${var.domain_name}/health" : (
    var.enable_alb ? "http://${aws_lb.app[0].dns_name}/health" : (
      length(data.aws_instance.app) > 0 ? "http://${data.aws_instance.app[0].public_ip}:${var.app_port}/health" : null
    )
  )
}

output "app_url" {
  description = "Primary application URL"
  value = local.enable_https ? "https://${var.domain_name}" : (
    var.enable_alb ? "http://${aws_lb.app[0].dns_name}" : (
      length(data.aws_instance.app) > 0 ? "http://${data.aws_instance.app[0].public_ip}:${var.app_port}" : null
    )
  )
}

output "alb_dns_name" {
  description = "Load balancer DNS name (only when enable_alb = true)"
  value       = var.enable_alb ? aws_lb.app[0].dns_name : null
}

output "autoscaling_group_name" {
  description = "Auto Scaling Group name for the EC2 app fleet"
  value       = aws_autoscaling_group.app.name
}

output "artifact_bucket_name" {
  description = "S3 bucket that stores versioned app deployment artifacts"
  value       = module.app_artifacts.bucket_name
}

output "github_actions_role_arn" {
  description = "OIDC role ARN for GitHub Actions. Null until github_owner is configured."
  value       = local.enable_github_oidc ? aws_iam_role.github_actions[0].arn : null
}

output "instance_id" {
  description = "Running EC2 instance ID in the Auto Scaling Group"
  value       = try(data.aws_instance.app[0].id, null)
}

output "public_ip" {
  description = "Public IP of the running EC2 instance (when ALB is disabled)"
  value       = var.enable_alb ? null : try(data.aws_instance.app[0].public_ip, null)
}

output "ssm_start_session_example" {
  description = "Example command to start an SSM shell once the instance is running"
  value       = try(data.aws_instance.app[0].id, null) != null ? "aws ssm start-session --target ${data.aws_instance.app[0].id} --region ${var.aws_region}" : null
}

output "cloudtrail_name" {
  description = "CloudTrail name"
  value       = var.enable_cloudtrail ? aws_cloudtrail.main[0].name : null
}

output "decoy_bucket_name" {
  description = "S3 decoy bucket used by the detection pipeline"
  value       = var.enable_detection_pipeline ? aws_s3_bucket.decoy[0].bucket : null
}

output "detection_topic_arn" {
  description = "SNS topic that receives enriched decoy alerts"
  value       = var.enable_detection_pipeline ? aws_sns_topic.alerts[0].arn : null
}

output "ecs_repository_url" {
  description = "ECR repository URL for the optional ECS deployment path"
  value       = aws_ecr_repository.app.repository_url
}

output "budget_name" {
  description = "Monthly cost budget created for the project"
  value       = aws_budgets_budget.project.name
}
