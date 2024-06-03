resource "aws_vpc" "projectvpc" {
  cidr_block           = var.vpccidr
  enable_dns_hostnames = var.dnshostname
  tags                 = var.projectvpctags
}

resource "aws_internet_gateway" "project-igw" {
  vpc_id = aws_vpc.projectvpc.id
  tags   = var.igw-tag
}

## create subnets 

##public subnets 

resource "aws_subnet" "pubsub-1" {
  vpc_id            = aws_vpc.projectvpc.id
  cidr_block        = var.pubsubcidr1
  availability_zone = var.az1
  tags              = var.pubsub1tags
}


resource "aws_subnet" "pubsub-2" {
  vpc_id            = aws_vpc.projectvpc.id
  cidr_block        = var.pubsubcidr2
  availability_zone = var.az2
  tags              = var.pubsub2tags
}


## private subnets 

resource "aws_subnet" "privsub-1" {
  vpc_id            = aws_vpc.projectvpc.id
  cidr_block        = var.privsubcidr1
  availability_zone = var.az1
  tags              = var.privsub1tags
}


resource "aws_subnet" "privsub-2" {
  vpc_id            = aws_vpc.projectvpc.id
  cidr_block        = var.privsubcidr2
  availability_zone = var.az2
  tags              = var.privsub2tags
}

# route tables 

## public route table 

resource "aws_route_table" "project-rt-pub" {
  vpc_id = aws_vpc.projectvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project-igw.id
  }
}

## private route table 

resource "aws_route_table" "project-rt-priv" {
  vpc_id = aws_vpc.projectvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.public-nat-1.id
  }
}

# subnet association for public subnet 

resource "aws_route_table_association" "subnet-pub1-association" {
  subnet_id      = aws_subnet.pubsub-1.id
  route_table_id = aws_route_table.project-rt-pub.id
}

resource "aws_route_table_association" "subnets-pub2-association" {
  subnet_id      = aws_subnet.pubsub-2.id
  route_table_id = aws_route_table.project-rt-pub.id
}

# subnet association for private subnet 

resource "aws_route_table_association" "subnet-priv1-association" {
  subnet_id      = aws_subnet.privsub-1.id
  route_table_id = aws_route_table.project-rt-priv.id
}

resource "aws_route_table_association" "subnet-priv2-association" {
  subnet_id      = aws_subnet.privsub-2.id
  route_table_id = aws_route_table.project-rt-priv.id
}

## Create nat gateway 
# start by creating an EIP
resource "aws_eip" "nat-eip" {

}

# create Nat 

resource "aws_nat_gateway" "public-nat-1" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.pubsub-1.id
}
