resource "aws_default_security_group" "ecs-default-sg" {
  vpc_id      = aws_vpc.ecs_vpc.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}


resource "aws_security_group" "allow_all" {
  vpc_id      = aws_vpc.ecs_vpc.id
  name        = "allow_all"
  description = "Allow ALL inbound traffic"


  ingress {
    description      = "allow_all"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all"
  }
}


resource "aws_security_group" "alb_dev" {
  vpc_id      = aws_vpc.ecs_vpc.id
  name        = "alb_dev"
  description = "Allow from outside to ALB and to DEV inbound traffic"


  ingress {
    description      = "allow_from_outside"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_from_outside"
  }
}


resource "aws_security_group" "dev_svc" {
  vpc_id      = aws_vpc.ecs_vpc.id
  name        = "dev_svc"
  description = "Allow inbound HTTP traffic to Jenkins from ALB only"


  ingress {
    description      = "allow from ALB only"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    security_groups = [aws_security_group.alb_dev.id]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  tags = {
    Name = "allow_dev_svc"
  }
}

resource "aws_security_group" "ecs-bastion-sg" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.ecs_vpc.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.ip_admin]
  }

  ingress {
    description      = "SSH 12000"
    from_port        = 12000
    to_port          = 12000
    protocol         = "tcp"
    cidr_blocks      = [var.ip_admin]
  }

  ingress {
    description      = "Traffic from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.ecs_vpc_cidr]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_bastion"
  }
}

resource "aws_security_group" "efs" {
  vpc_id      = aws_vpc.ecs_vpc.id
  name        = "efs_vpc"
  description = "Allow inbound NFS to EFS from VPC"


  ingress {
    description      = "allow NFS protocol to EFS from VPC"
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    cidr_blocks      = [var.ecs_vpc_cidr]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  tags = {
    Name = "allow_to_efs_from_vpc"
  }
}


resource "aws_security_group" "jenkins_dev" {
  vpc_id      = aws_vpc.ecs_vpc.id
  name        = "jenknins_dev"
  description = "Allow JNLP inbound traffic from VPC to Jenkins"

  ingress {
    description      = "allow_to_jenkins_jnlp"
    from_port        = 50000
    to_port          = 50000
    protocol         = "tcp"
    cidr_blocks      = [var.ecs_vpc_cidr]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_to_jenkins_jnlp"
  }
}
