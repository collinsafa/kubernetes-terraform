///////////////////////////////////////////
#RESOURCES
///////////////////////////////////////////


#SIMPLE STORAGE SERVICE FOR BACKEND

# resource "aws_s3_bucket" "some-bucket" {
#   bucket = var.s3name
#   acl    = "private"
#   lifecycle {
#     prevent_destroy = false
#   }
#   versioning {
#     enabled    = false
#     mfa_delete = false
#   }
#   server_side_encryption_configuration {
#     rule {
#       apply_server_side_encryption_by_default {
#         sse_algorithm = "AES256"
#       }
#     }
#   }
# }
/// A network address translation (NAT) gateway enables instances in a private
/// subnet to connect to the internet or other AWS services, but prevent the internet from initiating a connection with those instances.

#VPC
resource "aws_vpc" "vpc1" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = "true"
}

# INTERNET_GATEWAY
///It is a VPC component that allows communication between your VPC and the internet////

resource "aws_internet_gateway" "gateway1" {
  vpc_id = aws_vpc.vpc1.id
}

# ROUTE_TABLE
///A route table contains a set of rules, called routes, that are used to determine where network traffic from your subnet or gateway is directed.
resource "aws_route_table" "route_table1" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway1.id
  }
}

resource "aws_route_table_association" "route-subnet1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.route_table1.id
}

# SUBNET
// Public subnet
resource "aws_subnet" "subnet1" {
  cidr_block              = var.subnet1_cidr
  vpc_id                  = aws_vpc.vpc1.id
  map_public_ip_on_launch = "true"
}

# SECURITY_GROUP FOR MASTER NODE
resource "aws_security_group" "k8s-sg" {
  name   = "cluster.sg"
  vpc_id = aws_vpc.vpc1.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
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


//////master/////

resource "aws_instance" "Master" {
  ami                    = var.ubuntu
  instance_type          = var.instance_type
  key_name               = var.ssh_key_name
  subnet_id              = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.k8s-sg.id]
  user_data              = file("user_data/master.sh")

  tags = {
    Name = var.name
    Env  = "production"
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "master"
    private_key = file(var.private_key_path)
  }
}


////////worker01////////////

resource "aws_instance" "worker01" {
  ami                    = var.ubuntu
  instance_type          = var.instance_type
  key_name               = var.ssh_key_name
  subnet_id              = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.k8s-sg.id]
  user_data              = file("user_data/worker01.sh")

  tags = {
    Name = var.tags1
    Env  = "production"
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "worker01"
    private_key = file(var.private_key_path)
  }
}

/////worker2//////

resource "aws_instance" "worker02" {
  ami                    = var.ubuntu
  instance_type          = var.instance_type
  key_name               = var.ssh_key_name
  subnet_id              = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.k8s-sg.id]
  user_data              = file("user_data/worker02.sh")

  tags = {
    Name = var.tags2
    Env  = "production"
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "worker02"
    private_key = file(var.private_key_path)
  }
}


//Get nodes public IPs. This will enable you SSH and the master and worker nodes//

output "Master_pub_ip" {
  value = aws_instance.Master.public_ip
}

output "worker01_pub_ip" {
  value = aws_instance.worker01.public_ip
}

output "worker02_pub_ip" {
  value = aws_instance.worker02.public_ip
}
