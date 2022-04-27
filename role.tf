variable "s3-bucket-name" {
  type        = string
  description = "Name of s3 bucket where static web files are stored"
  default     = "ec2-with-static-site"
}

# Create an IAM role for the Web Server.
resource "aws_iam_role" "ec2-assume-role" {
  name = "ec2_assume_role_${local.env_suffix}"

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

resource "aws_iam_policy" "s3ReadOnly-policy" {
  name        = "s3ReadOnly-policy-${local.env_suffix}"
  description = "An inline policy to read-only for s3"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "stmt1",
      "Action": [
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.s3-bucket-name}"
    },
    {
      "Sid": "stmt2",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.s3-bucket-name}/*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role = aws_iam_role.ec2-assume-role.name
  policy_arn = aws_iam_policy.s3ReadOnly-policy.arn
}

resource "aws_iam_instance_profile" "iam-profile" {
  name = "ec2-iam-profile-${local.env_suffix}"
  role = aws_iam_role.ec2-assume-role.name
}
