/*
 * Cassandra provisioners
 */

resource "random_id" "backup-hour" {
  keepers = {
    seed_eni_ids = "${join(",", aws_instance.seeds.*.id)}"
    seed_data_ids = "${join(",", aws_volume_attachment.seed-data-attach.*.id)}"
    seed_commit_ids = "${join(",", aws_volume_attachment.seed-commitlog-attach.*.id)}"
    node_data_ids = "${join(",", aws_volume_attachment.nonseed-data-attach.*.id)}"
    node_commit_ids = "${join(",", aws_volume_attachment.nonseed-commitlog-attach.*.id)}"
  }
  byte_length = 2
}

resource "random_id" "backup-minute" {
  keepers = {
    seed_eni_ids = "${join(",", aws_instance.seeds.*.id)}"
    seed_data_ids = "${join(",", aws_volume_attachment.seed-data-attach.*.id)}"
    seed_commit_ids = "${join(",", aws_volume_attachment.seed-commitlog-attach.*.id)}"
    node_data_ids = "${join(",", aws_volume_attachment.nonseed-data-attach.*.id)}"
    node_commit_ids = "${join(",", aws_volume_attachment.nonseed-commitlog-attach.*.id)}"
  }
  byte_length = 2
}

resource "null_resource" "seed-nodes" {
  count = "${aws_instance.seeds.count}"
  triggers {
    data_id = "${element(aws_volume_attachment.seed-data-attach.*.id, count.index)}"
    commitlog_id = "${element(aws_volume_attachment.seed-commitlog-attach.*.id, count.index)}"
    seed_ip_id = "${element(aws_instance.seeds.*.id, count.index)}"
  }
  connection {
    host = "${element(aws_instance.seeds.*.private_ip, count.index)}"
    user = "${var.user}"
    private_key = "${file(var.private_key)}"
    bastion_host = "${var.bastion_ip}"
    bastion_user = "${var.bastion_user}"
    bastion_private_key = "${file(var.bastion_private_key)}"
  }
  provisioner "file" {
    content = "${data.template_file.datastax-repo.rendered}"
    destination = "/tmp/datastax.repo"
  }
  provisioner "file" {
    content = "${data.template_file.setup-cassandra.rendered}"
    destination = "/tmp/setup-cassandra.sh"
  }
  provisioner "file" {
    content = "${data.template_file.cassandra-status.rendered}"
    destination = "/tmp/cassandra-status.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/datastax.repo /etc/yum.repos.d/",
      "sudo chown root:root /etc/yum.repos.d/datastax.repo",
      "chmod +x /tmp/setup-cassandra.sh",
      "sudo /tmp/setup-cassandra.sh",
      "rm /tmp/setup-cassandra.sh",
      "sudo yum install -y git",
      "git clone ${var.backup_script_url} /tmp/ebs-backup",
      "cd /tmp/ebs-backup",
      "sudo python setup.py install",
      "cd /tmp",
      "sudo rm -rf /tmp/ebs-backup",
      "echo '${random_id.backup-minute.dec % 60} ${random_id.backup-hour.dec % 24} * * * ebs-backup -l /var/log/cassandra/backup.log -r ${var.backup_retention}' > /tmp/crontab",
      "sudo mv /tmp/cassandra-status.sh ${var.data_root}/cassandra-status.sh",
      "sudo chown cassandra:cassandra ${var.data_root}/cassandra-status.sh",
      "sudo chmod +x ${var.data_root}/cassandra-status.sh",
      "echo '* * * * * ${var.data_root}/cassandra-status.sh' >> /tmp/crontab",
      "sudo crontab -u cassandra /tmp/crontab",
      "rm /tmp/crontab"
    ]
  }
}

resource "null_resource" "nodes" {
  count = "${aws_instance.nodes.count}"
  triggers {
    data_id = "${element(aws_volume_attachment.nonseed-data-attach.*.id, count.index)}"
    commitlog_id = "${element(aws_volume_attachment.nonseed-commitlog-attach.*.id, count.index)}"
  }
  connection {
    host = "${element(aws_instance.nodes.*.private_ip, count.index)}"
    user = "${var.user}"
    private_key = "${file(var.private_key)}"
    bastion_host = "${var.bastion_ip}"
    bastion_user = "${var.bastion_user}"
    bastion_private_key = "${file(var.bastion_private_key)}"
  }
  provisioner "file" {
    content = "${data.template_file.datastax-repo.rendered}"
    destination = "/tmp/datastax.repo"
  }
  provisioner "file" {
    content = "${data.template_file.setup-cassandra.rendered}"
    destination = "/tmp/setup-cassandra.sh"
  }
  provisioner "file" {
    content = "${data.template_file.cassandra-status.rendered}"
    destination = "/tmp/cassandra-status.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/datastax.repo /etc/yum.repos.d/",
      "sudo chown root:root /etc/yum.repos.d/datastax.repo",
      "chmod +x /tmp/setup-cassandra.sh",
      "sudo /tmp/setup-cassandra.sh",
      "rm /tmp/setup-cassandra.sh",
      "sudo yum install -y git",
      "git clone ${var.backup_script_url} /tmp/ebs-backup",
      "cd /tmp/ebs-backup",
      "sudo python setup.py install",
      "cd /tmp",
      "sudo rm -rf /tmp/ebs-backup",
      "echo '${random_id.backup-minute.dec % 60} ${random_id.backup-hour.dec % 24} * * * ebs-backup -l /var/log/cassandra/backup.log -r ${var.backup_retention}' > /tmp/crontab",
      "sudo mv /tmp/cassandra-status.sh ${var.data_root}/cassandra-status.sh",
      "sudo chown cassandra:cassandra ${var.data_root}/cassandra-status.sh",
      "sudo chmod +x ${var.data_root}/cassandra-status.sh",
      "echo '* * * * * ${var.data_root}/cassandra-status.sh' >> /tmp/crontab",
      "sudo crontab -u cassandra /tmp/crontab",
      "rm /tmp/crontab"
    ]
  }
}
