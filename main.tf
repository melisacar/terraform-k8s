provider "aws" {
    region = "eu-north-1"
}

# VPC
module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "~> 3.19.0"

    name = "eks-vpc"
    cidr = "10.0.0.0/16"

    azs = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
    public_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    private_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

    #public_subnet_tags = {
    #    "kubernetes.io/role/elb" = "1"
    #}

    #private_subnet_tags = {
    #    "kubernetes.io/role/internal-elb" = "1"     
    #}
    
    #map_public_ip_on_launch = true # Public IP for Public Subnet
    enable_nat_gateway = false
    enable_vpn_gateway = false

        tags = {
        Terraform = "true"
        Environment = "dev"
    }
}

# Internet Gateway 
resource "aws_internet_gateway" "igw" {
  vpc_id = module.vpc.vpc_id
}

#  Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = module.vpc.vpc_id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id            = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  for_each      = toset(module.vpc.public_subnets)
  subnet_id     = each.value
  route_table_id = aws_route_table.public.id
}

# EKS Cluster 
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "eks-cluster-1"
  version = "~> 20.31"

  # Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true
  
  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  subnet_ids         = module.vpc.public_subnets
  vpc_id          = module.vpc.vpc_id
}