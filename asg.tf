variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "ami_id" {
  type    = string
  default = "ami-0f9fc25dd2506cf6d"
}
variable "key_pair" {
  type    = string
  default = "enter key pair here" //TODO
}
variable "asg_desired_capacity" {
  type    = number
  default = 2
}
variable "asg_max_size" {
  type    = number
  default = 4
}
variable "asg_min_size" {
  type    = number
  default = 2
}

resource "aws_launch_template" "launch-template" {
  name                   = "launch-template-${local.env_suffix}"
  instance_type          = var.instance_type
  image_id               = var.ami_id
  key_name               = var.key_pair
  vpc_security_group_ids = [aws_security_group.web-security-group.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.iam-profile.name
  }

  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_termination = false

  ebs_optimized = false

  instance_initiated_shutdown_behavior = "terminate"

  metadata_options {
    # http_endpoint               = "enabled"
    # http_tokens                 = "required"
    # http_put_response_hop_limit = 1
    instance_metadata_tags = "enabled"
  }

  monitoring {
    enabled = false
  }

  # lifecycle {
  #   ignore_changes = [
  #     image_id,
  #   ]
  # }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "From ASG LT - ${local.env_suffix}"
    }
  }

  user_data = filebase64("./assets/user-data.sh")
}

resource "aws_autoscaling_group" "asg-group" {
  name = "asg-group-${local.env_suffix}"
  availability_zones = local.availability_zones
  desired_capacity   = var.asg_desired_capacity
  max_size           = var.asg_max_size
  min_size           = var.asg_min_size

  termination_policies = ["OldestInstance"]
  health_check_type = "ELB"
  health_check_grace_period = 90 # seconds

  # depends_on = [
  #   var.alb-input,
  # ]
  
  launch_template {
    id      = aws_launch_template.launch-template.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true # Required to redeploy without an outage.
    # see notes in https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment
    ignore_changes = [load_balancers, target_group_arns]
  }
}

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg-group.id
  lb_target_group_arn    = aws_lb_target_group.alb-tg.id
}
