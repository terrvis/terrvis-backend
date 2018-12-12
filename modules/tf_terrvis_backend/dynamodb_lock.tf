resource "aws_dynamodb_table" "terrvis_lock" {
  name           = "terrvis-tfstate-lock-${var.environment_name}"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    Name        = "Terrvis tfstate lock table"
    Environment = "${var.environment_name}"
  }
}
