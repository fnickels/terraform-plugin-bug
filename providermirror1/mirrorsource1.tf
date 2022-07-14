#see: https://www.terraform.io/language/providers/requirements
terraform {
  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "4.21.0"
    }
  }
}