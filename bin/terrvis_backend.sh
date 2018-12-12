#!/usr/bin/env bash


# Create the terrvis backend file so that we can interact with the remote state
cat <<TERRVIS > ./terrvis_deploy/terrvis_backend.tf
terraform {
  backend "s3" {
    bucket = "terrvis-$(aws sts get-caller-identity --output text --query 'Account')"
    key = "${ENVIRONMENT_NAME}/terrvis.tfstate"
    region = "${REGION}"
    dynamodb_table = "terrvis-tfstate-lock-${ENVIRONMENT_NAME}"
    encrypt = "true"
  }
}
TERRVIS
