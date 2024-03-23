# bucket
output "s3_bucket_id" {
  description = "The name of the bucket."
  value       = try(module.s3_bucket.s3_bucket_id, "")
}

output "s3_bucket_arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = try(module.s3_bucket.s3_bucket_arn, "")
}

output "s3_bucket_bucket_domain_name" {
  description = "The bucket domain name. Will be of format bucketname.s3.amazonaws.com."
  value       = try(module.s3_bucket.s3_bucket_bucket_domain_name, "")
}

output "s3_bucket_bucket_regional_domain_name" {
  description = "The bucket region-specific domain name. The bucket domain name including the region name, please refer here for format. Note: The AWS CloudFront allows specifying S3 region-specific endpoint when creating S3 origin, it will prevent redirect issues from CloudFront to S3 Origin URL."
  value       = try(module.s3_bucket.s3_bucket_bucket_regional_domain_name, "")
}

output "s3_bucket_hosted_zone_id" {
  description = "The Route 53 Hosted Zone ID for this bucket's region."
  value       = try(module.s3_bucket.s3_bucket_hosted_zone_id, "")
}

output "s3_bucket_lifecycle_configuration_rules" {
  description = "The lifecycle rules of the bucket, if the bucket is configured with lifecycle rules. If not, this will be an empty string."
  value       = try(module.s3_bucket.s3_bucket_lifecycle_configuration_rules, "")
}

output "s3_bucket_policy" {
  description = "The policy of the bucket, if the bucket is configured with a policy. If not, this will be an empty string."
  value       = try(module.s3_bucket.s3_bucket_policy, "")
}

output "s3_bucket_region" {
  description = "The AWS region this bucket resides in."
  value       = try(module.s3_bucket.s3_bucket_region, "")
}

output "s3_bucket_website_endpoint" {
  description = "The website endpoint, if the bucket is configured with a website. If not, this will be an empty string."
  value       = try(module.s3_bucket.s3_bucket_website_endpoint, "")
}

output "s3_bucket_website_domain" {
  description = "The domain of the website endpoint, if the bucket is configured with a website. If not, this will be an empty string. This is used to create Route 53 alias records."
  value       = try(module.s3_bucket.s3_bucket_website_domain, "")
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
