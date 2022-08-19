terraform {
  backend "s3" {
    bucket = "my-s3-bucket"
    key   = "s3/terraform.tfstate"
    region = "us-east-2"
 }
}