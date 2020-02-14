#
# CloudWatch Metric
#

# To view metrics for your instances, for Display, 
# choose EC2. To get a larger view of a single metric, 
# select its graph. The following metrics are available for instances:

# CPU Utilization — CPUUtilization
# Disk Reads — DiskReadBytes
# Disk Read Operations — DiskReadOps
# Disk Writes — DiskWriteBytes
# Disk Write Operations — DiskWriteOps
# Network In — NetworkIn
# Network Out — NetworkOut
# Status Check Failed (Any) — StatusCheckFailed
# Status Check Failed (Instance) — StatusCheckFailed_Instance
# Status Check Failed (System) — StatusCheckFailed_System

resource "aws_autoscaling_policy" "heavy_out" {
  name 					= "heavy-out-asg-policy"
  scaling_adjustment 			= 1
  adjustment_type 			= "ChangeInCapacity"
  cooldown 				= 10
  autoscaling_group_name 		= var.autoscaling_groups_name
}

resource "aws_autoscaling_policy" "heavy_in" {
  name 					= "heavy-in-asg-policy"
  scaling_adjustment 			= -1
  adjustment_type 			= "ChangeInCapacity"
  cooldown 				= 10
  autoscaling_group_name 		= var.autoscaling_groups_name
}

resource "aws_cloudwatch_metric_alarm" "heavy_asg_cpu_usage_is_very_high" {
  alarm_name 				= "heavy-asg-cpu-usage-is-very-high"
  comparison_operator 			= "GreaterThanOrEqualToThreshold"
  evaluation_periods 			= 1
  metric_name 				= "CPUUtilization"
  namespace 				= "AWS/EC2"
  period 				= 60
  statistic 				= "Average"
  threshold 				= 80

  dimensions = { 
    AutoScalingGroupName 		= var.autoscaling_groups_name
  }

  alarm_description 			= "This metric monitors EC2 CPU utilization"
  alarm_actions 			= ["${aws_autoscaling_policy.heavy_out.arn}"]

  tags = map(
    "Name", "eks-${var.projectname}-${var.environment}",
    "Environment", "${var.environment}",
    "Terraformed", "true",
    "kubernetes.io/cluster/cluster-${var.projectname}-${var.environment}", "owned",
  )
}

resource "aws_cloudwatch_metric_alarm" "heavy_asg_cpu_usage_is_very_low" {
  alarm_name 				= "heavy-asg-cpu-usage-is-very-low"
  comparison_operator 			= "LessThanOrEqualToThreshold"
  evaluation_periods 			= 1
  metric_name 				= "CPUUtilization"
  namespace 				= "AWS/EC2"
  period 				= 60
  statistic 				= "Average"
  threshold 				= 20 

  dimensions = {
    AutoScalingGroupName 		= var.autoscaling_groups_name
  }

  alarm_description 			= "This metric monitors EC2 CPU utilization"
  alarm_actions 			= ["${aws_autoscaling_policy.heavy_in.arn}"]

  tags = map(
    "Name", "eks-${var.projectname}-${var.environment}",
    "Environment", "${var.environment}",
    "Terraformed", "true",
    "kubernetes.io/cluster/cluster-${var.projectname}-${var.environment}", "owned",
  )
}
