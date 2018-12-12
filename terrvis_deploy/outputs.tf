output "account_id" {
  value = "${data.aws_caller_identity.testing_current.id}"
  description = "AWS Account ID"
}

output "bucket_name" {
  value = "${module.terrvis_backend.bucket_name}"
  description = "Terrvis managing S3 bucket name"
}

output "aws_access_id" {
  value = "${module.terrvis_backend.aws_access_id}"
}

output "aws_secret_key" {
  value = "${module.terrvis_backend.aws_secret_key}"
}

output "terrvis_backend_config" {
  value = "${module.terrvis_backend.terrvis_backend_config}"
}

output "terrvis_project_config" {
  value = "${module.terrvis_backend.terrvis_project_config}"
}

output "project_usage_description" {
  value = "${module.terrvis_backend.project_usage_description}"
}
