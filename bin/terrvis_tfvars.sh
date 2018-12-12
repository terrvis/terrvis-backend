#!/usr/bin/env bash


# create environment tfvars for terrvis backend
cat <<TERRVIS > ./terrvis_deploy/environments/${ENVIRONMENT_NAME}.tfvars
environment_name = "${ENVIRONMENT_NAME}"
region = "${REGION}"
project_name = "${PROJECT_NAME}"
iam_pgp = "${IAM_PGP}"
TERRVIS
