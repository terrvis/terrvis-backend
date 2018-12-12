variable "region" {}
variable "environment_name" {}
variable "project_name" {}

variable "iam_pgp" {
    description = "Either use a keybase username, `keybase:<some_user>` or a base64 encoded string"
}
