#!/usr/bin/env bash
#
# Script to post status of the Cassandra process to CloudWatch metrics.

# determine the status
value=`ps -ef | grep cassandra | grep -v grep | grep -v $0 | wc -l`

# post the status
aws --region ${region} cloudwatch put-metric-data --metric-name CassandraStatus \
    --namespace CMXAM/Cassandra --value $value \
    --dimensions InstanceId=`curl http://169.254.169.254/latest/meta-data/instance-id` \
    --timestamp `date '+%FT%T.%N%Z'`
