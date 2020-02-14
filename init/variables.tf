variable "name" {
  default = "projectoo7"
  description = "The name of project"
}

variable "region" {
  description = "Region that the instances will be created"
  default = "us-east-1"
}

variable "profile" {
  description = "The profile you want to use"
  default     = "default"
}

variable "tfstate_file_name" {
  description = "The name of tfstate file"
  default = "terraform.tfstate"
}
