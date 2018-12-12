resource "aws_s3_bucket" "terrvis_log_bucket" {
  bucket = "terrvis-logs-${data.aws_caller_identity.tfstate_current.account_id}"
  force_destroy = true
  acl    = "log-delivery-write"
  lifecycle_rule {
    id      = "log"
    enabled = true
    prefix  = "log/"
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
}
