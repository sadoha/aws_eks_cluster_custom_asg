#
# Outputs
#

output "vpc_id" {
  value = aws_vpc.eks.id
}

output "subnet_private_id" {
  value = aws_subnet.subnet_private.*.id
}
