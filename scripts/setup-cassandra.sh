#!/usr/bin/env bash
#
# Script to setup and start a cassandra node.

# source functions
. /var/lib/cassandra/mount-volumes

# update java
sudo yum remove -y java-1.7.0-openjdk
sudo yum install -y java-1.8.0

# install cassandra
yum install -y datastax-ddc

# configure cassandra
cat /etc/cassandra/conf/cassandra.yaml \
    | sed "s|cluster_name: 'Test Cluster'|cluster_name: '${cluster_name}'|" \
    | sed 's|listen_address: localhost|# listen_address: localhost|' \
    | sed 's|rpc_address: localhost|#rpc_address: localhost|' \
    | sed 's|endpoint_snitch: SimpleSnitch|endpoint_snitch: Ec2Snitch|' \
    | sed 's|- seeds: "127.0.0.1"|- seeds: "${seed_addrs}"|' \
    > /tmp/cassandra.yaml
mv /tmp/cassandra.yaml /etc/cassandra/conf/

# mount the volumes
mount_volume ${data_device_name} ${data_mount_point}
mount_volume ${commit_log_device_name} ${commit_log_mount_point}

# make cassandra owner of the mounted volumes
chown cassandra:cassandra -R ${data_mount_point}
chown cassandra:cassandra -R ${commit_log_mount_point}

# start the service
service cassandra start
