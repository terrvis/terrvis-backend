provider "aws" {
  region = "${var.region}"
}

data "aws_caller_identity" "tfstate_current" {}
