# Cassandra Module

## Description

This module creates a Cassandra cluster. The module is based upon the
following white paper:

https://d0.awsstatic.com/whitepapers/Cassandra_on_AWS.pdf

## Variables

Name | Description | Default
---- | ----------- | -------
`app_name` | application name | |
`availability_zones` | comma separated list of AZs | |
`az_count` | number of AZs to span | |
`backup_hour` | crontab hour for backup | |
`backup_minute` | crontab minute for backup | |
`backup_retention` | backup retention period in days | 7 |
`bastion_ip` | bastion IP address for ssh access | |
`bastion_private_key` | local path to ssh private key for bastion access | |
`cassandra_version` | version of Cassandra | 3.9 |
`cloudwatch_alarm_arn` | cloudwatch alarm ARN | |
`commit_log_device_name` | attach device for commit log volume | /dev/xvdg |
`commit_log_mount_point` | mount point for commit log volume | commitlog |
`data_device_name` | attach device for data volume | /dev/xvdf |
`data_dir` | data directory for Docker mount | /var/lib/cassandra |
`data_mount_point` | mount point for data volume | data |
`environment` | environment to configure | |
`iam_instance_profile` | IAM instance profile name to allow nodes to create EBS snapshots | |
`key_name` | key pair for SSH access | |
`nodes_per_az` | number of non-seed nodes per AZ | |
`nonseed_commitlog_volume_ids` | list of non-seed commitlog volume IDs | |
`nonseed_data_volume_ids` | list of non-seed data volume IDs | |
`private_key` | local path to ssh private key | |
`region` | region to configure | |
`security_group_ids` | list of security groups | |
`seed_addr` | network number for seed IP | |
`seed_commitlog_volume_ids` | list of seed commitlog volume IDs | |
`seed_data_volume_ids` | list of seed data volume IDs | |
`seed_subnet_ids` | list of subnet IDs for seed nodes (/24 CIDR) | |
`stdenv` | environment lookup to use | |
`subnet_ids` | list of subnet IDs for non-seed nodes | |

## Outputs

Name | Description
---- | -----------
`node_ips` | comma separated list of node IP addresses |

## Tests
The test documentation can be found in test/main.tf.
