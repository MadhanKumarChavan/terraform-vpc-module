resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
     var.common_tags,
     var.vpc_tags,
     
     {
        name = local.resource_name
     }

  )
}

######internetgatway module####
resource "aws_internet_gateway" "expense" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.igw_tags,
    {
        name = local.resource_name
    }
  )
}

######subnet creation- public######
##query zones####
## Public Subnet
resource "aws_subnet" "public" { # first name is public[0], second name is public[1]
  count = length(var.public_subnet_cidrs)
  availability_zone = "local.az_names[count.index]"
  map_public_ip_on_launch = true
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]

  tags = merge(
    var.common_tags,
    var.public_subnet_cidr_tags,
    {
        Name = "${local.resource_name}-public-${local.az_names[count.index]}"
    }
  )
}

############################################################################################################33
## private Subnet
resource "aws_subnet" "private" { # first name is public[0], second name is public[1]
  count = length(var.private_subnet_cidrs)
  availability_zone = "local.az_names[count.index]"
  
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]

  tags = merge(
    var.common_tags,
    var.private_subnet_cidr_tags,
    {
        Name = "${local.resource_name}-private-${local.az_names[count.index]}"
    }
  )
}

############################################################################################################33
## database Subnet
resource "aws_subnet" "database" { # first name is public[0], second name is public[1]
  count = length(var.database_subnet_cidrs)
  availability_zone = "local.az_names[count.index]"
  
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidrs[count.index]

  tags = merge(
    var.common_tags,
    var.database_subnet_cidr_tags,
    {
        Name = "${local.resource_name}-database-${local.az_names[count.index]}"
    }
  )
}

##########elastic IP#####
resource "aws_eip" "nat" {
  domain   = "vpc"
}

################natgatway#########
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.common_tags,
    var.natgatway_tags,
    {
        Name = "${local.resource_name}"
    }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.expense]
}


############ route tables-public ########

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  

  tags = merge(
    var.common_tags,
    var.publicroutetables_tags,
    {
        Name = "${local.resource_name}-public"
    }
  )
}

############ route tables-private ########

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  

  tags = merge(
    var.common_tags,
    var.privateroutetables_tags,
    {
        Name = "${local.resource_name}-private"
    }
  )
}
############ route tables-database ########

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  

  tags = merge(
    var.common_tags,
    var.databaseroutetables_tags,
    {
        Name = "${local.resource_name}-database"
    }
  )
}

resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.expense.id
}

resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}

resource "aws_route" "database" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}



resource "aws_route_table_association" "public" {
    count = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public[*].id,count.index)
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "private" {
    count = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private[*].id,count.index)
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "database" {
    count = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.database[*].id,count.index)
  route_table_id = aws_route_table.database.id
}