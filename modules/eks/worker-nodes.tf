#
# EKS Worker Nodes Resources
#  * EKS Node Group to launch worker nodes
#

resource "aws_launch_template" "eks" {
  name_prefix                   = "eks-${var.projectname}-${var.environment}"
  image_id                      = data.aws_ami.eks_worker_ami.id
  instance_type                 = var.instance_types 
  key_name                      = var.key_pair
  user_data                     = base64encode(local.eks_nodes_userdata) 

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

resource "aws_autoscaling_group" "eks" {
  force_delete                          = true
  health_check_grace_period             = 30
  health_check_type                     = "EC2"
  desired_capacity     			= var.countindex
  min_size                              = var.countindex 
  max_size                              = var.countindex +2
  vpc_zone_identifier                   = var.subnet_private_id

  launch_template {
    id                                  = aws_launch_template.eks.id
//    version                             = "$Latest"
    version                             = aws_launch_template.eks.latest_version
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
