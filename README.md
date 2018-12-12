# Terrvis Backend
[![forthebadge](https://forthebadge.com/images/badges/uses-badges.svg)](https://forthebadge.com)
[![forthebadge](https://forthebadge.com/images/badges/60-percent-of-the-time-works-every-time.svg)](https://forthebadge.com)

The name `Terrvis` derives from the combination of `Terraform` and `TravisCI`.  This project is designed to allow all deployments to be managed/deployed by `TravisCI` upon commit to the git `master` branch

This project builds the backbone infrastructure required to manage Terraform with a remote backend.  Terraform state files are managed in S3 while DynamoDB manage the LockID to maintain consistency.  By using a remote backend, you can help preserve consistency between deployments when multiple engineers are at play.  This doesn't prevent stupid from doing bad things but it does help mitigate problems.

You find that Terrvis-Backend will create various mission critical pieces for this backend.

* DynamoDB :: Used to maintain the projects `tfstate` LockID
* S3 tfstate Bucket :: Used to store this and expansion Terrvis projects `tfstate` files
* S3 tfstate Log Bucket :: All S3 transactions against the `tfstate` bucket will be logged here
* S3 cloudtrail Bucket :: All API transactions against the `tfstate` bucket will be stored here
* CloudTrail :: All API transactions against the `tfstate` bucket will be logged to CloudTrail
* IAM User :: IAM deploy user
* IAM Policy S3 :: Limited IAM policy for interacting with S3
* IAM Policy DynamoDB :: Limited DynamoDB policy for interacting with DynamoDB
* IAM Policy Cloudtrail :: Full Cloudtrail policy to manage Cloudtrail

# Table of contents

- [Terrvis Backend](#terrvis-backend)
- [Table of contents](#table-of-contents)
- [Usage](#usage)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Uninstallation](#uninstallation)
  - [Features](#features)
- [Authors](#authors)
  - [Contributing](#contributing)
- [License](#license)
- [Versioning](#versioning)

# Usage
[(Back to top)](#table-of-contents)

Setting up the project takes a couple of minutes.  The initial setup requires manual steps on the local environment.  After the initial setup you'll be able to move the `tfstate` to your newly created backend.  To start, make sure you've installed the [Prerequesits](#prerequesits).

## Prerequisites
[(Back to top)](#table-of-contents)

* `aws account` :: Your AWS Account
* `awscli` :: Used to collect the AWS account number when generating the backend config file.
* `Terraform` :: Used to deploy the AWS Services
* `TravisCI` :: Used to automate the deploy process
* `Keybase` :: Used to decrypt your IAM users access key

## Installation
[(Back to top)](#table-of-contents)

The initial configuration will require you to apply the terraform configs.  After creating it, you'll create a backend tf config file.  To sync to your new backend, you'll need to run `terraform init` again.  This will prompt you to move the required details to AWS S3

First, lets set our required environment variables.

```sh
$ export ENVIRONMENT_NAME=development
$ export REGION=us-east-1
$ export PROJECT_NAME=terrvis-deploy
$ export IAM_PGP=${YOUR_KEYBASE_USERNAME}
```

**NOTE** This is assuming you have a default or active AWS IAM user configured

```sh
$ git clone https://github.com/terrvis/terrvis-backend.git
$ cd terrvis-backend
$ make terrvis_tfvars # assuming the default AWS IAM User
$ cd terrvis_deploy
$ terraform init
$ terraform plan -var-file=./environments/${ENVIRONMENT_NAME}.tfvars # View the changes
$ terraform apply -var-file=./environments/${ENVIRONMENT_NAME}.tfvars # Apply the changes if you agree
```

At this point, you've deployed Terrvis to your AWS account.  First, we will want to decrypt the AWS Access Key so that you can configure your access points with these credentials.  This would also be suggested for using with TravisCI.

To see what this is doing under the hood, here are the commands.  Do this from the `terrvis_deploy` directory.

```sh
$ cd terrvis_deploy # ${PROJECT_ROOT}/terrvis_deploy
$ terraform output aws_access_id
# Since we use keybase to encrypt the secret key output, we can use it to decrypt the output for
# consumption.
$ terraform output aws_secret_key | base64 --decode | keybase pgp decrypt
```

Use this time to take the above output and save it to you aws config profile and use this user moving forward.

With your profile created, the next steps are for us to deploy the tfstate to your newly created backend. From the project root directory:

```sh
# ${PROJECT_ROOT}/
# With your AWS profile activated
$ make terrvis_backend
```

This generates a file inside of `terrvis_deploy` that tell Terraform to connect to a backend.  Finally, we finish this up.  From the `terrvis_deploy` directory:

```sh
# ${PROJECT_ROOT}/terrvis_deploy
$ terraform init # This will prompt you to move your backend to S3
$ terraform plan -var-file=./environments/${ENVIRONMENT_NAME}.tfvars # View the changes
$ terraform apply -var-file=./environments/${ENVIRONMENT_NAME}.tfvars # Apply the changes if you agree
```

Finally, the whole point of this is to be able to manage other projects with Terraform while having S3 and DynamoDB manage the tfstate and lock hash.  You can use the `terraform output` to generate that config.  Take this output and save it to a file in the same directory as your other projects where the `main.tf` file is.

```sh
$ terraform output terrvis_project_config
terraform {
  backend "s3" {
    bucket = "terrvis-000000000000"
    key = "development/${PROJECT_NAME}/terrvis-project.tfstate"
    region = "us-east-1"
    dynamodb_table = "terrvis-tfstate-lock-development"
    encrypt = "true"
  }
}
```

## Uninstallation
[(Back to top)](#table-of-contents)

To delete Terrvis infrastructure from your account, just run the `delete` command.  Please note that some resources are protected, mostly out of design.  The Terrvis backend S3 buckets will not be deleted, this is to prevent loss of files for other projects that rely on the Terrvis backend.

```sh
$ terraform destroy -var-file=./environments/${ENVIRONMENT_NAME}.tfvars
```

## Features
[(Back to top)](#table-of-contents)

Terrvis Backend generates a number of resources that are specific Terrvis Deploy.  These resources are designed to only interact with itself where Policy files allow.

* Aws Iam User
  * Access Id
  * Secret Access Key
* Aws Policy File
  * Iam
  * DynamoDB
  * S3
  * CloudTrail
* S3 Buckets
  * Bucket to store tfstate files
    * Versioning
    * Lifecycle rotation of non-active versions
    * Logging
    * Cloudtrail events
  * Log bucket for all transactions against the tfstate bucket
    * Lifecycle rotation of all objects
  * Cloudtrail bucket for all api accesses against the tfstate bucket
    * Lifecycle rotation of all objects
* DynamoDB
  * Table to manage the `LockID` of every tfstate file stored with this process
* Cloudtrail
  * Event logging for S3 events made against the Terrvis buckets

# Authors
[(Back to top)](#table-of-contents)

* **Johnny Martin** - *Initial work* - [iamjohnnym](https://github.com/terrvis/terrvis-backend)

See also the list of [contributors](https://github.com/terrvis/terrvis-backend/contributors) who participated in this project.

## Contributing
[(Back to top)](#table-of-contents)

Your contributions are always welcome! Please have a look at the [contribution guidelines](.github/CONTRIBUTING.md) first.

# License
[(Back to top)](#table-of-contents)

Apache License, Version 2.0 2018 - [Johnny Martin](https://github.com/terrvis/terrvis-backend). Please have a look at the [LICENSE.md](LICENSE.md) for more details.

# Versioning
[(Back to top)](#table-of-contents)

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/terrvis/terrvis-backend/tags).
