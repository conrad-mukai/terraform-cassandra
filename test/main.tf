/*
 * test for the Cassandra module
 */

provider "aws" {
  region = "${var.region}"
}

resource "aws_eip" "public-ips" {
  count = "${length(var.availability_zones)}"
  vpc = true
}

module "network" {
  source = "git::https://github.com/conrad-mukai/terraform-network.git"
  environment = "${var.environment}"
  app_name = "infra"
  cidr_vpc = "${var.cidr_vpc}"
  availability_zones = "${var.availability_zones}"
  nat_eips = "${aws_eip.public-ips.*.id}"
  allowed_ingress_list = "${var.allowed_ingress_list}"
  bastion_ami = "${var.ami}"
  bastion_user = "${var.user}"
  private_key_path = "${var.private_key_path}"
  authorized_keys = "${file(var.authorized_key_path)}"
  key_name = "${var.key_name}"
}

module "seed-data" {
  source = "git::https://github.com/conrad-mukai/terraform-ebs-volume.git"
  environment = "${var.environment}"
  app_name = "infra"
  role = "cass-seed-data"
  availability_zones = "${var.availability_zones}"
  type = "gp2"
  size = "500"
}

module "seed-commitlog" {
  source = "git::https://github.com/conrad-mukai/terraform-ebs-volume.git"
  environment = "${var.environment}"
  app_name = "infra"
  role = "cass-seed-commitlog"
  availability_zones = "${var.availability_zones}"
  type = "gp2"
  size = "125"
}

module "nonseed-data" {
  source = "git::https://github.com/conrad-mukai/terraform-ebs-volume.git"
  environment = "${var.environment}"
  app_name = "infra"
  role = "cass-data"
  availability_zones = "${var.availability_zones}"
  type = "gp2"
  size = "500"
}

module "nonseed-commitlog" {
  source = "git::https://github.com/conrad-mukai/terraform-ebs-volume.git"
  environment = "${var.environment}"
  app_name = "infra"
  role = "cass-commitlog"
  availability_zones = "${var.availability_zones}"
  type = "gp2"
  size = "125"
}

module "cassandra" {
  source = ".."
  environment = "${var.environment}"
  ami = "${var.ami}"
  user = "${var.user}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  iam_instance_profile = "${var.iam_instance_profile}"
  seed_data_volume_ids = "${module.seed-data.volume_ids}"
  seed_commitlog_volume_ids = "${module.seed-commitlog.volume_ids}"
  nonseed_data_volume_ids = "${module.nonseed-data.volume_ids}"
  nonseed_commitlog_volume_ids = "${module.nonseed-commitlog.volume_ids}"
  subnet_ids = "${module.network.private_subnet_ids}"
  seed_subnet_ids = "${module.network.static_subnet_ids}"
  seed_addr = "${var.seed_addr}"
  security_group_ids = ["${module.network.internal_security_group_id}"]
  bastion_ip = "${module.network.bastion_ips[0]}"
  private_key = "${var.private_key_path}"
  bastion_user = "${var.user}"
  bastion_private_key = "${var.bastion_private_key_path}"
  cloudwatch_alarm_arn = "${var.cloudwatch_alarm_arn}"
}
