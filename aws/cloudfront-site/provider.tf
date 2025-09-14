terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 5.43"
      configuration_aliases = [aws, aws.acm]
    }
  }
}
