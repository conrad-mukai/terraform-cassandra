/*
 * Cassandra instances
 */

resource "aws_instance" "seeds" {
  count = "${length(var.seed_subnet_ids)}"
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  vpc_security_group_ids = ["${var.security_group_ids}"]
  subnet_id = "${var.seed_subnet_ids[count.index]}"
  private_ip = "${cidrhost(element(data.aws_subnet.seed_subnets.*.cidr_block, count.index), var.seed_addr)}"
  key_name = "${var.key_name}"
  iam_instance_profile = "${var.iam_instance_profile}"
  ebs_optimized = true
  tags {
    Name = "${var.environment}-${var.app_name}-cass-seed-${format("%02d", count.index+1)}"
  }
}

resource "aws_instance" "nodes" {
  count = "${var.nodes_per_az * length(var.subnet_ids)}"
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  vpc_security_group_ids = ["${var.security_group_ids}"]
  subnet_id = "${var.subnet_ids[count.index]}"
  key_name = "${var.key_name}"
  iam_instance_profile = "${var.iam_instance_profile}"
  ebs_optimized = true
  tags {
    Name = "${var.environment}-${var.app_name}-cass-${format("%02d", count.index+1)}"
  }
}
