variable "env" {}
variable "service"{}
variable "vpc_id" { }
variable "ins_id" { }
variable "public_instance_count" {}
variable "pub_security_group_id" {}


data "aws_subnet_ids" "public_ids" {
  vpc_id = "${var.vpc_id}"
  filter {
    name   = "tag:Name"
    values = ["${format("%s-%s-pub*", upper(var.env), upper(var.service))}"]
  }
}
/*
data "aws_instance" "instance_ids" {
  filter {
    name   = "tag:Name"
    values = ["${format("%s-%s-pub-ins*", upper(var.env), upper(var.service))}"]
  }
}*/

resource "aws_elb" "webapp_elb" {
  name = "demo-webapp-elb"
  security_groups    = ["${var.pub_security_group_id}"]
  subnets            = [tolist(data.aws_subnet_ids.public_ids.ids)[0]]
  listener {
    instance_port = 8080
    instance_protocol = "tcp"
    lb_port = 80
    lb_protocol = "tcp"
  }
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "TCP:8080"
    interval = 10
  }
 # instances                   = [tolist(data.aws_instance.instance-ids.id)[0]]
 # cross_zone_load_balancing   = true
 # idle_timeout                = 400
 # connection_draining         = true
 # connection_draining_timeout = 400
}

resource "aws_elb_attachment" "ELB_attach" {
  elb      = "${aws_elb.webapp_elb.id}"
  count    = "${var.public_instance_count}"
  instance = element(split(",",var.ins_id),count.index)
}

output "webapp_elb_name" {
  value = "${aws_elb.webapp_elb.name}"
}

