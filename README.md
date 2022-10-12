# ECR_VPC_Endpoint

## Description
The main purpose of this module to create a VPC Endpoint in private subnet to reach out Private ECR Repositories. This sample document/manifest files include testing feature to show that an instance in private subnet can access ECR Repositories through VPC Interface Endpoint without internet access.
Once you comment lines between 15-101 only Resources for craeting VPC Endpoint will be left.

## Requirements
| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.29 |

## Providers
| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.29 |

## Usage
You can reach the module using the GitHub URL: https://github.com/flugel-it/ecr-spike-private-connection
Change the variables according to your infrastructure. 
Default values are good to go with creation of ECR VPC Endpoint. You may leave as the default ones. 
To install this module you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```
Copy your private key to Bastion host through scp command:
```bash
scp -i your_keyfile.pem your_keyfile.pem ec2-user@<bastion_host_public_ip>:/home/ec2-user
```
On Bastion Host change permission of private key and connec to your test instance:
chmod 400 your_keyfile.pem
ssh -i your_keyfile.pem ec2-user@<test_instance_private_ip>
```
Configure your AWS Credentials on Test Instance via:
```bash
aws configure
```
List all repositories without having internet Access through IGW or NAT instance on private subnet:
```bash
aws ecr describe-repositories --region <your_region>
aws ecr get-login-password --region <your_region> | docker login --username AWS --password-stdin <your_AWS_Account_ID>.dkr.ecr.us-east-1.amazonaws.com
docker build -t sample .
docker tag sample:latest <your_AWS_Account_ID>.dkr.ecr.us-east-1.amazonaws.com/sample:latest
docker push <your_AWS_Account_ID>.dkr.ecr.us-east-1.amazonaws.com/sample:latest
docker pull <your_AWS_Account_ID>.dkr.ecr.us-east-1.amazonaws.com/sample:latest
```
Once you finish testing just comment lines between 15-101 thus only VPC Endpoint Resources will be left.

| Variable Name | Description | Type | Default Value
|---------------|-------------|------|---------------|
| az_count | How many subnets will be created | number | 1 |
| aws_region | AWS Region | string | "us-east-1" |
| keyname | Your private key file name | string | "firstkey" |
| ec2_type | Instance Type | string | "t2.micro" |
| tags | Key/Value pairs to assign to the default tags | map(string) | null |
| bastion_ami  | Bastion Instance AMI Id | string | "ami-026b57f3c383c2eec" |
| test_ami  | Test Instance AMI Id | string | "ami-05ae512f2ebb5a332" |
| cidr_block  | CIDR Block for main VPC | string | "172.17.0.0/16" |
## Outputs
| Output Name | Description | Type |
|---------------|-------------|------|
| sg-arn | Security Group ARN | string |
| sg-id | Security group ID | string | 


