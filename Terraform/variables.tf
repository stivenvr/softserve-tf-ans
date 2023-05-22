variable "region" {
  #default region to deploy infrastructure
  type    = string
  default = "us-east-1"
}

variable "availability_zone" {
  type        = string
  description = "The availability zone where the infrastructure will be deployed"
  default     = "us-east-1a"
}

variable "cidr" {
  default = "10.0.0.0/16"
}

# variable "private_cidr" {
#   type    = string
#   default = "10.0.1.0/24"  
# }

variable "publicCIDR" {
  type    = string
  default = "10.0.0.0/24"
}

variable "environment" {
  default = "dev"
}
variable "instance_type" {
  #default instance_type to deploy
  type    = string
  default = "t2.micro"
}

variable "instance_AMI" {
  #default instance_type to deploy
  type    = string
  default = "ami-007855ac798b5175e"
}

variable "instance_tag" {
  #default instance_type to deploy
  type    = string
  default = "My Amazon Linux Server"
}

variable "allowed_ports" {
  description = "List of allowed ports"
  type        = list(any)
  default     = ["80", "443", "22", "8080"]
}