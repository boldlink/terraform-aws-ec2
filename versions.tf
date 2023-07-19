terraform {
  required_version = ">= 0.14.11"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.0.0"
    }

    null = {
      source  = "hashicorp/null"
      version = ">= 3.0.0"
    }

    template = {
      source  = "hashicorp/template"
      version = ">= 2.0.0"
    }
  }
}
