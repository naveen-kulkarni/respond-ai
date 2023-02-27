data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.prefix}/base/vpc_id"
}
data "aws_ssm_parameter" "public" {
  name = "/${var.prefix}/base/subnet/public/id"
}

data "aws_ssm_parameter" "private" {
  name = "/${var.prefix}/base/subnet/private/id"
}

locals {
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  pub_subnet_id_a = data.aws_ssm_parameter.public.value
  pvt_subnet_id_a = data.aws_ssm_parameter.private.value
  }

resource "aws_security_group" "ssh_access" {
  vpc_id      = "${local.vpc_id}"
  name        = "${var.prefix}-ssh_access"
  description = "SSH access group"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow HTTP"
    createdBy = "infra-${var.prefix}/news"
  }
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "${var.prefix}-news"
  public_key = "${file("${path.module}/../id_rsa.pub")}"
}

data "aws_ami" "amazon_linux_2" {
 most_recent = true

 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }

 filter {
   name = "architecture"
   values = ["x86_64"]
 }

 owners = ["137112412989"] #amazon
}

resource "aws_security_group" "rds" {
  name_prefix = "rds"
  vpc_id      = aws_vpc.example.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.example.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "webserver" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install apache2 -y
              sudo service apache2 start
              EOF
   security_groups = [aws_security_group.web_servers_sg.id]
  iam_instance_profile = "${var.prefix}_news_host"

tags = {
    Name = "web-instance"
  }
}


resource "aws_db_subnet_group" "example" {
  name       = "example"
  subnet_ids = [aws_subnet.private-subnet11.id, aws_subnet.private-subnet-2.id]
}

# Deploy RDS Instance as the Database Backend:

resource "aws_db_instance" "example" {
  identifier             = "example"
  engine                 = "mysql"
  engine_version         = "8.0.21"
  instance_class         = "db.t2.micro"
  allocated_storage      = 20
  storage_type           = "gp2"
  publicly_accessible    = false
  db_subnet_group_name   = aws_db_subnet_group.example.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  iam_instance_profile = "${var.prefix}_news_host"
 
  tags = {
    Name = "example"
  }
}

