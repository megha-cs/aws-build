variable "vpc_id" { }
variable "private_instance_count" {}
variable "public_instance_count" {}
variable "sub_id" {}
variable "env" {}
variable "service"{}
variable "pub_security_group_id" {}
variable "pri_security_group_id" {}

data "aws_subnet_ids" "private_ids" {
  vpc_id = "${var.vpc_id}"
  filter {
    name   = "tag:Name"
    values = ["${format("%s-%s-pri*", upper(var.env), upper(var.service))}"]
  }
}
data "aws_subnet_ids" "public_ids" {
  vpc_id = "${var.vpc_id}"
  filter {
    name   = "tag:Name"
    values = ["${format("%s-%s-pub*", upper(var.env), upper(var.service))}"]
  }
}
resource "null_resource" "cluster" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    subnet_id  = "${var.sub_id}"
  }

}

resource "aws_instance" "public_instance" {
  #depends_on = [null_resource.cluster] 
  count                  ="${var.public_instance_count}"
  ami                    ="ami-02d7e25c1cfdd5695"
  instance_type          = "t2.micro"
  subnet_id              = tolist(data.aws_subnet_ids.public_ids.ids)[count.index]
#  iam_instance_profile = "test_profile"
  key_name               = "testkey"
  associate_public_ip_address = true
  vpc_security_group_ids =["${var.pub_security_group_id}"]
  user_data = "${file("./instance/tomcat.sh")}"
  tags = {
   Name = "${format("%s-%s-pub-ins-%d", upper(var.env), upper(var.service), count.index)}"
}
}

resource "aws_instance" "private_instance" {
  depends_on = [null_resource.cluster]  
  count                  ="${var.private_instance_count}"
  ami                    = "ami-02d7e25c1cfdd5695"
  instance_type          = "t2.micro"
  subnet_id              = tolist(data.aws_subnet_ids.private_ids.ids)[count.index]
  key_name               = "testkey"
  associate_public_ip_address = false
  vpc_security_group_ids =[ "${var.pri_security_group_id}"]
  user_data = "${file("./instance/tomcat.sh")}"
  tags = {
   Name = "${format("%s-%s-pri-ins-%d", upper(var.env), upper(var.service), count.index)}"
}
}

output "instance_id" {
value = "${join(",",aws_instance.public_instance.*.id)}"
}
output "pri_ins_id" {
value = "${join(",",aws_instance.private_instance.*.id)}"
}
