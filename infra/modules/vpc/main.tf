# VPC
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "shop-main-vpc"
  }
}

# ============================================
# Public Subnets (2 AZs for EKS)
# ============================================

# Public Subnet 1 - AZ a
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name                                = "shop-public-subnet-1a"
    "kubernetes.io/role/elb"            = "1"
    "kubernetes.io/cluster/shop-eks"    = "shared"
  }
}

# Public Subnet 2 - AZ b
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name                                = "shop-public-subnet-1b"
    "kubernetes.io/role/elb"            = "1"
    "kubernetes.io/cluster/shop-eks"    = "shared"
  }
}

# ============================================
# Private Subnets (2 AZs for EKS Node Groups)
# ============================================

# Private Subnet 1 - AZ a
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name                                     = "shop-private-subnet-1a"
    "kubernetes.io/role/internal-elb"        = "1"
    "kubernetes.io/cluster/shop-eks"         = "shared"
  }
}

# Private Subnet 2 - AZ b
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name                                     = "shop-private-subnet-1b"
    "kubernetes.io/role/internal-elb"        = "1"
    "kubernetes.io/cluster/shop-eks"         = "shared"
  }
}

# ============================================
# Internet Gateway
# ============================================
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "shop-main-igw"
  }
}

# ============================================
# NAT Gateway (for private subnet internet access)
# ============================================
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "shop-nat-eip"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "shop-nat-gateway"
  }

  depends_on = [aws_internet_gateway.main_igw]
}

# ============================================
# Public Route Table
# ============================================
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "shop-public-route-table"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

# ============================================
# Private Route Table (via NAT Gateway)
# ============================================
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "shop-private-route-table"
  }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_assoc_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}
