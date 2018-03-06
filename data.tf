/*
 * AWS data
 */

data "aws_subnet" "subnets" {
  count = "${var.subnet_count}"
  id = "${var.subnet_ids[count.index]}"
}

data "aws_subnet" "seed_subnets" {
  count = "${var.seed_subnet_count}"
  id = "${var.seed_subnet_ids[count.index]}"
}
