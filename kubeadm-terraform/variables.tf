///////////////////////
#Variables for Provider
///////////////////////

variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "ssh_key_name" {}

variable "region" {
  default = "us-east-1"
}

///////////////////////
# Variables for Resorces
///////////////////////

variable "instance_type" {
  default = "t2.large"
}

variable "ubuntu" {
  type    = string
  default = "ami-042e8287309f5df03" 
}

variable "tags1" {
  type    = string
  default = "worker01"
}

variable "tags2" {
  type    = string
  default = "worker02"
}

variable "name" {
  type    = string
  default = "Master"
}


////////////////////////
/////S3 Name
//////////////////


# variable "s3name" {
#   type        = string
#   default     = "my-bucket-001"
#   description = "This bucket name"
# }

//////////////////////////////
#Keypair variables
//////////////////////////////

variable "private_key_path" {}

///////////////////
#VPC CIDR and Subnet
//////////////////

variable "vpc_cidr" {
  default = "172.16.0.0/16"
}
variable "subnet1_cidr" {
  default = "172.16.0.0/24"
}