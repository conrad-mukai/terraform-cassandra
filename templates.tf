/*
 * Cassandra templates
 */

data "template_file" "datastax-repo" {
  template = "${file("${path.module}/files/datastax.repo")}"
  vars = {
    version = "${var.cassandra_version}"
  }
}

data "template_file" "setup-cassandra" {
  template = "${file("${path.module}/scripts/setup-cassandra.sh")}"
  vars = {
    cluster_name = "${var.environment}-${var.app_name}-cass-cluster"
    seed_addrs = "${join(",", aws_instance.seeds.*.private_ip)}"
    data_device_name = "${var.data_device_name}"
    data_mount_point = "${var.data_root}/${var.data_mount_point}"
    commit_log_device_name = "${var.commit_log_device_name}"
    commit_log_mount_point = "${var.data_root}/${var.commit_log_mount_point}"
  }
}

data "aws_region" "current" {
  current = true
}

data "template_file" "cassandra-status" {
  template = "${file("${path.module}/scripts/cassandra-status.sh")}"
  vars = {
    region = "${data.aws_region.current.name}"
  }
}

data "aws_caller_identity" "current" {}

data template_file "seed-state-change" {
  template = "${file("${path.module}/event_patterns/ec2-state-change.json")}"
  vars = {
    instances = "${join("\",\"", formatlist(format("arn:aws:ec2:%s:%s:instance/%%s", data.aws_region.current.name, data.aws_caller_identity.current.account_id), aws_instance.seeds.*.id))}"
  }
}

data template_file "node-state-change" {
  template = "${file("${path.module}/event_patterns/ec2-state-change.json")}"
  vars = {
    instances = "${join("\",\"", formatlist(format("arn:aws:ec2:%s:%s:instance/%%s", data.aws_region.current.name, data.aws_caller_identity.current.account_id), aws_instance.nodes.*.id))}"
  }
}
