/*
 * Cassandra outputs
 */

output "seed_ips" {
  value = "${aws_instance.seeds.*.private_ip}"
}
