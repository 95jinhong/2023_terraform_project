terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.4.0"
    }
  }

  required_version = ">= 1.4"
}

provider "aws" {
  region= "ap-northeast-2"
  shared_config_files = ["/Users/hong.park/.aws/config"]
  shared_credentials_files = ["/Users/hong.park/.aws/credentials"]
  profile = "terraform"
}
