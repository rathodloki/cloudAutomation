variable "region" {
  type = string
  default = "ap-south-1"
  description = "The AWS region to deploy resources in."
}

variable "instance_type" {
  type = string
  default = "t2.micro"
  description = "The type of EC2 instance to launch."
}

variable "web_server_name" {
  type = string
  default = "WebApplicationServer"
  description = "The name of the web server instance."
}

variable "ami" {
  type = string
  default = "ami-0287a05f0ef0e9d9a"
  description = "The name of the web server instance."
}