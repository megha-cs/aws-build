variable "access_key" {
  default = ""
}
variable "secret_key" {
  default = ""
}
variable "region" {
  default = "ap-southeast-2"
}

variable "public_subnet" {
 type = "list"
}

variable "private_subnet" {
 type = "list"
 }
variable "vpc_cidr" { }
variable "env" { }
variable "service" {}
variable "bucket_name" {
type = "list"
}
variable "private_instance_count" {}
variable "public_instance_count" {}
variable "availability_zones" {
  type        = "list"
  description = "List of Availability Zones (e.g. `['us-east-1a', 'us-east-1b', 'us-east-1c']`)"

}

