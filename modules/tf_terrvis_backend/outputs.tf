output "bucket_name" {
  value = "${aws_s3_bucket.terrvis_tfstate_bucket.id}"
  description = "Terrvis Managing S3 Bucket"
}

output "account_id" {
  value = "${data.aws_caller_identity.tfstate_current.account_id}"
  description = "AWS Account ID"
}

output "aws_access_id" {
  value = "${aws_iam_access_key.terrvis_backend_user_access_key.id}"
}

output "aws_secret_key" {
  value = "${aws_iam_access_key.terrvis_backend_user_access_key.encrypted_secret}"
}

output "terrvis_backend_config" {
  value = <<CONTENT
terraform {
  backend "s3" {
    bucket = "${aws_s3_bucket.terrvis_tfstate_bucket.id}"
    key = "${var.environment_name}/terrvis.tfstate"
    region = "${var.region}"
    dynamodb_table = "${aws_dynamodb_table.terrvis_lock.id}"
    encrypt = "true"
  }
}
CONTENT
  description = "Terrvis metadata to be placed in primary main.tf"
}

output "terrvis_project_config" {
  value = <<CONTENT
terraform {
  backend "s3" {
    bucket = "${aws_s3_bucket.terrvis_tfstate_bucket.id}"
    key = "${var.environment_name}/${var.project_name}/terrvis-project.tfstate"
    region = "${var.region}"
    dynamodb_table = "${aws_dynamodb_table.terrvis_lock.id}"
    encrypt = "true"
  }
}
CONTENT
  description = "Terrvis metadata to be placed in primary main.tf"
}

output "project_usage_description" {
  value = <<CONTENT
Add the following into a .tf file in the same location as the working main.tf file.
Suggested action: terraform output project_usage_description > ../${var.environment_name}_${var.project_name}_terrvis_backend.tf
CONTENT
}
