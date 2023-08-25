data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}

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

data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/scripts/init.cfg", {})
  }

  # Base Userdata
  part {
    content_type = "text/x-shellscript"
    content      = templatefile("${path.module}/scripts/userdata.sh", {})
  }

  # Cloudwatch config
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/scripts/cwldata.sh", {
      log_group = join("", aws_cloudwatch_log_group.main.*.name)
    })
  }

  # Additional script
  part {
    content_type = "text/x-shellscript"
    content      = var.extra_script
  }
}
