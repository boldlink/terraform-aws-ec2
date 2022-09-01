[![Build Status](https://github.com/boldlink/terraform-aws-ec2/actions/workflows/pre-commit.yml/badge.svg)](https://github.com/boldlink/terraform-aws-ec2/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-ec2/actions/workflows/checkov.yml/badge.svg)](https://github.com/boldlink/terraform-aws-ec2/actions)

[<img src="https://avatars.githubusercontent.com/u/25388280?s=200&v=4" width="96"/>](https://boldlink.io)

# AWS EC2 Terraform module

## Description

This terraform module creates an EC2 Instance with a security group, Cloudwatch Log Group for EC2 detailed monitoring, KMS key to encrypt/decrypt the ebs volumes, and another KMS key for Log Group. Keypair and Instance IAM role creation is optional.

Examples available [here](https://github.com/boldlink/terraform-aws-ec2/tree/main/examples/)

## Usage
*NOTE*: These examples use the latest version of this module

```hcl
module "ec2_instance_minimum" {
  source            = "../../"
  name              = "minimum-example"
  ami               = data.aws_ami.amazon_linux.id
  instance_type     = "m5.large"
  availability_zone = data.aws_availability_zones.available.names[0]
  subnet_id         = data.aws_subnet.default.id
}
```

## Documentation

[AWS EC2 documentation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html)

[Terraform provider documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Third party software
This repository uses third party software:
* [pre-commit](https://pre-commit.com/) - Used to help ensure code and documentation consistency
  * Install with `brew install pre-commit`
  * Manually use with `pre-commit run`
* [terraform 0.14.11](https://releases.hashicorp.com/terraform/0.14.11/) For backwards compatibility we are using version 0.14.11 for testing making this the min version tested and without issues with terraform-docs.
* [terraform-docs](https://github.com/segmentio/terraform-docs) - Used to generate the [Inputs](#Inputs) and [Outputs](#Outputs) sections
  * Install with `brew install terraform-docs`
  * Manually use via pre-commit
* [tflint](https://github.com/terraform-linters/tflint) - Used to lint the Terraform code
  * Install with `brew install tflint`
  * Manually use via pre-commit

### Makefile
The makefile contained in this repo is optimized for linux paths and the main purpose is to execute testing for now.
* Create all tests:
`$ make tests`
* Clean all tests:
`$ make clean`

#### BOLDLink-SIG 2022
