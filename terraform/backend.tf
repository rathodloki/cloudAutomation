terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket-lokendar"
    key    = "terraform/terraform.tfstate"
    region = "ap-south-1" 
  }
}