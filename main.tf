provider "aws" {
  region = "ap-south-1"
}

data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_instance" "web" {
  ami           = data.aws_ssm_parameter.al2023.value
  instance_type = "t3.micro"
  monitoring    = true
  user_data     = file("install.sh")
  tags          = { Name = "p3-cpu-monitor" }
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "p3-ec2-high-cpu"
  alarm_description   = "CPU above 50%"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = 60
  evaluation_periods  = 1
  threshold           = 50
  comparison_operator = "GreaterThanThreshold"
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = aws_instance.web.id
  }
}

output "instance_id" {
  value = aws_instance.web.id
}
