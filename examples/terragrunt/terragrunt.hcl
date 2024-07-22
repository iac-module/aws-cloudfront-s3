include {
  path = find_in_parent_folders()
}
iam_role = local.account_vars.iam_role

terraform {
  source = "git::https://github.com/iac-module/aws-cloudfront-s3.git//?ref=v1.1.0"
}

locals {
  common_tags  = read_terragrunt_config(find_in_parent_folders("tags.hcl"))
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region       = local.region_vars.locals.aws_region
  name         = basename(get_terragrunt_dir())
  bucket_name  = "${local.account_vars.locals.aws_account_id}-${local.region}-${local.account_vars.locals.env_name}-${local.name}"
}
dependency "acm" {
  config_path = find_in_parent_folders("acm/${local.account_vars.locals.main_domain}")
}
dependency "route53_zone" {
  config_path = find_in_parent_folders("core/route53/${local.account_vars.locals.main_domain}/zone")
}

inputs = {
  cloudfront = {
    sub_domain                     = "content"
    aliases                        = ["content.${local.account_vars.locals.main_domain}"]
    comment                        = "Content CloudFront"
    enabled                        = true
    staging                        = false # If you want to create a staging distribution, set this to true
    http_version                   = "http2and3"
    is_ipv6_enabled                = true
    price_class                    = "PriceClass_All"
    retain_on_delete               = false
    wait_for_deployment            = false
    default_root_object            = "index.html"
    create_monitoring_subscription = true
    create_origin_access_identity  = true
    origin_access_identities = {
      s3_bucket_one = " CloudFront S3 bucket for ${local.name}"
    }
    create_origin_access_control = true
    origin_access_control = {
      "s3_${local.bucket_name}" = {
        description      = "CloudFront access to S3 ${local.name}"
        origin_type      = "s3"
        signing_behavior = "always"
        signing_protocol = "sigv4"
      }
    }
    default_cache_behavior = {
      target_origin_id             = "s3_${local.bucket_name}"
      viewer_protocol_policy       = "redirect-to-https"
      allowed_methods              = ["GET", "HEAD", "OPTIONS"]
      cached_methods               = ["GET", "HEAD"]
      compress                     = true
      query_string                 = true
      use_forwarded_values         = false
      cache_policy_name            = "Managed-CachingOptimized"
      origin_request_policy_name   = "Managed-UserAgentRefererHeaders"
      response_headers_policy_name = "Managed-SimpleCORS"
      trusted_key_groups           = []
    }
    ordered_cache_behavior = [{
      path_pattern                 = "/private/*"
      target_origin_id             = "s3_${local.bucket_name}"
      viewer_protocol_policy       = "redirect-to-https"
      allowed_methods              = ["GET", "HEAD"]
      cached_methods               = ["GET", "HEAD"]
      use_forwarded_values         = false
      cache_policy_name            = "Managed-CachingOptimized"
      origin_request_policy_name   = "Managed-UserAgentRefererHeaders"
      response_headers_policy_name = "Managed-SimpleCORS"
    },
      {
        path_pattern                 = "/public/*"
        target_origin_id             = "s3_${local.bucket_name}"
        viewer_protocol_policy       = "redirect-to-https"
        trusted_key_groups           = []
        allowed_methods              = ["GET", "HEAD"]
        cached_methods               = ["GET", "HEAD"]
        use_forwarded_values         = false
        cache_policy_name            = "Managed-CachingOptimized"
        origin_request_policy_name   = "Managed-UserAgentRefererHeaders"
        response_headers_policy_name = "Managed-SimpleCORS"
      }]

    viewer_certificate = {
      acm_certificate_arn      = dependency.acm.outputs.acm_certificate_arn
      ssl_support_method       = "sni-only"
      minimum_protocol_version = "TLSv1.2_2021"
    }
    custom_error_response = [{
      error_caching_min_ttl = 10
      error_code            = 403
      response_code         = 200
      response_page_path    = "/index.html"
    }]
  }

  cloudfront_keys = {
    name = local.name
    secrets = {
      dev-0001-content = {
        #checkov:skip=CKV_SECRET_6:It's public key
        secret_manager_name = "ENV/dev-content"
        secret_manager_key  = "dev-0001-content.pub"
      }
      dev-0001-tf = {
        #checkov:skip=CKV_SECRET_6:It's public key
        secret_manager_name = "ENV/dev-content"
        secret_manager_key  = "dev-0001-tf.pub"
      }
    }
  }
  s3_bucket = {
    bucket = local.bucket_name
  }
  route53_record = {
    enabled = true
    zone_id = dependency.route53_zone.outputs.route53_zone_zone_id["${local.account_vars.locals.main_domain}"]
  }
}
