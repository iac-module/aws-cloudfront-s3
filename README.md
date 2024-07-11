# aws-cloudfront-s3
This is a compiled terraform module capable of creating:
- CloudFont
- S3 bucket
- Route53 record

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.33.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.33.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloudfront"></a> [cloudfront](#module\_cloudfront) | git::https://github.com/terraform-aws-modules/terraform-aws-cloudfront.git//. | a0f0506106a4c8815c1c32596e327763acbef2c2 |
| <a name="module_records"></a> [records](#module\_records) | git::https://github.com/terraform-aws-modules/terraform-aws-route53.git//modules/records | 385af6e72673f90aa8c835f820067553f905bd17 |
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | git::https://github.com/terraform-aws-modules/terraform-aws-s3-bucket.git//. | 8a0b697adfbc673e6135c70246cff7f8052ad95a |

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket_policy.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_iam_policy_document.s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudfront"></a> [cloudfront](#input\_cloudfront) | The Cloudfront configuration | <pre>object({<br>    domain                        = optional(string, null)<br>    sub_domain                    = optional(string, null)<br>    create_distribution           = optional(bool, true)<br>    create_origin_access_identity = optional(bool, false)<br>    origin_access_identities      = optional(map(string), {})<br>    create_origin_access_control  = optional(bool, false)<br>    origin_access_control = optional(map(object({<br>      description      = string<br>      origin_type      = string<br>      signing_behavior = string<br>      signing_protocol = string<br>      })),<br>      {<br>        s3 = {<br>          description      = "",<br>          origin_type      = "s3",<br>          signing_behavior = "always",<br>          signing_protocol = "sigv4"<br>        }<br>      }<br>    )<br>    aliases                         = optional(list(string), null)<br>    comment                         = optional(string, null)<br>    continuous_deployment_policy_id = optional(string, null)<br>    default_root_object             = optional(string, null)<br>    enabled                         = optional(bool, true)<br>    http_version                    = optional(string, "http2")<br>    is_ipv6_enabled                 = optional(bool, null)<br>    price_class                     = optional(string, null)<br>    retain_on_delete                = optional(bool, false)<br>    wait_for_deployment             = optional(bool, true)<br>    web_acl_id                      = optional(string, null)<br>    staging                         = optional(bool, false)<br>    tags                            = optional(map(string), null)<br>    #origin                          = optional(any, {})<br>    origin_group = optional(any, {})<br>    viewer_certificate = optional(any, {<br>      cloudfront_default_certificate = true<br>      minimum_protocol_version       = "TLSv1"<br>    })<br>    geo_restriction                      = optional(any, {})<br>    logging_config                       = optional(any, {})<br>    custom_error_response                = optional(any, {})<br>    default_cache_behavior               = optional(any, null)<br>    ordered_cache_behavior               = optional(any, [])<br>    create_monitoring_subscription       = optional(bool, false)<br>    realtime_metrics_subscription_status = optional(string, "Enabled")<br>  })</pre> | n/a | yes |
| <a name="input_route53_record"></a> [route53\_record](#input\_route53\_record) | The bucket for hosting static | <pre>object({<br>    enabled = optional(bool, false)<br>    zone_id = optional(string, "")<br>    tags    = optional(map(string), {})<br>  })</pre> | `{}` | no |
| <a name="input_s3_bucket"></a> [s3\_bucket](#input\_s3\_bucket) | The bucket for hosting static | <pre>object({<br>    bucket            = optional(string, "")<br>    tags              = optional(map(string), {})<br>    suffix_for_assets = optional(string, "/*")<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_distribution_arn"></a> [cloudfront\_distribution\_arn](#output\_cloudfront\_distribution\_arn) | The ARN (Amazon Resource Name) for the distribution. |
| <a name="output_cloudfront_distribution_caller_reference"></a> [cloudfront\_distribution\_caller\_reference](#output\_cloudfront\_distribution\_caller\_reference) | Internal value used by CloudFront to allow future updates to the distribution configuration. |
| <a name="output_cloudfront_distribution_domain_name"></a> [cloudfront\_distribution\_domain\_name](#output\_cloudfront\_distribution\_domain\_name) | The domain name corresponding to the distribution. |
| <a name="output_cloudfront_distribution_etag"></a> [cloudfront\_distribution\_etag](#output\_cloudfront\_distribution\_etag) | The current version of the distribution's information. |
| <a name="output_cloudfront_distribution_hosted_zone_id"></a> [cloudfront\_distribution\_hosted\_zone\_id](#output\_cloudfront\_distribution\_hosted\_zone\_id) | The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to. |
| <a name="output_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#output\_cloudfront\_distribution\_id) | The identifier for the distribution. |
| <a name="output_cloudfront_distribution_in_progress_validation_batches"></a> [cloudfront\_distribution\_in\_progress\_validation\_batches](#output\_cloudfront\_distribution\_in\_progress\_validation\_batches) | The number of invalidation batches currently in progress. |
| <a name="output_cloudfront_distribution_last_modified_time"></a> [cloudfront\_distribution\_last\_modified\_time](#output\_cloudfront\_distribution\_last\_modified\_time) | The date and time the distribution was last modified. |
| <a name="output_cloudfront_distribution_status"></a> [cloudfront\_distribution\_status](#output\_cloudfront\_distribution\_status) | The current status of the distribution. Deployed if the distribution's information is fully propagated throughout the Amazon CloudFront system. |
| <a name="output_cloudfront_distribution_tags"></a> [cloudfront\_distribution\_tags](#output\_cloudfront\_distribution\_tags) | Tags of the distribution's |
| <a name="output_cloudfront_distribution_trusted_signers"></a> [cloudfront\_distribution\_trusted\_signers](#output\_cloudfront\_distribution\_trusted\_signers) | List of nested attributes for active trusted signers, if the distribution is set up to serve private content with signed URLs |
| <a name="output_cloudfront_monitoring_subscription_id"></a> [cloudfront\_monitoring\_subscription\_id](#output\_cloudfront\_monitoring\_subscription\_id) | The ID of the CloudFront monitoring subscription, which corresponds to the `distribution_id`. |
| <a name="output_cloudfront_origin_access_controls"></a> [cloudfront\_origin\_access\_controls](#output\_cloudfront\_origin\_access\_controls) | The origin access controls created |
| <a name="output_cloudfront_origin_access_controls_ids"></a> [cloudfront\_origin\_access\_controls\_ids](#output\_cloudfront\_origin\_access\_controls\_ids) | The IDS of the origin access identities created |
| <a name="output_cloudfront_origin_access_identities"></a> [cloudfront\_origin\_access\_identities](#output\_cloudfront\_origin\_access\_identities) | The origin access identities created |
| <a name="output_cloudfront_origin_access_identity_iam_arns"></a> [cloudfront\_origin\_access\_identity\_iam\_arns](#output\_cloudfront\_origin\_access\_identity\_iam\_arns) | The IAM arns of the origin access identities created |
| <a name="output_cloudfront_origin_access_identity_ids"></a> [cloudfront\_origin\_access\_identity\_ids](#output\_cloudfront\_origin\_access\_identity\_ids) | The IDS of the origin access identities created |
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | The ARN of the bucket. Will be of format arn:aws:s3:::bucketname. |
| <a name="output_s3_bucket_bucket_domain_name"></a> [s3\_bucket\_bucket\_domain\_name](#output\_s3\_bucket\_bucket\_domain\_name) | The bucket domain name. Will be of format bucketname.s3.amazonaws.com. |
| <a name="output_s3_bucket_bucket_regional_domain_name"></a> [s3\_bucket\_bucket\_regional\_domain\_name](#output\_s3\_bucket\_bucket\_regional\_domain\_name) | The bucket region-specific domain name. The bucket domain name including the region name, please refer here for format. Note: The AWS CloudFront allows specifying S3 region-specific endpoint when creating S3 origin, it will prevent redirect issues from CloudFront to S3 Origin URL. |
| <a name="output_s3_bucket_hosted_zone_id"></a> [s3\_bucket\_hosted\_zone\_id](#output\_s3\_bucket\_hosted\_zone\_id) | The Route 53 Hosted Zone ID for this bucket's region. |
| <a name="output_s3_bucket_id"></a> [s3\_bucket\_id](#output\_s3\_bucket\_id) | The name of the bucket. |
| <a name="output_s3_bucket_lifecycle_configuration_rules"></a> [s3\_bucket\_lifecycle\_configuration\_rules](#output\_s3\_bucket\_lifecycle\_configuration\_rules) | The lifecycle rules of the bucket, if the bucket is configured with lifecycle rules. If not, this will be an empty string. |
| <a name="output_s3_bucket_policy"></a> [s3\_bucket\_policy](#output\_s3\_bucket\_policy) | The policy of the bucket, if the bucket is configured with a policy. If not, this will be an empty string. |
| <a name="output_s3_bucket_region"></a> [s3\_bucket\_region](#output\_s3\_bucket\_region) | The AWS region this bucket resides in. |
| <a name="output_s3_bucket_website_domain"></a> [s3\_bucket\_website\_domain](#output\_s3\_bucket\_website\_domain) | The domain of the website endpoint, if the bucket is configured with a website. If not, this will be an empty string. This is used to create Route 53 alias records. |
| <a name="output_s3_bucket_website_endpoint"></a> [s3\_bucket\_website\_endpoint](#output\_s3\_bucket\_website\_endpoint) | The website endpoint, if the bucket is configured with a website. If not, this will be an empty string. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
