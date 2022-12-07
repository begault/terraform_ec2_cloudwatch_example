# [HowTo] Configure a terraform project having an EC2 instance to send instance and apps logs to Cloudwatch 

What you'll find on this repository : 
- Infrastructure as code (through terraform syntax) 
- Creation of a simple network with a VPN and public / private subnets
- Creation of an EC2 instance in the VPC to make our POC 
- Rights management to allow the instance to access / send data to Cloudwatch & s3
- Rights management (through SSM) to access the instance from your own terminal
- Creation of custom log groups
- Cloudwatch configuration to get specific metrics of the instance


## How to create the infrastructure

First, create your custom configuration file for the project.

```
cp terraform.tfvars.example terraform.tfvars
```

Then, update it with your own parameters. 

This done, launch the project ! 
```
terraform init 
terraform plan # if you want to take a look at what is created on AWS 
terraform apply --auto-approve 
```

