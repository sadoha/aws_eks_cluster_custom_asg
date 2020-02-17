// Amazon Virtual Private Cloud

module "vpc" {
  source                        = "../modules/vpc"
  projectname                   = "${var.projectname}"
  environment                  	= "${var.environment}"
  countindex                 	= "${var.countindex}"
}

// Amazon Key Pairs
module "key" {
  source                        = "../modules/key"
  projectname                   = "${var.projectname}"
  environment                  	= "${var.environment}"
  countindex                 	= "${var.countindex}"
}

// Amazon Elastic Kubernetes Service
module "eks" {
  source                        = "../modules/eks"
  projectname                   = "${var.projectname}"
  environment                   = "${var.environment}"
  countindex                    = "${var.countindex}"
  vpc_id			= "${module.vpc.vpc_id}"
  subnet_private_id		= "${module.vpc.subnet_private_id}"
  key_pair			= "${module.key.key_pair_id}"
}

// Amazon CloudWatch
module "cloudwatch" {
  source                        = "../modules/cloudwatch"
  projectname                   = "${var.projectname}"
  environment                  	= "${var.environment}"
  countindex                 	= "${var.countindex}"
  autoscaling_groups_name	= "${module.eks.autoscaling_groups_name}"
}
