variable "cloudfront" {
  description = "The Cloudfront configuration"
  type = object({
    domain                        = optional(string, null)
    sub_domain                    = optional(string, null)
    create_distribution           = optional(bool, true)
    create_origin_access_identity = optional(bool, false)
    origin_access_identities      = optional(map(string), {})
    create_origin_access_control  = optional(bool, false)
    origin_access_control = optional(map(object({
      description      = string
      origin_type      = string
      signing_behavior = string
      signing_protocol = string
      })),
      {
        s3 = {
          description      = "",
          origin_type      = "s3",
          signing_behavior = "always",
          signing_protocol = "sigv4"
        }
      }
    )
    aliases                         = optional(list(string), null)
    comment                         = optional(string, null)
    continuous_deployment_policy_id = optional(string, null)
    default_root_object             = optional(string, null)
    enabled                         = optional(bool, true)
    http_version                    = optional(string, "http2")
    is_ipv6_enabled                 = optional(bool, null)
    price_class                     = optional(string, null)
    retain_on_delete                = optional(bool, false)
    wait_for_deployment             = optional(bool, true)
    web_acl_id                      = optional(string, null)
    staging                         = optional(bool, false)
    tags                            = optional(map(string), null)
    #origin                          = optional(any, {})
    origin_group = optional(any, {})
    viewer_certificate = optional(any, {
      cloudfront_default_certificate = true
      minimum_protocol_version       = "TLSv1"
    })
    geo_restriction                      = optional(any, {})
    logging_config                       = optional(any, {})
    custom_error_response                = optional(any, {})
    default_cache_behavior               = optional(any, null)
    ordered_cache_behavior               = optional(any, [])
    create_monitoring_subscription       = optional(bool, false)
    realtime_metrics_subscription_status = optional(string, "Enabled")
  })
}

variable "cloudfront_keys" {
  description = "The Cloudfront keys"
  type = object({
    name = optional(string, "default")
    secrets = optional(map(object({
      secret_manager_name = string
      secret_manager_key  = string
      })), {}
    )
  })
  default = {}
}

variable "s3_buckets" {
  description = "The bucket for hosting static"
  type = map(object({
    suffix_for_assets = optional(string, "/*")

    create_bucket                              = optional(bool, true)
    attach_elb_log_delivery_policy             = optional(bool, false)
    attach_lb_log_delivery_policy              = optional(bool, false)
    attach_access_log_delivery_policy          = optional(bool, false)
    attach_deny_insecure_transport_policy      = optional(bool, false)
    attach_require_latest_tls_policy           = optional(bool, false)
    attach_policy                              = optional(bool, false)
    attach_public_policy                       = optional(bool, true)
    attach_inventory_destination_policy        = optional(bool, false)
    attach_analytics_destination_policy        = optional(bool, false)
    attach_deny_incorrect_encryption_headers   = optional(bool, false)
    attach_deny_incorrect_kms_key_sse          = optional(bool, false)
    allowed_kms_key_arn                        = optional(string, "")
    attach_deny_unencrypted_object_uploads     = optional(bool, false)
    bucket                                     = optional(string, "")
    bucket_prefix                              = optional(string, null)
    acl                                        = optional(string, null)
    policy                                     = optional(string, null)
    tags                                       = optional(map(string), {})
    force_destroy                              = optional(bool, false)
    acceleration_status                        = optional(string, null)
    request_payer                              = optional(string, null)
    website                                    = optional(any, {})
    cors_rule                                  = optional(any, [])
    versioning                                 = optional(map(string), {})
    logging                                    = optional(any, {})
    access_log_delivery_policy_source_buckets  = optional(list(string), [])
    access_log_delivery_policy_source_accounts = optional(list(string), [])
    grant                                      = optional(any, [])
    owner                                      = optional(map(string), {})
    expected_bucket_owner                      = optional(string, null)
    lifecycle_rule                             = optional(any, [])
    replication_configuration                  = optional(any, {})
    server_side_encryption_configuration       = optional(any, {})
    intelligent_tiering                        = optional(any, {})
    object_lock_configuration                  = optional(any, {})
    metric_configuration                       = optional(any, {})
    inventory_configuration                    = optional(any, {})
    inventory_source_account_id                = optional(string, null)
    inventory_source_bucket_arn                = optional(string, null)
    inventory_self_source_destination          = optional(bool, false)
    analytics_configuration                    = optional(any, {})
    analytics_source_account_id                = optional(string, null)
    analytics_source_bucket_arn                = optional(string, null)
    analytics_self_source_destination          = optional(bool, false)
    object_lock_enabled                        = optional(bool, false)
    block_public_acls                          = optional(bool, true)
    block_public_policy                        = optional(bool, true)
    ignore_public_acls                         = optional(bool, true)
    restrict_public_buckets                    = optional(bool, true)
    control_object_ownership                   = optional(bool, false)
    object_ownership                           = optional(string, "BucketOwnerEnforced")
    putin_khuylo                               = optional(bool, true)
  }))
  default = {}
}

variable "route53_record" {
  description = "The bucket for hosting static"
  type = object({
    enabled = optional(bool, false)
    zone_id = optional(string, "")
    tags    = optional(map(string), {})
  })
  default = {}
}
