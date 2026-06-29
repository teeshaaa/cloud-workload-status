variable "aws_region" {
  description = "AWS region where resources are created (e.g. eu-north-1, not an AZ like eu-north-1b)"
  type        = string
  default     = "eu-north-1"
}

variable "project_name" {
  description = "Prefix used for resource names and tags"
  type        = string
  default     = "cloud-workload-status"
}

variable "environment" {
  description = "Environment name used in tags and resource names"
  type        = string
  default     = "dev"
}

variable "instance_type" {
  description = "EC2 instance size"
  type        = string
  default     = "t3.micro"
}

variable "min_size" {
  description = "Minimum number of EC2 instances in the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of EC2 instances in the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "desired_capacity" {
  description = "Desired number of EC2 instances in the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "key_name" {
  description = "Existing EC2 key pair name in AWS (used only when enable_ssh=true)"
  type        = string
  default     = "test"
}

variable "ssh_cidr" {
  description = "Your IP in CIDR form for SSH access, e.g. 203.0.113.10/32. Only used when enable_ssh=true."
  type        = string
  default     = "0.0.0.0/32"
}

variable "enable_ssh" {
  description = "Allow SSH access and associate a key pair. Prefer SSM when false."
  type        = bool
  default     = false
}

variable "app_port" {
  description = "Port where Gunicorn listens"
  type        = number
  default     = 5000
}

variable "enable_alb" {
  description = "Create an Application Load Balancer as the default front door"
  type        = bool
  default     = true
}

variable "enable_https" {
  description = "HTTPS on ALB via ACM. Requires enable_alb=true, domain_name, and route53_zone_name"
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "FQDN for the app, e.g. api.example.com (only used when enable_https=true)"
  type        = string
  default     = ""
}

variable "route53_zone_name" {
  description = "Route53 hosted zone name, e.g. example.com (only used when enable_https=true)"
  type        = string
  default     = ""
}

variable "enable_nat_gateway" {
  description = "Create a single NAT gateway so private app instances can reach the internet"
  type        = bool
  default     = true
}

variable "github_owner" {
  description = "GitHub owner or organization used for OIDC trust, e.g. nikita-asrani"
  type        = string
  default     = ""
}

variable "github_repo" {
  description = "GitHub repository name used for OIDC trust"
  type        = string
  default     = "cloud-workload-status"
}

variable "alarm_email" {
  description = "Optional email address for CloudWatch alarm and detection notifications"
  type        = string
  default     = ""
}

variable "monthly_budget_limit_usd" {
  description = "Monthly AWS budget threshold in USD"
  type        = number
  default     = 15
}

variable "enable_cloudtrail" {
  description = "Enable CloudTrail management and S3 data event logging"
  type        = bool
  default     = true
}

variable "enable_detection_pipeline" {
  description = "Enable the decoy S3 bucket and EventBridge to SNS or Lambda detection demo"
  type        = bool
  default     = true
}

variable "enable_ecs" {
  description = "Provision an optional ECS Fargate deployment path alongside the EC2 path"
  type        = bool
  default     = false
}

variable "container_image_tag" {
  description = "Container image tag used by the ECS task definition"
  type        = string
  default     = "latest"
}

variable "ecs_task_cpu" {
  description = "CPU units for the ECS Fargate task"
  type        = number
  default     = 256
}

variable "ecs_task_memory" {
  description = "Memory in MiB for the ECS Fargate task"
  type        = number
  default     = 512
}
