/*
 * variables for the Cassandra module test
 */

variable "region" {
  type = "string"
}

variable "environment" {
  type = "string"
}

variable "ami" {
  type = "string"
}

variable "user" {
  type = "string"
}

variable "instance_type" {
  type = "string"
}

variable "key_name" {
  type = "string"
}

variable "iam_instance_profile" {
  type = "string"
}

variable "private_key_path" {
  type = "string"
}

variable "bastion_private_key_path" {
  type = "string"
}

variable "authorized_key_path" {
  type = "string"
}

variable "availability_zones" {
  type = "list"
}

variable "cidr_vpc" {
  type = "string"
}

variable "allowed_ingress_list" {
  type = "list"
}

variable "seed_addr" {
  type = "string"
}

variable "cloudwatch_alarm_arn" {
  type = "string"
}
