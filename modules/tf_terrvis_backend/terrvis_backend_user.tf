resource "aws_iam_user" "terrvis_deploy_user" {
  name = "terrvis-deploy-${var.environment_name}"
  path = "/"
}

resource "aws_iam_access_key" "terrvis_backend_user_access_key" {
  user  = "${aws_iam_user.terrvis_deploy_user.name}"
  pgp_key = "keybase:${var.iam_pgp}"
}

resource "aws_iam_policy" "terrvis_s3_deploy_policy" {
  name        = "terrvis-s3-deploy-${var.environment_name}"
  description = "S3 Policy tailed for Terrvis services"

  policy = <<TERRVIS
{
  "Version": "2012-10-17",
  "Statement": [
  {
    "Sid": "TerrvisDeployS3Policy",
    "Effect": "Allow",
    "Action": [
    "s3:GetObjectVersionTagging",
    "s3:CreateBucket",
    "s3:GetObjectAcl",
    "s3:PutLifecycleConfiguration",
    "s3:GetObjectVersionAcl",
    "s3:PutBucketAcl",
    "s3:PutObjectTagging",
    "s3:DeleteObject",
    "s3:DeleteObjectTagging",
    "s3:GetBucketPolicyStatus",
    "s3:GetBucketWebsite",
    "s3:PutReplicationConfiguration",
    "s3:DeleteObjectVersionTagging",
    "s3:GetBucketNotification",
    "s3:PutBucketCORS",
    "s3:DeleteBucketPolicy",
    "s3:GetReplicationConfiguration",
    "s3:ListMultipartUploadParts",
    "s3:PutObject",
    "s3:GetObject",
    "s3:PutBucketNotification",
    "s3:PutBucketLogging",
    "s3:PutObjectVersionAcl",
    "s3:GetAnalyticsConfiguration",
    "s3:GetObjectVersionForReplication",
    "s3:GetLifecycleConfiguration",
    "s3:ListBucketByTags",
    "s3:GetInventoryConfiguration",
    "s3:GetBucketTagging",
    "s3:DeleteObjectVersion",
    "s3:GetBucketLogging",
    "s3:ListBucketVersions",
    "s3:RestoreObject",
    "s3:ListBucket",
    "s3:GetAccelerateConfiguration",
    "s3:GetBucketPolicy",
    "s3:PutEncryptionConfiguration",
    "s3:GetEncryptionConfiguration",
    "s3:GetObjectVersionTorrent",
    "s3:PutBucketTagging",
    "s3:GetBucketRequestPayment",
    "s3:GetObjectTagging",
    "s3:GetMetricsConfiguration",
    "s3:DeleteBucket",
    "s3:PutBucketVersioning",
    "s3:PutObjectAcl",
    "s3:GetBucketPublicAccessBlock",
    "s3:ListBucketMultipartUploads",
    "s3:PutObjectVersionTagging",
    "s3:GetBucketVersioning",
    "s3:GetBucketAcl",
    "s3:GetObjectTorrent",
    "s3:GetBucketCORS",
    "s3:PutBucketPolicy",
    "s3:GetBucketLocation",
    "s3:GetObjectVersion"
    ],
    "Resource": [
    "arn:aws:s3:::terrvis-*/*",
    "arn:aws:s3:::terrvis-*"
    ]
  }
  ]
}
TERRVIS
}

resource "aws_iam_policy" "terrvis_dynamodb_deploy_policy" {
  name = "terrvis-dynamodb-deploy-${var.environment_name}"
  description = "DynamoDB Policy tailed for Terrvis services"

  policy = <<TERRVIS
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "TerrvisDeployDynamoDBPolicy",
      "Effect": "Allow",
      "Action": [
        "dynamodb:BatchGetItem",
        "dynamodb:UpdateTimeToLive",
        "dynamodb:ConditionCheckItem",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem",
        "dynamodb:Scan",
        "dynamodb:Query",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteTable",
        "dynamodb:CreateTable",
        "dynamodb:DescribeTable",
        "dynamodb:GetItem",
        "dynamodb:DescribeContinuousBackups",
        "dynamodb:UpdateTable"
      ],
      "Resource": "arn:aws:dynamodb:*:*:table/terrvis-tfstate-*"
    },
    {
      "Sid": "TerrvisDeployDynamoDBPolicy1",
      "Effect": "Allow",
      "Action": [
        "dynamodb:TagResource",
        "dynamodb:UntagResource",
        "dynamodb:ListTables",
        "dynamodb:ListTagsOfResource",
        "dynamodb:DescribeTimeToLive",
        "dynamodb:DescribeLimits"
      ],
      "Resource": "*"
    }
  ]
}
TERRVIS
}

resource "aws_iam_policy" "terrvis_cloudtrail_deploy_policy" {
  name = "terrvis-cloudtrail-deploy-${var.environment_name}"
  description = "Cloudtrail Policy tailed for Terrvis services"

  policy = <<TERRVIS
{
  "Version": "2012-10-17",
  "Statement": [
  {
    "Sid": "TerrvisDeployCloudTrailPolicy",
    "Effect": "Allow",
    "Action": [
    "cloudtrail:LookupEvents",
    "cloudtrail:PutEventSelectors",
    "cloudtrail:StopLogging",
    "cloudtrail:StartLogging",
    "cloudtrail:UpdateTrail",
    "cloudtrail:GetTrailStatus",
    "cloudtrail:GetEventSelectors",
    "cloudtrail:DescribeTrails",
    "cloudtrail:AddTags",
    "cloudtrail:ListPublicKeys",
    "cloudtrail:DeleteTrail",
    "cloudtrail:CreateTrail",
    "cloudtrail:ListTags",
    "cloudtrail:RemoveTags"
    ],
    "Resource": "*"
  }
  ]
}
TERRVIS
}

resource "aws_iam_policy" "terrvis_iam_deploy_policy" {
  name = "terrvis-iam-deploy-${var.environment_name}"
  description = "IAM Policy tailed for Terrvis services"

  policy = <<TERRVIS
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "TerrvisDeployIAMPolicy",
      "Effect": "Allow",
      "Action": [
        "iam:GetPolicyVersion",
        "iam:GetPolicy",
        "iam:GetUserPolicy",
        "iam:ListAttachedUserPolicies",
        "iam:GetUser",
        "iam:ListAccessKeys"
      ],
      "Resource": "*"
    }
  ]
}
TERRVIS
}

resource "aws_iam_user_policy_attachment" "terrvis_s3_deploy_attach_policy" {
  user       = "${aws_iam_user.terrvis_deploy_user.name}"
  policy_arn = "${aws_iam_policy.terrvis_s3_deploy_policy.arn}"
}

resource "aws_iam_user_policy_attachment" "terrvis_dynamodb_deploy_attach_policy" {
  user       = "${aws_iam_user.terrvis_deploy_user.name}"
  policy_arn = "${aws_iam_policy.terrvis_dynamodb_deploy_policy.arn}"
}

resource "aws_iam_user_policy_attachment" "terrvis_cloudtrail_attach_deploy_attach_policy" {
  user       = "${aws_iam_user.terrvis_deploy_user.name}"
  policy_arn = "${aws_iam_policy.terrvis_cloudtrail_deploy_policy.arn}"
}

resource "aws_iam_user_policy_attachment" "terrvis_iam_attach_deploy_attach_policy" {
  user       = "${aws_iam_user.terrvis_deploy_user.name}"
  policy_arn = "${aws_iam_policy.terrvis_iam_deploy_policy.arn}"
}
