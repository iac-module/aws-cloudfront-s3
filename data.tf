data "aws_iam_policy_document" "s3_policy" {
  # Origin Access Identities
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.s3_bucket.s3_bucket_arn}${var.s3_bucket.suffix_for_assets}"]

    principals {
      type        = "AWS"
      identifiers = module.cloudfront.cloudfront_origin_access_identity_iam_arns
    }
  }

  # Origin Access Controls
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.s3_bucket.s3_bucket_arn}${var.s3_bucket.suffix_for_assets}"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [module.cloudfront.cloudfront_distribution_arn]
    }
  }

  # denyInsecureTransport
  statement {
    sid       = "ForceSSLOnlyAccess"
    effect    = "Deny"
    actions   = ["*"]
    resources = ["${module.s3_bucket.s3_bucket_arn}${var.s3_bucket.suffix_for_assets}"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

data "aws_secretsmanager_secret" "key-by-name" {
  for_each = var.cloudfront_keys.secrets
  name     = each.value.secret_manager_name
}

data "aws_secretsmanager_secret_version" "secret-version" {
  for_each  = var.cloudfront_keys.secrets
  secret_id = data.aws_secretsmanager_secret.key-by-name[each.key].id
}
