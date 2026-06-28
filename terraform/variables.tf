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

variable "instance_type" {
  description = "EC2 instance size"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Existing EC2 key pair name in AWS (the one for test.pem)"
  type        = string
  default     = "test"
}

variable "ssh_cidr" {
  description = "Your IP in CIDR form for SSH access, e.g. 203.0.113.10/32"
  type        = string
}

variable "app_port" {
  description = "Port where Gunicorn listens"
  type        = number
  default     = 5000
}

variable "enable_alb" {
  description = "Create an Application Load Balancer on port 80 (extra cost; better production pattern)"
  type        = bool
  default     = false
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
