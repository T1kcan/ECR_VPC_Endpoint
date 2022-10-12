variable "az_count" {
  description = "How many subnets will be created"
  type        = number
  default     = 1
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "keyname" {
  description = "Your private key file name"
  type        = string
  default     = "firstkey"
}

variable "ec2_type" {
  description = "Instance Type"
  type        = string
  default     = "t2.micro"
}

variable "tags" {
  description = "Key/Value pairs to assign to the default tags"
  type        = map(string)
  default     = null
}

variable "cidr_block" {
  description = "CIDR Block for main VPC"
  type        = string
  default     = "172.17.0.0/16"
}

variable "bastion_ami" {
  description = "Bastion Instance AMI Id"
  type        = string
  default     = "ami-026b57f3c383c2eec"
}

variable "test_ami" {
  description = "Test Instance AMI Id"
  type        = string
  default     = "ami-05ae512f2ebb5a332"
}