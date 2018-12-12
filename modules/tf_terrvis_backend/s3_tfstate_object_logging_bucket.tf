resource "aws_cloudtrail" "terrvis_tfstate_object_logging_bucket" {
  name                          = "terrvis-${var.environment_name}-${data.aws_caller_identity.tfstate_current.account_id}"
  depends_on                    = ["aws_s3_bucket.terrvis_tfstate_bucket"]
  s3_bucket_name                = "terrvis-trails-${data.aws_caller_identity.tfstate_current.account_id}"
  s3_key_prefix                 = "${var.environment_name}"
  include_global_service_events = true
  is_multi_region_trail         = false

  event_selector {
    read_write_type           = "All"
    include_management_events = false

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::terrvis-${data.aws_caller_identity.tfstate_current.account_id}/"]
    }
  }
}
