Define Infrastructure as Code:
Define the entire infrastructure using Terraform. 
This includes VPC, subnets, security groups, EC2 instances, RDS instance, ELB, Auto Scaling, Route 53, CloudWatch, S3, IAM,
and any other resources required for your web application.

Create a VPC:
Create a VPC using Terraform with public and private subnets in two different availability zones.
Associate a route table with the public subnet that has a route to the internet gateway. 
Associate a route table with the private subnet that has a route to the NAT gateway. 


Launch EC2 Instances(Webserver):
Launch EC2 instances using Terraform in the public subnets. 
Install and configure the web server on each instance using shell script. 


Create RDS Instance:
Create an RDS instance using Terraform in the private subnet. 

Create an ELB:
Create an auto scaling group and associate it with the launch configuration. Set up health checks for the instances.
Create an ELB using Terraform and associate it with the auto scaling group. 
Configure the listeners and health checks. Ensure that the ELB is associated with the public subnets.

Use Route 53 for DNS:
Create a DNS record using Terraform for your domain name and point it to the ELB. 
Use Route 53 for routing traffic to the ELB.

Use CloudWatch for Monitoring:
Configure CloudWatch using Terraform to monitor the performance of the web application. 
Define alarms for key metrics such as CPU utilization. 
Optionally we Set up SNS notifications for critical alerts.

Use S3 for File Storage:
Create an S3 bucket using Terraform for file storage. 
Define proper bucket policies and access control. 
Use the bucket for storing user files, application logs, and backups.

Use IAM for Access Control:
Define IAM roles and policies using Terraform for controlling access to AWS resources. 
Define roles for EC2 instances, RDS, ELB, and other resources. 
Use IAM to control access to S3 buckets.
