variable "az_count" {
  description = "How many subnets will be created"
  type        = number
  default     = 1
}

variable "s3_bucket_name" {
  description = "Unique S3 bucket name"
  type    = string
  default = "smtg_unique1011"
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
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