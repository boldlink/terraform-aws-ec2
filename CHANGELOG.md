# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

- fix: investigate why windows instance is not showing under ssm target instances though role is properly configured
- feat: add cloud-init script for creating windows os SSM user when enabled.
- feat: Allow the input of a custom awslogs.json configuration file on cwldata.sh installation`
- feat: Add support for installation and configuration of cloudwatch agent on Windows instances, see doc [here](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/install-CloudWatch-Agent-commandline-fleet.html).
- feat: Implement least privilege principle for managed `AmazonSSMManagedInstanceCore` and other module IAM policies
- feat: Separate the installation process of ssm agent and cloudwatch agent
- feat: pair different subnet IDs with their corresponding CIDRs for consistency in examples usage
- fix: Ensure packages are installed without public IP
- feat: Include ssm installation option for windows instances
- fix: CKV_AWS_290: "Ensure IAM policies does not allow write access without constraints"
- fix: CKV_AWS_355: "Ensure no IAM policies documents allow "*" as a statement's resource for restrictable actions"
- showcase the following ec2 options: ipv6_addresses, ipv6_address_count, amd_sev_snp in cpu_options in complete example

## [2.0.6] - 2024-03-18
- fix checkov alert in complete example: CKV2_AWS_5: "Ensure that Security Groups are attached to another resource"

## [2.0.5] - 2024-02-02
- fix: CKV2_AWS_5: "Ensure that Security Groups are attached to another resource

## [2.0.4] - 2023-11-16
- fix: added more attributes to dynamic ingress and egress to allow full control of traffic flow

## [2.0.3] - 2023-11-03
- fix: added iam role outputs
- fix: removed iam_policy to be added outside using iam_policy module
- added an example external policy to the complete example

## [2.0.2] - 2023-10-30
- fix: module's security group creation option
- added an external security group in the complete example to allow ssm connection
- added example ingress and egress rules to windows example

## [2.0.1] - 2023-10-16
- fix: network interfaces dynamic block
- fix: security group output
- ec2 network interface and placement group examples
- ec2 instance example created from a launch template and contains a user_data_base64 script
- set install_ssm_agent to be false by default

##  [2.0.0] - 2023-07-19
### Changes
- feat: Added ssm support and removed key pair creation for different linux distros
- feat: Add Operating System flexibility in script (i.e download/install packages depending on OS flavor)
- feat: Updated module to use dynamic `cpu_options` block from the previous `cpu_core_count` and `cpu_threads_per_core` arguments which are now deprecated.

##  [1.2.2] - 2023-04-13
### Changes
- fix: CKV2_AWS_57: "Ensure Secrets Manager secrets should have automatic rotation enabled"
- updated supporting resource VPC to version 3.0.3
- Moved static values to variables.tf file

##  [1.2.1] - 2023-02-03
### Changes
- fix: CKV_AWS_88: EC2 instance should not have public IP.
- fix: CKV_AWS_8 :Ensure all data stored in the Launch configuration or instance Elastic Blocks Store is securely encrypted

## [1.2.0] - 2023-01-10
### Changes
- fix: CKV_AWS_149 #Ensure that Secrets Manager secret is encrypted using KMS CMK
- fix: CKV_AWS_158 #Ensure that CloudWatch Log Group is encrypted by KMS
- feat: Use only one CMK for encryption in the module
- Added new github workflow files & config files.

## [1.1.9] - 2022-09-02
### Changes
- fix: CKV_AWS_79  Ensure Instance Metadata Service Version 1 is not enabled:: V1 is used for the examples

## [1.1.8] - 2022-08-24
### Changes
- fix: CKV_AWS_135 Ensure that EC2 is EBS optimized
- fix: CKV_AWS_24 Ensure no security groups allow ingress from 0.0.0.0:0 to port 22

## [1.1.7] - 2022-08-04
### Changes
- Fix: pre-commit link

## [1.1.6] - 2022-07-27
### Changes
- Fix: CKV_AWS_111 #Ensure IAM policies does not allow write access without constraints
- Fix: CKV_AWS_109 #Ensure IAM policies does not allow permissions management / resource exposure without constraints
- feat: Add supporting resources (vpc; kms) to be built once and used by all examples to minimize resource duplication during testing.
- feat: Add supporting resources to makefile.
- feat: Allow the makefile to also clean local terraform state files.

## [1.1.5] - 2022-06-21
### Changes
- Fix: Userdata partial success (some packages not installing) specifically cloudwatch agent
- Added required permissions for agent to send logs and metrics to cloudwatch

## [1.1.4] - 2022-06-10
### Changes
- Restructed examples
- Added the `.github/workflow` folder
- Added `CHANGELOG.md`
- Added `CODEOWNERS`
- Added `versions.tf`, which is important for pre-commit checks
- Added `Makefile` for examples automation
- Added `.gitignore` file

## [1.1.3] - 2022-04-28
### Changes
- Restructed examples

## [1.1.2] - 2022-04-28
### Changes
- Removed sensitive values feature from outputs
- Modified module source

## [1.1.1] - 2022-04-12
### Changes
- Feature: Logging
- Feature: Encryption
- Feature: Security Group
- Feature: Instance profile
- Feature: Network_interface
- Feature: Metadata_options

## [1.0.1] - 2022-02-17
### Changes
- Restructed examples
- Added key pair creation

## [1.0.0] - 2022-02-17
- Initial commit

[Unreleased]: https://github.com/boldlink/terraform-aws-ec2/compare/2.0.5...HEAD

[2.0.5]: https://github.com/boldlink/terraform-aws-ec2/releases/tag/2.0.5
[2.0.4]: https://github.com/boldlink/terraform-aws-ec2/releases/tag/2.0.4
[2.0.3]: https://github.com/boldlink/terraform-aws-ec2/releases/tag/2.0.3
[2.0.2]: https://github.com/boldlink/terraform-aws-ec2/releases/tag/2.0.2
[2.0.1]: https://github.com/boldlink/terraform-aws-ec2/releases/tag/2.0.1
[2.0.0]: https://github.com/boldlink/terraform-aws-ec2/releases/tag/2.0.0
[1.2.2]: https://github.com/boldlink/terraform-aws-ec2/releases/tag/1.2.2
[1.2.1]: https://github.com/boldlink/terraform-aws-ec2/releases/tag/1.2.1
[1.2.0]: https://github.com/boldlink/terraform-aws-ec2/releases/tag/1.2.0
[1.1.9]: https://github.com/boldlink/terraform-aws-ec2/releases/tag/1.1.9
[1.1.8]: https://github.com/boldlink/terraform-aws-ec2/releases/tag/1.1.8
[1.1.7]: https://github.com/boldlink/terraform-aws-ec2/releases/tag/1.1.7
[1.1.6]: https://github.com/boldlink/terraform-aws-ec2/releases/tag/1.1.6
[1.1.5]: https://github.com/boldlink/terraform-aws-ec2/releases/tag/1.1.5
[1.1.4]: https://github.com/boldlink/terraform-aws-ec2/releases/tag/1.1.4
[1.1.3]: https://github.com/boldlink/terraform-aws-ec2/releases/tag/1.1.3
[1.1.2]: https://github.com/boldlink/terraform-aws-ec2/releases/tag/1.1.2
[1.1.1]: https://github.com/boldlink/terraform-aws-ec2/releases/tag/1.1.1
[1.0.1]: https://github.com/boldlink/terraform-aws-ec2/releases/tag/1.0.1
[1.0.0]: https://github.com/boldlink/terraform-aws-ec2/releases/tag/1.0.0
