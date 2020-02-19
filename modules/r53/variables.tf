variable "projectname" {}

variable "environment" {}

variable "countindex" {}

variable "domainname" {
  type          = string
  default       = "sadoha.club"
  description   = "The name of current domain"
}

variable "subdomains" {  
  default = ["www", "mail", "cal", "docs"]
}

# Using these data sources allows the configuration to be
# generic for any region.
data "aws_region" "current" {}

data "aws_availability_zones" "available" {}
