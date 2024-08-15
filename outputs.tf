output "s3_buckets" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value = try({
    for k, bd in var.s3_buckets : var.s3_buckets[k].bucket => {
      s3_bucket_id                            = module.s3_buckets[k].s3_bucket_id
      s3_bucket_arn                           = module.s3_buckets[k].s3_bucket_arn
      s3_bucket_bucket_domain_name            = module.s3_buckets[k].s3_bucket_bucket_domain_name
      s3_bucket_bucket_regional_domain_name   = module.s3_buckets[k].s3_bucket_bucket_regional_domain_name
      s3_bucket_hosted_zone_id                = module.s3_buckets[k].s3_bucket_hosted_zone_id
      s3_bucket_lifecycle_configuration_rules = module.s3_buckets[k].s3_bucket_lifecycle_configuration_rules
      s3_bucket_policy                        = module.s3_buckets[k].s3_bucket_policy
      s3_bucket_region                        = module.s3_buckets[k].s3_bucket_region
      s3_bucket_website_endpoint              = module.s3_buckets[k].s3_bucket_website_endpoint
      s3_bucket_website_domain                = module.s3_buckets[k].s3_bucket_website_domain
    }
  }, "")
}

output "s3_buckets_arns" {
  description = "The arns of s3 buckets."
  value = [
    for bd in module.s3_buckets : bd.s3_bucket_arn
  ]
}

#cloudfront
output "cloudfront_distribution_id" {
  description = "The identifier for the distribution."
  value       = try(module.cloudfront.cloudfront_distribution_id, "")
}

output "cloudfront_distribution_arn" {
  description = "The ARN (Amazon Resource Name) for the distribution."
  value       = try(module.cloudfront.cloudfront_distribution_arn, "")
}

output "cloudfront_distribution_caller_reference" {
  description = "Internal value used by CloudFront to allow future updates to the distribution configuration."
  value       = try(module.cloudfront.cloudfront_distribution_caller_reference, "")
}

output "cloudfront_distribution_status" {
  description = "The current status of the distribution. Deployed if the distribution's information is fully propagated throughout the Amazon CloudFront system."
  value       = try(module.cloudfront.cloudfront_distribution_status, "")
}

output "cloudfront_distribution_trusted_signers" {
  description = "List of nested attributes for active trusted signers, if the distribution is set up to serve private content with signed URLs"
  value       = try(module.cloudfront.cloudfront_distribution_trusted_signers, "")
}

output "cloudfront_distribution_domain_name" {
  description = "The domain name corresponding to the distribution."
  value       = try(module.cloudfront.cloudfront_distribution_domain_name, "")
}

output "cloudfront_distribution_last_modified_time" {
  description = "The date and time the distribution was last modified."
  value       = try(module.cloudfront.cloudfront_distribution_last_modified_time, "")
}

output "cloudfront_distribution_in_progress_validation_batches" {
  description = "The number of invalidation batches currently in progress."
  value       = try(module.cloudfront.cloudfront_distribution_in_progress_validation_batches, "")
}

output "cloudfront_distribution_etag" {
  description = "The current version of the distribution's information."
  value       = try(module.cloudfront.cloudfront_distribution_etag, "")
}

output "cloudfront_distribution_hosted_zone_id" {
  description = "The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to."
  value       = try(module.cloudfront.cloudfront_distribution_hosted_zone_id, "")
}

output "cloudfront_origin_access_identities" {
  description = "The origin access identities created"
  value       = try(module.cloudfront.cloudfront_origin_access_identities, "")
}

output "cloudfront_origin_access_identity_ids" {
  description = "The IDS of the origin access identities created"
  value       = try(module.cloudfront.cloudfront_origin_access_identity_ids, "")
}

output "cloudfront_origin_access_identity_iam_arns" {
  description = "The IAM arns of the origin access identities created"
  value       = try(module.cloudfront.cloudfront_origin_access_identity_iam_arns, "")
}

output "cloudfront_monitoring_subscription_id" {
  description = " The ID of the CloudFront monitoring subscription, which corresponds to the `distribution_id`."
  value       = try(module.cloudfront.cloudfront_monitoring_subscription_id, "")
}

output "cloudfront_distribution_tags" {
  description = "Tags of the distribution's"
  value       = try(module.cloudfront.cloudfront_distribution_tags, "")
}

output "cloudfront_origin_access_controls" {
  description = "The origin access controls created"
  value       = try(module.cloudfront.cloudfront_origin_access_controls, "")
}

output "cloudfront_origin_access_controls_ids" {
  description = "The IDS of the origin access identities created"
  value       = try(module.cloudfront.cloudfront_origin_access_controls_ids, "")
}
