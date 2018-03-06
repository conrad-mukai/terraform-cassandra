/*
 * Cassandra module variables
 */

variable "environment" {
  type = "string"
  description = "environment to configure"
}

variable "app_name" {
  description = "application name"
  default = "infra"
}

variable "nodes_per_az" {
  description = "number of non-seed nodes per AZ"
  default = 1
}

variable "subnet_count" {
  type = "string"
  description = "Count of subnets"
}

variable "subnet_ids" {
  type = "list"
  description = "list of subnet IDs for non-seed nodes"
}

variable "seed_subnet_ids" {
  type = "list"
  description = "list of subnet IDs for seed nodes (/24 CIDR)"
}

variable "seed_subnet_count" {
  type = "string"
  description = "count of subnet IDs for seed nodes (/24 CIDR)"
}

variable "seed_addr" {
  type = "string"
  description = "network number for seed IP"
}

variable "security_group_ids" {
  type = "list"
  description = "list of security group IDs for instances"
}

variable "iam_instance_profile" {
  type = "string"
  description = "IAM instance profile to attach to cassandra nodes"
}

variable "data_device_name" {
  description = "attach device for data volume"
  default = "/dev/xvdf"
}

variable "commit_log_device_name" {
  description = "attach device for commit log volume"
  default = "/dev/xvdg"
}

variable "data_root" {
  description = "cassandra data root"
  default = "/var/lib/cassandra"
}

variable "data_mount_point" {
  description = "relative mount point for data volume"
  default = "data"
}

variable "commit_log_mount_point" {
  description = "relative mount point for commit log volume"
  default = "commitlog"
}

variable "seed_data_volume_ids" {
  type = "list"
  description = "list of seed data volume IDs"
}

variable "seed_commitlog_volume_ids" {
  type = "list"
  description = "list of seed commitlog volume IDs"
}

variable "nonseed_data_volume_ids" {
  type = "list"
  description = "list of non-seed data volume IDs"
}

variable "nonseed_commitlog_volume_ids" {
  type = "list"
  description = "list of non-seed commitlog volume IDs"
}

variable "ami" {
  type = "string"
  description = "AWS Linux AMI"
}

variable "user" {
  type = "string"
  description = "user setup in AMI"
}

variable "instance_type" {
  type = "string"
  description = "instance type"
}

variable "cassandra_version" {
  description = "version of Cassandra"
  default = "3.9"
}

variable "key_name" {
  type = "string"
  description = "key pair for SSH access"
}

variable "private_key" {
  type = "string"
  description = "local path to ssh private key"
}

variable "bastion_ip" {
  type = "string"
  description = "bastion IP address for ssh access"
}

variable "bastion_user" {
  type = "string"
  description = "user for bastion ssh login"
}

variable "bastion_private_key" {
  type = "string"
  description = "local path to ssh private key for bastion access"
}

variable "backup_retention" {
  description = "backup retention in days"
  default = 7
}

variable "backup_script_url" {
  description = "URL for the EBS backup script"
  default = "https://github.com/conrad-mukai/python-ebs-backup.git"
}

variable "cloudwatch_alarm_arn" {
  type = "string"
  description = "cloudwatch alarm ARN"
}

variable "cpu_alarm_threshold" {
  description = "percent threshold for CPU alarms"
  default = "80"
}
