terraform {
  # s3://homelab-tf-state-prod/snowflake-infra-aws
  backend "s3" {
    bucket = "homelab-tf-state-prod"
    profile = "duggurd"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
  profile = "duggurd"
}