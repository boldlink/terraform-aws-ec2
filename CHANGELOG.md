# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

- fix: CKV_AWS_79  Ensure Instance Metadata Service Version 1 is not enabled:: V1 is used for the examples
- Feature: Add Operating System flexibility in script (i.e download/install packages depending on OS flavor)
- Feat: pair different subnet IDs with their corresponding CIDRs for consistency in examples usage
- Feat: use vpc version to 3.0.2 in supporting resources
- fix: Ensure packages are installed without public IP

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

[Unreleased]: https://github.com/boldlink/terraform-aws-ec2/compare/1.2.1...HEAD
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
