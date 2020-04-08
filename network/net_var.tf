variable "vpc_cidr" {
}

variable "private_subnet" {
  type = "list"
}
variable "public_subnet" {
  type = "list"
}
variable "env" {}
variable "service" {}
variable "availability_zones" {
  type        = "list"
  description = "List of Availability Zones (e.g. `['us-east-1a', 'us-east-1b', 'us-east-1c']`)"
  
}
