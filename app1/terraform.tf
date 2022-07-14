# sane defaults
terraform {
  required_providers {
    # standard form
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = ">= 1.0"
    }
    external = {
      source  = "registry.terraform.io/hashicorp/external"
      version = ">= 1.0"
    }
  }
}
