# ECR_VPC_Endpoint

## Description
A sample VPC Endpoint creation in private subnets to reach out Private ECR Repositories.

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

## Parameters for Configuration
| Variable Name | Description | Type | Default Value
|---------------|-------------|------|---------------|
| az_count | How many subnets will be created | number | 1 |
| s3_bucket_name | Unique S3 bucket name | string | smtg_unique1011 |
| aws_region | AWS Region | string | us-east-1 |
| tags | Key/Value pairs to assign to the default tags | map(string) | null |
| cidr_block  | CIDR Block for main VPC | string | 172.17.0.0/16 |

## Outputs
| Output Name | Description | Type |
|---------------|-------------|------|
| sg-arn | Security Group ARN | string |
| sg-id | Security group ID | string | 


