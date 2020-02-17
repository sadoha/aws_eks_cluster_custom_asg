#
# EKS Worker Nodes Resources
#  * EKS Node Group to launch worker nodes
#

data "template_file" "eks_nodes_userdata" {
  template = "${file("templates/eks_nodes_userdata.tpl")}"

  vars = {
    clusterEndpoint            	= aws_eks_cluster.cluster.endpoint
    clusterCertificateAuthority	= aws_eks_cluster.cluster.certificate_authority.0.data
    clusterName               	= aws_eks_cluster.cluster.name
    kubletExtraArgs             = var.kublet_extra_args
  }
}

resource "aws_launch_template" "eks" {
  name_prefix                   = "eks-${var.projectname}-${var.environment}"
  image_id                      = data.aws_ami.eks_worker_ami.id
  instance_type                 = var.instance_types 
  key_name                      = var.key_pair
  user_data                     = "${base64encode(data.template_file.eks_nodes_userdata.rendered)}"

  iam_instance_profile {
    name                        = aws_iam_instance_profile.nodes.name
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      delete_on_termination     = true
      encrypted                 = true
      iops                      = var.iops
      volume_type               = var.volume_type
      volume_size               = var.volume_size
    }
  }

  network_interfaces {
    associate_public_ip_address = false 
    delete_on_termination       = true
    security_groups             = [aws_security_group.nodes.id]
  }

  credit_specification {
    cpu_credits                 = "standard"
  }

  monitoring {
    enabled                     = true
  }

  lifecycle {
    create_before_destroy       = true
  }

  tag_specifications {
    resource_type               = "instance"

    tags = map(
      "Name", "eks-${var.projectname}-${var.environment}",
      "Environment", "${var.environment}",
      "Terraformed", "true",
      "kubernetes.io/cluster/cluster-${var.projectname}-${var.environment}", "owned",
      "Snapshot", "${var.environment}",
    )
  }

  tag_specifications {
    resource_type               = "volume"

    tags = map(
      "Name", "eks-${var.projectname}-${var.environment}",
      "Environment", "${var.environment}",
      "Terraformed", "true",
      "kubernetes.io/cluster/cluster-${var.projectname}-${var.environment}", "owned",
      "Snapshot", "${var.environment}",
    )

  }

  tags = map(
    "Name", "eks-${var.projectname}-${var.environment}",
    "Environment", "${var.environment}",
    "Terraformed", "true",
    "kubernetes.io/cluster/cluster-${var.projectname}-${var.environment}", "owned",
  )
}


resource "aws_lb_target_group" "eks" {
  name                          = "eks-${var.projectname}-${var.environment}"
  protocol                      = "TCP"
  port                          = "22"
  vpc_id                        = var.vpc_id

  tags = map(
    "Name", "cluster-eks-cluster-${var.projectname}-${var.environment}",
    "Environment", "${var.environment}",
    "Terraformed", "true",
    "kubernetes.io/cluster/cluster-${var.projectname}-${var.environment}", "owned",
  )
}


resource "aws_autoscaling_group" "eks" {
  target_group_arns                     = ["${aws_lb_target_group.eks.arn}"]
  force_delete                          = true
  health_check_grace_period             = 30
  health_check_type                     = "EC2"
  desired_capacity     			= var.countindex
  min_size                              = var.countindex 
  max_size                              = var.countindex +2
  vpc_zone_identifier                   = var.subnet_private_id

  launch_template {
    id                                  = "${aws_launch_template.eks.id}"
    version                             = "${aws_launch_template.eks.latest_version}"
  }

  lifecycle {
    create_before_destroy               = true
  }

  tag {
    key                         	= "Name"
    value                       	= "eks-${var.projectname}-${var.environment}"
    propagate_at_launch         	= true
  }

  tag {
    key                         	= "kubernetes.io/cluster/${aws_eks_cluster.cluster.name}"
    value                       	= "owned"
    propagate_at_launch         	= true
  }
}
