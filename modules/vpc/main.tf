#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#  * NAT Gateway
#

resource "aws_vpc" "eks" {
  cidr_block = "172.16.0.0/16" 

  tags = map(
    "Name", "eks-${var.projectname}-${var.environment}",
    "Environment", "${var.environment}",
    "Terraformed", "true",
    "kubernetes.io/cluster/cluster-${var.projectname}-${var.environment}", "shared",
  )
}

#
# The configuration of a public subnet for EKS cluster 
#

resource "aws_subnet" "subnet_public" {
  count = var.countindex

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "172.16.1${count.index}.0/24"
  vpc_id            = aws_vpc.eks.id

  tags = map(
    "Name", "eks-public-${data.aws_availability_zones.available.names[count.index]}-${var.projectname}-${var.environment}",
    "Environment", "${var.environment}",
    "Terraformed", "true",
    "kubernetes.io/role/internal-elb", "1",
    "kubernetes.io/cluster/cluster-${var.projectname}-${var.environment}", "shared",
  )
}

resource "aws_internet_gateway" "eks" {
  vpc_id = aws_vpc.eks.id

  tags = map(
    "Name", "eks-${var.projectname}-${var.environment}",
    "kubernetes.io/cluster/cluster-${var.projectname}-${var.environment}", "shared",
  )
}

resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.eks.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks.id
  }

  tags = map(
    "Name", "eks-${var.projectname}-${var.environment}",
    "Environment", "${var.environment}",
    "Terraformed", "true",
    "kubernetes.io/cluster/cluster-${var.projectname}-${var.environment}", "shared",
  )
}

resource "aws_route_table_association" "rta_public" {
  count = var.countindex

  subnet_id      = aws_subnet.subnet_public.*.id[count.index]
  route_table_id = aws_route_table.rtb_public.id
}


#
# The configuration of a private subnet for EKS cluster 
#

resource "aws_subnet" "subnet_private" {
  count = var.countindex

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "172.16.2${count.index}.0/24"
  vpc_id            = aws_vpc.eks.id

  tags = map(
    "Name", "eks-private-${data.aws_availability_zones.available.names[count.index]}-${var.projectname}-${var.environment}",
    "Environment", "${var.environment}",
    "Terraformed", "true",
    "kubernetes.io/role/internal-elb", "1",
    "kubernetes.io/cluster/cluster-${var.projectname}-${var.environment}", "shared",
  )
}

resource "aws_eip" "eip_nat_gateway" {
  count         = var.countindex
  vpc           = true

  tags = map(
    "Name", "eks-${data.aws_availability_zones.available.names[count.index]}-${var.projectname}-${var.environment}",
    "Environment", "${var.environment}",
    "Terraformed", "true",
    "kubernetes.io/cluster/cluster-${var.projectname}-${var.environment}", "shared",
  )
}

resource "aws_nat_gateway" "eks" {
  count         = var.countindex
  allocation_id = aws_eip.eip_nat_gateway[count.index].id
  subnet_id     = aws_subnet.subnet_public[count.index].id

  tags = map(
    "Name", "eks-${data.aws_availability_zones.available.names[count.index]}-${var.projectname}-${var.environment}",
    "Environment", "${var.environment}",
    "Terraformed", "true",
    "kubernetes.io/cluster/cluster-${var.projectname}-${var.environment}", "shared",
  )
}


resource "aws_route_table" "rtb_private" {
  count                 = var.countindex
  vpc_id                = aws_vpc.eks.id

  route {
    cidr_block          = "0.0.0.0/0"
    nat_gateway_id      = aws_nat_gateway.eks[count.index].id
  }

  tags = map(
    "Name", "eks-${data.aws_availability_zones.available.names[count.index]}-${var.projectname}-${var.environment}",
    "Environment", "${var.environment}",
    "Terraformed", "true",
    "kubernetes.io/cluster/cluster-${var.projectname}-${var.environment}", "shared",
  )
}

resource "aws_route_table_association" "rta_private" {
  count                 = var.countindex
  subnet_id             = aws_subnet.subnet_private[count.index].id
  route_table_id        = aws_route_table.rtb_private[count.index].id
}
