resource "aws_cloudwatch_log_group" "ec2_logs" {
  name = "${var.project_name}/Ec2LogGroup"

  retention_in_days = 30

  tags = {
    Application = "serviceA"
  }
}

resource "aws_cloudwatch_log_group" "application_logs" {
  name = "${var.project_name}/ServiceLogGroup"

  retention_in_days = 30

  tags = {
    Application = "serviceB"
  }
}