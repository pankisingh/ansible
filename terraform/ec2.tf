resource "aws_spot_instance_request" "cheap_worker" {
  count                     = local.LENGTH
  //count                     = length(var.COMPONENTS)
  ami                       = "ami-0bb6af715826253bf"
  spot_price                = "0.0031"
  instance_type             = "t3.micro"
  vpc_security_group_ids    = ["sg-0017bec6ae883767e"]
  wait_for_fulfillment      = true
  //spot_type                 = "persistent"
  tags                      = {
    Name                    = element(var.COMPONENTS, count.index)
  }
}

resource "aws_ec2_tag" "name-tag" {
  count                     = local.LENGTH
  resource_id               = element(aws_spot_instance_request.cheap_worker.*.spot_instance_id, count.index)
  key                       = "Name"
  value                     = element(var.COMPONENTS, count.index)
}


resource "aws_route53_record" "records" {
  count                     = local.LENGTH
  name                      = element(var.COMPONENTS, count.index)
  type                      = "A"
  zone_id                   = "Z064287532Z1XRTBPYJPM"
  ttl                       = 300
  records                   = [element(aws_spot_instance_request.cheap_worker.*.private_ip, count.index)]
}


locals {
  LENGTH    = length(var.COMPONENTS)
}