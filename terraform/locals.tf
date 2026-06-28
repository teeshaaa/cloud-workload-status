locals {
  enable_https = var.enable_https && var.enable_alb && var.domain_name != "" && var.route53_zone_name != ""
}
