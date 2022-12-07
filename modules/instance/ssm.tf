#
#### System Manager Agent
#

# Cloudwatch 

resource "aws_ssm_parameter" "cw_agent" {
  description = "Cloudwatch agent config to configure custom log"
  name        = "/cloudwatch-agent/config"
  type        = "String"
  value       = file("modules/cloudwatch/cw_agent_config.json")
}

# Création d'un profil qui permet d'accéder
# aux instances EC2 créées dans ce projet

#Exemple d'utilisation:
# aws ssm start-session --target MY_INSTANCE_ID --region us-east-1

resource "aws_iam_role" "ssm_cloudwatch_ec2_instance_role" {
  name        = "ssm_cloudwatch_ec2_instance_role"
  description = "SSM role for EC2 (cloudwatch) resources"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = ["ec2.amazonaws.com"]
          }
        }
      ]
    })


  inline_policy {
    name = "${var.project_name}-${var.environment}-cloudwatch-credentials_policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow",
          Action = "s3:PutObject",
          Resource = "arn:aws:s3:::ssm-encrypted"
        },
        {
          Effect = "Allow",
          Action = [
            "s3:GetEncryptionConfiguration",
            "logs:CreateLogStream",
            "logs:DescribeLogStreams",
            "ssm:GetParameter",
            "logs:CreateLogGroup",
            "logs:PutLogEvents"
          ],
          Resource = "*"
        }
      ]
    })
  }

  tags = {
    Name   = "SsmEc2InstanceRole"
    Module = "Networking"
  }
}

resource "aws_iam_role_policy_attachment" "assume_role_policy_document" {
  role       = aws_iam_role.ssm_cloudwatch_ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "assume_service_role_document" {
  role       = aws_iam_role.ssm_cloudwatch_ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "assume_role_policy_CW_document" {
  role       = aws_iam_role.ssm_cloudwatch_ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "ssm_instance_ec2_cloudwatch_profile"
  role = aws_iam_role.ssm_cloudwatch_ec2_instance_role.name

  tags = {
    Name   = "SsmEc2InstanceProfile"
    Module = "Networking"
  }
}
