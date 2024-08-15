module "s3_buckets" {
  source                                     = "git::https://github.com/terraform-aws-modules/terraform-aws-s3-bucket.git//.?ref=8a0b697adfbc673e6135c70246cff7f8052ad95a" #v4.1.2
  for_each                                   = var.s3_buckets
  attach_elb_log_delivery_policy             = each.value.attach_elb_log_delivery_policy
  attach_lb_log_delivery_policy              = each.value.attach_lb_log_delivery_policy
  attach_access_log_delivery_policy          = each.value.attach_access_log_delivery_policy
  attach_deny_insecure_transport_policy      = each.value.attach_deny_insecure_transport_policy
  attach_require_latest_tls_policy           = each.value.attach_require_latest_tls_policy
  attach_policy                              = each.value.attach_policy
  attach_public_policy                       = each.value.attach_public_policy
  attach_inventory_destination_policy        = each.value.attach_inventory_destination_policy
  attach_analytics_destination_policy        = each.value.attach_analytics_destination_policy
  attach_deny_incorrect_encryption_headers   = each.value.attach_deny_incorrect_encryption_headers
  attach_deny_incorrect_kms_key_sse          = each.value.attach_deny_incorrect_kms_key_sse
  allowed_kms_key_arn                        = each.value.allowed_kms_key_arn
  attach_deny_unencrypted_object_uploads     = each.value.attach_deny_unencrypted_object_uploads
  bucket                                     = each.value.bucket
  bucket_prefix                              = each.value.bucket_prefix
  acl                                        = each.value.acl
  policy                                     = each.value.policy
  tags                                       = each.value.tags
  force_destroy                              = each.value.force_destroy
  acceleration_status                        = each.value.acceleration_status
  request_payer                              = each.value.request_payer
  website                                    = each.value.website
  cors_rule                                  = each.value.cors_rule
  versioning                                 = each.value.versioning
  logging                                    = each.value.logging
  access_log_delivery_policy_source_buckets  = each.value.access_log_delivery_policy_source_buckets
  access_log_delivery_policy_source_accounts = each.value.access_log_delivery_policy_source_accounts
  grant                                      = each.value.grant
  owner                                      = each.value.owner
  expected_bucket_owner                      = each.value.expected_bucket_owner
  lifecycle_rule                             = each.value.lifecycle_rule
  replication_configuration                  = each.value.replication_configuration
  server_side_encryption_configuration       = each.value.server_side_encryption_configuration
  intelligent_tiering                        = each.value.intelligent_tiering
  object_lock_configuration                  = each.value.object_lock_configuration
  metric_configuration                       = each.value.metric_configuration
  inventory_configuration                    = each.value.inventory_configuration
  inventory_source_account_id                = each.value.inventory_source_account_id
  inventory_source_bucket_arn                = each.value.inventory_source_bucket_arn
  inventory_self_source_destination          = each.value.inventory_self_source_destination
  analytics_configuration                    = each.value.analytics_configuration
  analytics_source_account_id                = each.value.analytics_source_account_id
  analytics_source_bucket_arn                = each.value.analytics_source_bucket_arn
  analytics_self_source_destination          = each.value.analytics_self_source_destination
  object_lock_enabled                        = each.value.object_lock_enabled
  block_public_acls                          = each.value.block_public_acls
  block_public_policy                        = each.value.block_public_policy
  ignore_public_acls                         = each.value.ignore_public_acls
  restrict_public_buckets                    = each.value.restrict_public_buckets
  control_object_ownership                   = each.value.control_object_ownership
  object_ownership                           = each.value.object_ownership
  putin_khuylo                               = each.value.putin_khuylo
}

resource "aws_s3_bucket_policy" "buckets_policy" {
  for_each = var.s3_buckets
  bucket   = module.s3_buckets[each.key].s3_bucket_id
  policy   = data.aws_iam_policy_document.s3_p[each.key].json
}

module "cloudfront" {
  source                          = "git::https://github.com/terraform-aws-modules/terraform-aws-cloudfront.git//.?ref=a0f0506106a4c8815c1c32596e327763acbef2c2" #v3.4.0
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
    for k, bd in var.s3_buckets : "s3_${var.s3_buckets[k].bucket}" => {
      domain_name           = module.s3_buckets[k].s3_bucket_bucket_regional_domain_name
      origin_access_control = "s3_${var.s3_buckets[k].bucket}"
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
