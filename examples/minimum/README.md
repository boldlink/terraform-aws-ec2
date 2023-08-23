[![License](https://img.shields.io/badge/License-Apache-blue.svg)](https://github.com/boldlink/terraform-aws-ec2/blob/main/LICENSE)
[![Latest Release](https://img.shields.io/github/release/boldlink/terraform-aws-ec2.svg)](https://github.com/boldlink/terraform-aws-ec2/releases/latest)
[![Build Status](https://github.com/boldlink/terraform-aws-ec2/actions/workflows/update.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-ec2/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-ec2/actions/workflows/release.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-ec2/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-ec2/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-ec2/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-ec2/actions/workflows/pr-labeler.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-ec2/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-ec2/actions/workflows/module-examples-tests.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-ec2/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-ec2/actions/workflows/checkov.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-ec2/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-ec2/actions/workflows/auto-badge.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-ec2/actions)

[<img src="https://avatars.githubusercontent.com/u/25388280?s=200&v=4" width="96"/>](https://boldlink.io)

# Terraform module example of minimum configuration


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.11 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.13.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2_instance_minimum"></a> [ec2\_instance\_minimum](#module\_ec2\_instance\_minimum) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ami.amazon_linux](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.supporting](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_architecture"></a> [architecture](#input\_architecture) | The architecture of the instance to launch | `string` | `"x86_64"` | no |
| <a name="input_ebs_optimized"></a> [ebs\_optimized](#input\_ebs\_optimized) | If true, the launched EC2 instance will be EBS-optimized | `bool` | `true` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type to use for the instance. Updates to this field will trigger a stop/start of the EC2 instance | `string` | `"t3.small"` | no |
| <a name="input_monitoring"></a> [monitoring](#input\_monitoring) | If true, the launched EC2 instance will have detailed monitoring enabled which pulls every 1m and adds additonal cost, default monitoring doesn't add costs | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the stack | `string` | `"minimum-ec2-example"` | no |
| <a name="input_root_block_device"></a> [root\_block\_device](#input\_root\_block\_device) | Configuration block to customize details about the root block device of the instance. | `list(any)` | <pre>[<br>  {<br>    "encrypted": true,<br>    "volume_size": 15<br>  }<br>]</pre> | no |
| <a name="input_supporting_resources_name"></a> [supporting\_resources\_name](#input\_supporting\_resources\_name) | Name of supporting resource VPC | `string` | `"terraform-aws-ec2"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to assign to the resource. Note that these tags apply to the instance and not block storage devices. | `map(string)` | <pre>{<br>  "Department": "DevOps",<br>  "Environment": "example",<br>  "InstanceScheduler": true,<br>  "LayerId": "Example",<br>  "LayerName": "Example",<br>  "Owner": "Boldlink",<br>  "Project": "Examples",<br>  "user::CostCenter": "terraform-registry"<br>}</pre> | no |

## Outputs

No outputs.
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

#### BOLDLink-SIG 2023
