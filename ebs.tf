/*
 * Cassandra EBS configuration
 */

resource "aws_volume_attachment" "seed-data-attach" {
  count = "${aws_instance.seeds.count}"
  device_name = "${var.data_device_name}"
  volume_id = "${var.seed_data_volume_ids[count.index]}"
  instance_id = "${element(aws_instance.seeds.*.id, count.index)}"
}

resource "aws_volume_attachment" "seed-commitlog-attach" {
  count = "${aws_instance.seeds.count}"
  device_name = "${var.commit_log_device_name}"
  volume_id = "${var.seed_commitlog_volume_ids[count.index]}"
  instance_id = "${element(aws_instance.seeds.*.id, count.index)}"
}

resource "aws_volume_attachment" "nonseed-data-attach" {
  count = "${aws_instance.nodes.count}"
  device_name = "${var.data_device_name}"
  volume_id = "${var.nonseed_data_volume_ids[count.index]}"
  instance_id = "${element(aws_instance.nodes.*.id, count.index)}"
}

resource "aws_volume_attachment" "nonseed-commitlog-attach" {
  count = "${aws_instance.nodes.count}"
  device_name = "${var.commit_log_device_name}"
  volume_id = "${var.nonseed_commitlog_volume_ids[count.index]}"
  instance_id = "${element(aws_instance.nodes.*.id, count.index)}"
}
