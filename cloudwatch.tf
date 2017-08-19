/*
 * CloudWatch configuration.
 */

resource "aws_cloudwatch_metric_alarm" "seed-cpu-alarm" {
  count = "${aws_instance.seeds.count}"
  alarm_name = "${format("%s-cass-seed-cpu-%02d", var.environment, count.index+1)}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "5"
  namespace = "AWS/EC2"
  metric_name = "CPUUtilization"
  period = "60"
  statistic = "Average"
  threshold = "${var.cpu_alarm_threshold}"
  dimensions {
    InstanceId = "${element(aws_instance.seeds.*.id, count.index)}"
  }
  alarm_actions = ["${var.cloudwatch_alarm_arn}"]
}

resource "aws_cloudwatch_metric_alarm" "node-cpu-alarm" {
  count = "${aws_instance.nodes.count}"
  alarm_name = "${format("%s-cass-cpu-%s-%02d", var.environment, element(data.aws_subnet.subnets.*.availability_zone, count.index % length(var.subnet_ids)), count.index/length(var.subnet_ids)+1)}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "5"
  namespace = "AWS/EC2"
  metric_name = "CPUUtilization"
  period = "60"
  statistic = "Average"
  threshold = "${var.cpu_alarm_threshold}"
  dimensions {
    InstanceId = "${element(aws_instance.nodes.*.id, count.index)}"
  }
  alarm_actions = ["${var.cloudwatch_alarm_arn}"]
}

resource "aws_cloudwatch_metric_alarm" "seed-status-alarm" {
  count = "${aws_instance.seeds.count}"
  alarm_name = "${format("%s-cass-seed-status-%02d", var.environment, count.index+1)}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "1"
  namespace = "AWS/EC2"
  metric_name = "StatusCheckFailed"
  period = "60"
  statistic = "Average"
  threshold = "1"
  dimensions {
    InstanceId = "${element(aws_instance.seeds.*.id, count.index)}"
  }
  alarm_actions = ["${var.cloudwatch_alarm_arn}"]
}

resource "aws_cloudwatch_metric_alarm" "node-status-alarm" {
  count = "${aws_instance.nodes.count}"
  alarm_name = "${format("%s-cass-status-%s-%02d", var.environment, element(data.aws_subnet.subnets.*.availability_zone, count.index % length(var.subnet_ids)), count.index/length(var.subnet_ids)+1)}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "1"
  namespace = "AWS/EC2"
  metric_name = "StatusCheckFailed"
  period = "60"
  statistic = "Average"
  threshold = "1"
  dimensions {
    InstanceId = "${element(aws_instance.nodes.*.id, count.index)}"
  }
  alarm_actions = ["${var.cloudwatch_alarm_arn}"]
}

resource "aws_cloudwatch_metric_alarm" "seed-process-alarm" {
  count = "${aws_instance.seeds.count}"
  alarm_name = "${format("%s-cass-seed-proc-%02d", var.environment, count.index+1)}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods = "1"
  namespace = "CMXAM/Cassandra"
  metric_name = "CassandraStatus"
  period = "60"
  statistic = "Minimum"
  threshold = "1"
  dimensions {
    InstanceId = "${element(aws_instance.seeds.*.id, count.index)}"
  }
  alarm_actions = ["${var.cloudwatch_alarm_arn}"]
}

resource "aws_cloudwatch_metric_alarm" "node-process-alarm" {
  count = "${aws_instance.nodes.count}"
  alarm_name = "${format("%s-cass-proc-%s-%02d", var.environment, element(data.aws_subnet.subnets.*.availability_zone, count.index % length(var.subnet_ids)), count.index/length(var.subnet_ids)+1)}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods = "1"
  namespace = "CMXAM/Cassandra"
  metric_name = "CassandraStatus"
  period = "60"
  statistic = "Minimum"
  threshold = "1"
  dimensions {
    InstanceId = "${element(aws_instance.nodes.*.id, count.index)}"
  }
  alarm_actions = ["${var.cloudwatch_alarm_arn}"]
}

resource "aws_cloudwatch_event_rule" "cass-seed-event-rule" {
  name = "${var.environment}-cass-seed-event"
  description = "Cassandra Seed State Change"
  event_pattern = "${data.template_file.seed-state-change.rendered}"
}

resource "aws_cloudwatch_event_target" "cass-seed-event-target" {
  target_id = "cassandra-seed"
  rule = "${aws_cloudwatch_event_rule.cass-seed-event-rule.name}"
  arn = "${var.cloudwatch_alarm_arn}"
}

resource "aws_cloudwatch_event_rule" "cass-event-rule" {
  name = "${var.environment}-cass-event"
  description = "Cassandra State Change"
  event_pattern = "${data.template_file.node-state-change.rendered}"
}

resource "aws_cloudwatch_event_target" "cass-event-target" {
  target_id = "cassandra"
  rule = "${aws_cloudwatch_event_rule.cass-event-rule.name}"
  arn = "${var.cloudwatch_alarm_arn}"
}
