module "terrvis_backend" {
  source = "../modules/tf_terrvis_backend"
  region = "${var.region}"
  environment_name = "${var.environment_name}"
  project_name = "${var.project_name}"
  iam_pgp = "${var.iam_pgp}"
}

data "aws_caller_identity" "testing_current" {}
