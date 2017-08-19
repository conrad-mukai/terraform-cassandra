/*
 * AWS data
 */

data "aws_subnet" "subnets" {
  count = "${length(var.subnet_ids)}"
  id = "${var.subnet_ids[count.index]}"
}

data "aws_subnet" "seed_subnets" {
  count = "${length(var.seed_subnet_ids)}"
  id = "${var.seed_subnet_ids[count.index]}"
}
