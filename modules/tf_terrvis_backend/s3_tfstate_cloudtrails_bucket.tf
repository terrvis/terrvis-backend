resource "aws_s3_bucket" "terrvis_tfstate_cloudtrails_bucket" {
  bucket        = "terrvis-trails-${data.aws_caller_identity.tfstate_current.account_id}"
  force_destroy = true
  lifecycle_rule {
    id      = "terrvis-trails"
    enabled = true
    prefix = "${var.environment_name}/"
    tags {
      "rule"      = "log"
      "autoclean" = "true"
    }
    transition {
      days          = 30
      storage_class = "STANDARD_IA" # or "ONEZONE_IA"
    }
    transition {
      days          = 60
      storage_class = "GLACIER"
    }
    expiration {
      days = 90
    }
  }

  policy = <<POLICY
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "Put bucket policy needed for trails",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::terrvis-trails-${data.aws_caller_identity.tfstate_current.account_id}/*"
    },
    {
      "Sid": "Get bucket policy needed for trails",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::terrvis-trails-${data.aws_caller_identity.tfstate_current.account_id}"
    }
  ]
}
POLICY
}
