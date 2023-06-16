# ################################################################################
# # VPC
# ################################################################################
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = (merge(var.tags,
    tomap({ "Name" : var.vpc_name })
  ))
}

# ################################################################################
# # Subnets
# ################################################################################
resource "aws_subnet" "subnets" {
  count             = length(var.subnets)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.subnets, count.index).cidr_block
  availability_zone = element(var.subnets, count.index).az

  tags = (merge(var.tags,
    tomap({
        "Name" : element(var.subnets, count.index).name
    })
  ))

  depends_on = [aws_vpc.vpc]
}




