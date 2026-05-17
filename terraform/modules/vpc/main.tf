resource "aws_vpc" "main" {
  cidr_block = var.cidr

  enable_dns_support = true
  enable_dns_hostnames = true

  instance_tenancy = "default"

  tags = merge (var.tags, { Name = "${var.name}-vpc"})
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
  Name = "${var.name}-igw"
})

}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.tags, {
  Name = "${var.name}-public-rt"
  })

}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "public" {
  for_each = tomap({
    for idx, subnet in var.public_subnets : idx => subnet
  })

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = var.public_azs[tonumber(each.key)]
  map_public_ip_on_launch = true
  
  tags = merge(var.tags, {
    Name = "${var.name}-public-${tonumber(each.key) + 1}"

  })
}

resource "aws_subnet" "private_primary" {
  for_each = tomap({
    for idx, subnet in var.private_primary : idx => subnet
  })

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = var.primary_azs[tonumber(each.key)]

  tags = merge(var.tags, {
    Name = "${var.name}-private-primary-${each.key}"
  })
}

resource "aws_subnet" "private_standby" {
  for_each = tomap({
    for idx, subnet in var.private_standby : idx => subnet
  })

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = var.standby_azs[tonumber(each.key)]

  tags = merge(var.tags, {
    Name = "${var.name}-private-standby-${each.key}"
  })
}