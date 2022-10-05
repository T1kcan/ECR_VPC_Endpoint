variable "az_count" {
  description = "how many subnets will be created"
  type        = number
  default     = 1
}

variable "s3_bucket_name" {
  type    = string
  default = "t1kcannn"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "tags" {
  description = "Key/Value pairs to assign to the default tags"
  type        = map(string)
  default     = null
}