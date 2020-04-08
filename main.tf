provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

# Module to create Subnet
module "network" {
source = "./network"
vpc_cidr = "${var.vpc_cidr}"
private_subnet = "${var.private_subnet}"
public_subnet = "${var.public_subnet}"
availability_zones="${var.availability_zones}"
service = "${var.service}"
env = "${var.env}"
}

# Module to create Security Group
module "securityGR" {
source = "./securityGR"
vpc_id = "${module.network.vpc-out}"
private_subnet = "${var.private_subnet}"
public_subnet = "${var.public_subnet}"
#service = "${var.service}"
#env = "${var.env}"
} 

/*# Module to IAM
 module "IAM" {
source = "./iam"
} 

#Module to create S3
module "storage" {
source = "./storage"
bucket_name="${var.bucket_name}"
} */
 
#Module to create Instance
module "instance" {
source = "./instance"
vpc_id = "${module.network.vpc-out}"
sub_id = "${module.network.sub-out}"
pri_security_group_id = "${module.securityGR.pri_SG-out}"
pub_security_group_id = "${module.securityGR.pub_SG-out}"
service = "${var.service}"
env = "${var.env}"
private_instance_count ="${var.private_instance_count}"
public_instance_count ="${var.public_instance_count}"
}

#Module to create lb
module "LB" {
source = "./LB"
ins_id = "${module.instance.instance_id}"
vpc_id = "${module.network.vpc-out}"
pub_security_group_id = "${module.securityGR.pub_SG-out}"
service = "${var.service}"
env = "${var.env}"
public_instance_count ="${var.public_instance_count}"
}
#Module to create RDS
module "RDS" {
source = "./RDS"
vpc_id = "${module.network.vpc-out}"
sub_id = "${module.network.sub-out}"
db_security_group_id = "${module.securityGR.db_SG-out}"
service = "${var.service}"
env = "${var.env}"
private_subnet="${var.private_subnet}"
}
