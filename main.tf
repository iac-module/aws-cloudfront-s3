module "s3_bucket" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-s3-bucket.git//.?ref=8a0b697adfbc673e6135c70246cff7f8052ad95a" #v4.1.2

  bucket        = var.s3_bucket.bucket
  force_destroy = true
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = module.s3_bucket.s3_bucket_id
  policy = data.aws_iam_policy_document.s3_policy.json
}

module "cloudfront" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-cloudfront.git//.?ref=a0f0506106a4c8815c1c32596e327763acbef2c2" #v3.4.0

  create_distribution             = var.cloudfront.create_distribution
  create_origin_access_identity   = var.cloudfront.create_origin_access_identity
  origin_access_identities        = var.cloudfront.origin_access_identities
  create_origin_access_control    = var.cloudfront.create_origin_access_control
  origin_access_control           = var.cloudfront.origin_access_control
  aliases                         = var.cloudfront.aliases
  comment                         = var.cloudfront.comment
  continuous_deployment_policy_id = var.cloudfront.continuous_deployment_policy_id
  default_root_object             = var.cloudfront.default_root_object
  enabled                         = var.cloudfront.enabled
  http_version                    = var.cloudfront.http_version
  is_ipv6_enabled                 = var.cloudfront.is_ipv6_enabled
  price_class                     = var.cloudfront.price_class
  retain_on_delete                = var.cloudfront.retain_on_delete
  wait_for_deployment             = var.cloudfront.wait_for_deployment
  web_acl_id                      = var.cloudfront.web_acl_id
  staging                         = var.cloudfront.staging
  tags                            = var.cloudfront.tags
  origin = {
    "s3_${var.s3_bucket.bucket}" = { # with origin access control settings (recommended)
      domain_name           = module.s3_bucket.s3_bucket_bucket_regional_domain_name
      origin_access_control = "s3_${var.s3_bucket.bucket}" # key in `origin_access_control`
    }
  }
  origin_group          = var.cloudfront.origin_group
  viewer_certificate    = var.cloudfront.viewer_certificate
  geo_restriction       = var.cloudfront.geo_restriction
  logging_config        = var.cloudfront.logging_config
  custom_error_response = var.cloudfront.custom_error_response
  default_cache_behavior = merge(
    {
      trusted_key_groups = length(var.cloudfront_keys.secrets) > 0 ? [aws_cloudfront_key_group.selected[0].id] : []
    },
  var.cloudfront.default_cache_behavior)
  ordered_cache_behavior = [
    for obj in var.cloudfront.ordered_cache_behavior : merge({
      trusted_key_groups = length(var.cloudfront_keys.secrets) > 0 ? [aws_cloudfront_key_group.selected[0].id] : []
    }, obj)
  ]
  create_monitoring_subscription       = var.cloudfront.create_monitoring_subscription
  realtime_metrics_subscription_status = var.cloudfront.realtime_metrics_subscription_status
}

resource "aws_cloudfront_public_key" "selected" {
  for_each    = var.cloudfront_keys.secrets
  comment     = "${each.key} public key"
  encoded_key = base64decode(jsondecode(data.aws_secretsmanager_secret_version.secret-version[each.key].secret_string)[each.value.secret_manager_key])
  name        = each.key
}

resource "aws_cloudfront_key_group" "selected" {
  count   = length(var.cloudfront_keys.secrets) > 0 ? 1 : 0
  comment = "${var.cloudfront_keys.name} group"
  items = toset([
  for bd in aws_cloudfront_public_key.selected : bd.id])
  name = var.cloudfront_keys.name
}

module "records" {
  source  = "git::https://github.com/terraform-aws-modules/terraform-aws-route53.git//modules/records?ref=385af6e72673f90aa8c835f820067553f905bd17" #v2.11.0
  count   = var.route53_record.enabled ? 1 : 0
  zone_id = var.route53_record.zone_id
  records = [
    {
      name = var.cloudfront.sub_domain
      type = "A"
      alias = {
        name    = module.cloudfront.cloudfront_distribution_domain_name
        zone_id = module.cloudfront.cloudfront_distribution_hosted_zone_id
      }
    }
  ]
}
