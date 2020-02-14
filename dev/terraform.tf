terraform {
  backend "s3" {
    bucket  		= "s3-terraform-state-projectoo7"
    dynamodb_table 	= "dmdb-terraform-state-lock-projectoo7"
    key     		= "terraform.tfstate"
    region  		= "us-east-1"
    encrypt 		= "true"
    profile 		= "default"
  }
}
