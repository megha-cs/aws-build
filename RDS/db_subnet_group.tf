variable "sub_id" {}
variable "vpc_id" {}
variable "env" {}
variable "service" {}
variable "private_subnet" {}


data "aws_subnet_ids" "private" {
  vpc_id = "${var.vpc_id}"

  filter {
    name   = "tag:Name"
    values = ["${format("%s-%s-pri*", upper(var.env), upper(var.service))}"]
  }
}



resource "null_resource" "cluster" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    subnet_id  = "${var.sub_id}"
  }

}

resource "aws_db_subnet_group" "default" {
#  count      = "${length(var.private_subnet)}"
  subnet_ids = tolist(data.aws_subnet_ids.private.ids)

}

