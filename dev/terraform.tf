terraform {

  required_version = ">= 0.12"

  required_providers {
    aws      = ">= 2.31.0"
    local    = ">= 1.2"
    null     = ">= 2.1"
    template = ">= 2.1"
    random   = ">= 2.1"
  }

  backend "s3" {
    bucket  		= "s3-terraform-state-projectoo7"
    dynamodb_table 	= "dmdb-terraform-state-lock-projectoo7"
    key     		= "terraform.tfstate"
    region  		= "us-east-1"
    encrypt 		= "true"
    profile 		= "default"
  }
}
