locals {
  enable_https       = var.enable_https && var.enable_alb && var.domain_name != "" && var.route53_zone_name != ""
  enable_github_oidc = var.github_owner != "" && var.github_repo != ""

  app_name             = "${var.project_name}-${var.environment}"
  artifact_bucket_name = "${local.app_name}-artifacts-${data.aws_caller_identity.current.account_id}"
  trail_bucket_name    = "${local.app_name}-cloudtrail-${data.aws_caller_identity.current.account_id}"
  decoy_bucket_name    = "${local.app_name}-decoy-${data.aws_caller_identity.current.account_id}"

  common_tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
    Project     = var.project_name
  }
}
