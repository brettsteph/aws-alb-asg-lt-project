variable "my-ip-cidr-block" {
  type        = string
  description = "My IP address CIDR"
  default     = "enter my IP here/32" // TODO
}

resource "aws_security_group" "web-security-group" {
  name        = "web-security-group-${local.env_suffix}"
  description = "Allow TLS inbound traffic from ALB - ${local.env_suffix}"
  vpc_id      = local.vpc_id

  ingress {
    description = "SSH from my IP only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my-ip-cidr-block]
  }

  ingress {
    description = "Allow inbound traffic via HTTP from ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb-security-group.id]
  }

  ingress {
    description = "Allow inbound traffic via HTTPS from ALB"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.alb-security-group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web Security Group - ${local.env_suffix}"
  }
}

resource "aws_security_group" "alb-security-group" {
  name        = "alb-security-group-${local.env_suffix}"
  description = "Allow TLS inbound traffic on ports 80, and 443 - ${local.env_suffix}"
  vpc_id      = local.vpc_id

  ingress {
    description = "Allow inbound traffic via HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow inbound traffic via HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALB Security Group - ${local.env_suffix}"
  }
}

