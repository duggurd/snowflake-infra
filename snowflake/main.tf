terraform {
  required_providers {
    snowflake = {
      source = "Snowflake-Labs/snowflake"
    }
  }
  # s3://homelab-tf-state-prod/snowflake-infra-sf
  backend "s3" {
    bucket = "homelab-tf-state-prod"
    profile = "duggurd"
    region = "eu-west-1"
  }
}

provider "snowflake" {
  account = "CR71697.west-europe.azure"
}
