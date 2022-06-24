data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "main" {

  statement {
    sid = "AllowCloudWatchLogs"

    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]

    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        format(
          "logs.%s.amazonaws.com",
          data.aws_region.current.name
        )
      ]
    }

    resources = ["*"]
  }

  statement {
    sid = "EnableIAMUserPermissions"

    actions = [
      "kms:*",
    ]

    effect = "Allow"

    principals {
      type = "AWS"

      identifiers = [
        format(
          "arn:%s:iam::%s:root",
          data.aws_partition.current.partition,
          data.aws_caller_identity.current.account_id
        )
      ]
    }

    resources = ["*"]
  }
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}

data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/scripts/init.cfg",
      {}
    )
  }
  # Base Userdata
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/scripts/userdata.sh",
      {
        debug = var.debug_script,
      }
    )
  }
  # Cloudwatch config
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/scripts/cwldata.sh",
      {
        log_group = join("", aws_cloudwatch_log_group.main.*.name),
        debug     = var.debug_script,
      }
    )
  }
  # Additional script
  part {
    content_type = "text/x-shellscript"
    content      = var.extra_script
  }
}
