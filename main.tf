resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# Create var.az_count private subnets, each in a different AZ
resource "aws_subnet" "private" {
  count             = var.az_count
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.main.id
}

# Create var.az_count public subnets, each in a different AZ
resource "aws_subnet" "public" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, var.az_count + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
}

# Internet Gateway for the public subnet
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

# Route the public subnet traffic through the IGW
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

# Create a NAT gateway with an Elastic IP for each private subnet to get internet connectivity
resource "aws_eip" "gw" {
  count      = var.az_count
  vpc        = true
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_nat_gateway" "gw" {
  count         = var.az_count
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.gw.*.id, count.index)
}

# Create IAM Role for EC2 instance to access ECR Repository 
resource "aws_iam_role" "ec2ecrfullaccess" {
  name                = "ecr_ec2_permission"
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"]
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ecr-ec2_profile"
  role = aws_iam_role.ec2ecrfullaccess.name
}

resource "aws_instance" "bastion" {
  ami                    = var.bastion_ami
  instance_type          = var.ec2_type
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.ecs_task.id]
  key_name               = var.keyname
  source_dest_check      = false
  tags = {
    "Name" = "Bastion Host"
  }
}

resource "aws_instance" "test" {
  ami                    = var.test_ami # aws cli & docker included ami
  instance_type          = var.ec2_type
  subnet_id              = aws_subnet.private[0].id
  vpc_security_group_ids = [aws_security_group.ecs_task.id]
  key_name               = var.keyname
  tags = {
    "Name" = "Test Instance"
  }
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
}

output "ssh-connection" {
  value = "ssh -i ~/.ssh/${var.keyname}.pem ec2-user@${aws_instance.bastion.public_ip}"
}

resource "aws_vpc_endpoint" "ecr-dkr-endpoint" {
  vpc_id              = aws_vpc.main.id
  private_dns_enabled = true
  service_name        = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.ecs_task.id]
  subnet_ids          = aws_subnet.private.*.id
}

resource "aws_vpc_endpoint" "ecr-api-endpoint" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.ecs_task.id]
  subnet_ids          = aws_subnet.private.*.id
}

# //////////////////////////////
# DATA
# //////////////////////////////

data "aws_availability_zones" "available" {
  state = "available"
}

# Create Security Group to associate with the endpoint network interface.
resource "aws_security_group" "ecs_task" {
  name        = "ecs_task"
  description = "ecs_task"
  tags = {
    "Name" = "Tf-Sg-ecs_task"
  }
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}