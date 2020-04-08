variable "db_security_group_id" {}
  resource "aws_db_instance" "default" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "admin"
  password             = "admin12345"
  db_subnet_group_name      = "${aws_db_subnet_group.default.id}"
  vpc_security_group_ids =["${var.db_security_group_id}"]
}

output "db_ep" {
  value = "${aws_db_instance.default.id}"
}

