// Amazon Virtual Private Cloud

module "vpc" {
  source                        = "../modules/vpc"
  projectname                   = "${var.projectname}"
  environment                  	= "${var.environment}"
  countindex                 	= "${var.countindex}"
}

// Amazon Key Pairs
module "key_pair" {
  source                        = "../modules/key_pair"
  projectname                   = "${var.projectname}"
  environment                  	= "${var.environment}"
  countindex                 	= "${var.countindex}"
}

// Amazon Certificate Manager
module "ssl" {
  source                        = "../modules/ssl"
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
  key_pair			= "${module.key_pair.key_pair_id}"
}

// Amazon CloudWatch
module "cloudwatch" {
  source                        = "../modules/cloudwatch"
  projectname                   = "${var.projectname}"
  environment                  	= "${var.environment}"
  countindex                 	= "${var.countindex}"
  autoscaling_groups_name	= "${module.eks.autoscaling_groups_name}"
}

// An example of default configuration environment inside of cloud 
module "k8s" {
  source                        = "../modules/k8s"
  projectname                   = "${var.projectname}"
  environment                   = "${var.environment}"
  countindex                    = "${var.countindex}"
  kubeconfig			= "${module.eks.kubeconfig_filename}"
}

// Amazon Route 53
module "r53" {
  source                        = "../modules/r53"
  projectname                   = "${var.projectname}"
  environment                   = "${var.environment}"
  countindex                    = "${var.countindex}"
}

// Elastic Container Registry Repository
module "ecr" {
  source                        = "../modules/ecr"
  projectname                   = "${var.projectname}"
  environment                   = "${var.environment}"
  countindex                    = "${var.countindex}"
}

