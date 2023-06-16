
module "hippa_vpcs" {

    source = "../../modules/aws/vpc"
    
    vpc_name = var.vpc_name
    vpc_cidr = var.vpc_cidr
    subnets = var.subnets
    tags = var.tags
}

# data "aws_subnets" "hippa_public_subnet" {
#   most_recent = true
#   filter {
#     name   = "tag:Name"    
#     values = ["${var.vpc_name}-PUB-*"]
#   }
#   depends_on = [module.hippa_vpcs]
# }

# ################################################################################
# # Internet Gateway
# ################################################################################
resource "aws_internet_gateway" "gw" {
  vpc_id = module.hippa_vpcs.vpc_id

  tags = (merge(var.tags,
    tomap({ "Name" : "${var.vpc_name} IGW"})
  ))
}

# ################################################################################
# # NAT gateway
# ################################################################################
resource "aws_eip" "ip" {
  domain = "vpc"
  
  tags = (merge(var.tags,
    tomap({ "Name" : "${var.vpc_name} EIP"})
  ))

  depends_on = [aws_internet_gateway.gw]
}

resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = aws_eip.ip.id
  subnet_id     = [for k, v in module.hippa_vpcs.subnets_info: k if length(regexall("${var.vpc_name}-PUB-*", v)) > 0][0]
  tags = (merge(var.tags,
    tomap({ "Name" : "${var.vpc_name} NAT" })
  ))
}


################################################################################
# Route table
################################################################################

# public route table
module "hippa_public_route_table" {
  source = "../../modules/aws/route_table"

  vpc_id = module.hippa_vpcs.vpc_id
  gateway_id =  aws_internet_gateway.gw.id
  nat_id = aws_nat_gateway.nat-gateway.id
  subnet_ids = [for k, v in module.hippa_vpcs.subnets_info: k if length(regexall("${var.vpc_name}-PUB-*", v)) > 0]
  subnet_info = [for index, v in var.subnets: v if length(regexall("${var.vpc_name}-PUB-*", v.name)) > 0]
  type = "public"
  name = "HIPPA PUB"
  tags = var.tags

  depends_on = [module.hippa_vpcs]
}

# UI route table
module "hippa_ui_route_table" {
  source = "../../modules/aws/route_table"

  vpc_id = module.hippa_vpcs.vpc_id
  gateway_id =  aws_internet_gateway.gw.id
  nat_id = aws_nat_gateway.nat-gateway.id
  subnet_ids = [for k, v in module.hippa_vpcs.subnets_info: k if length(regexall("${var.vpc_name}-UI-PRIVATE-*", v)) > 0]
  subnet_info = [for index, v in var.subnets: v if length(regexall("${var.vpc_name}-UI-PRIVATE-*", v.name)) > 0]
  type = "private"
  name = "HIPPA UI"
  tags = var.tags

  depends_on = [module.hippa_vpcs]
}

# APP route table
module "hippa_app_route_table" {
  source = "../../modules/aws/route_table"

  vpc_id = module.hippa_vpcs.vpc_id
  gateway_id =  aws_internet_gateway.gw.id
  nat_id = aws_nat_gateway.nat-gateway.id
  subnet_ids = [for k, v in module.hippa_vpcs.subnets_info: k if length(regexall("${var.vpc_name}-APP-PRIVATE-*", v)) > 0]
  subnet_info = [for index, v in var.subnets: v if length(regexall("${var.vpc_name}-APP-PRIVATE-*", v.name)) > 0]
  type = "private"
  name = "HIPPA APP"
  tags = var.tags

  depends_on = [module.hippa_vpcs]
}

# DB route table
module "hippa_db_route_table" {
  source = "../../modules/aws/route_table"

  vpc_id = module.hippa_vpcs.vpc_id
  gateway_id =  aws_internet_gateway.gw.id
  nat_id = aws_nat_gateway.nat-gateway.id
  subnet_ids = [for k, v in module.hippa_vpcs.subnets_info: k if length(regexall("${var.vpc_name}-DB-PRIVATE-*", v)) > 0]
  subnet_info = [for index, v in var.subnets: v if length(regexall("${var.vpc_name}-DB-PRIVATE-*", v.name)) > 0]
  type = "private"
  name = "HIPPA DB"
  tags = var.tags

  depends_on = [module.hippa_vpcs]
}

# ################################################################################
# # ACLs
# ################################################################################
module "hippa_public_acls" {
  source = "../../modules/aws/acls"

  vpc_id = module.hippa_vpcs.vpc_id
  subnet_ids = [for k, v in module.hippa_vpcs.subnets_info: k if length(regexall("${var.vpc_name}-PUB-*", v)) > 0]
  subnet_info = [for index, v in var.subnets: v if length(regexall("${var.vpc_name}-PUB-*", v.name)) > 0]
  acl_info = var.public_acls
  tags = var.tags
  
  depends_on = [module.hippa_vpcs]
}

# ################################################################################
# # Security Groups
# ################################################################################
module "hippa_security_groups" {
  source = "../../modules/aws/sg"

  vpc_id = module.hippa_vpcs.vpc_id
  security_groups = var.security_groups
  tags = var.tags

  depends_on = [module.hippa_vpcs]
}