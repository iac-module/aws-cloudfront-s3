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

variable "s3_bucket" {
  description = "The bucket for hosting static"
  type = object({
    bucket            = optional(string, "")
    tags              = optional(map(string), {})
    suffix_for_assets = optional(string, "/*")
  })
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
