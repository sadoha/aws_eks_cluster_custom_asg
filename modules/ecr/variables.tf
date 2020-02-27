variable "projectname" {}

variable "environment" {}

variable "countindex" {}

variable "ecr_repository_name" {
  type        	= string
  default       = "default"
  description 	= "ECR Repository name"
}

variable "max_image_count" {
  type        	= string
  description 	= "How many Docker Image versions AWS ECR will store"
  default     	= 10
}

# Using these data sources allows the configuration to be
# generic for any region.
data "aws_region" "current" {}

data "aws_availability_zones" "available" {}
