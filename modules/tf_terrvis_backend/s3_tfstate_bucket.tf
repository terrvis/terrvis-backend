resource "aws_s3_bucket" "terrvis_tfstate_bucket" {
  bucket = "terrvis-${data.aws_caller_identity.tfstate_current.account_id}"
  acl    = "private"
  tags {
    Name = "terrvis-remote-tfstate-files"
  }
  versioning {
    enabled = true
  }
  lifecycle {
    prevent_destroy =  false
  }
  lifecycle_rule {
    prefix  = "/"
    enabled = true

    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    noncurrent_version_transition {
      days          = 60
      storage_class = "GLACIER"
    }
    noncurrent_version_expiration {
      days = 90
    }
  }
  logging {
    target_bucket = "${aws_s3_bucket.terrvis_log_bucket.id}"
    target_prefix = "log/"
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
