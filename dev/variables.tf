#
# Variables Configuration
#

variable "projectname" {
  type    	= string
  default 	= "abc"
  description   = "The name of current project"
}

variable "environment" {
  type        	= string
  default     	= "dev"
  description 	= "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
}

variable "countindex" {
  type    	= string
  default 	= "3"
  description   = ""
}
