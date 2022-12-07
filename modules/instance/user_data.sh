#! /bin/bash
set -e

echo 'Begin initialization'

# Ouput all log
exec > >(tee /var/log/user-data.log|logger -t user-data-extra -s 2>/dev/console) 2>&1

# Make sure we have all the latest updates when we launch this instance
yum update -y
yum upgrade -y

# Configure Cloudwatch agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
rpm -U ./amazon-cloudwatch-agent.rpm

# Use cloudwatch config from SSM
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
-a fetch-config \
-m ec2 \
-c ssm:${ssm_cloudwatch_config} -s

echo 'Done initialization'

echo 'Begin application logs'

# Service install
yum install awslogs -y

# Replace the awscli conf file content to change region value
sudo cat > /etc/awslogs/awscli.conf <<EOF 
[plugins]
cwlogs = cwlogs
[default]
region = ${aws_region}
EOF

# Update the default log group (dedicated to EC2 logs) to rename it depending of the project name  
sudo sed -i -e "s+log_group_name = /var/log/messages+log_group_name = ${project_name}/Ec2LogGroup+g" /etc/awslogs/awslogs.conf

# Create a temporary file to fake an app log file
touch /tmp/application_logs 

# Add a second section for application logs. 
# Add as many log groups / subgroups as you need, depending of your running apps.
sudo cat >> /etc/awslogs/awslogs.conf <<EOF 

[/tmp/application_logs]
datetime_format = %b %d %H:%M:%S
file = /tmp/application_logs
buffer_duration = 5000
log_stream_name = {instance_id}
initial_position = start_of_file
log_group_name = ${project_name}/ServiceLogGroup
EOF

sudo service awslogsd start

sudo systemctl start awslogsd

sudo cat > /tmp/application_logs <<EOF 
I add here some text to test if the log group contains my log file on AWS console :) 
EOF


