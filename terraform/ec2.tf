# resource "aws_spot_instance_request" "cheap_worker" {
#   count                     = local.LENGTH
#   //count                     = length(var.COMPONENTS)
#   ami                       = "ami-0bb6af715826253bf"
#   spot_price                = "0.0031"
#   instance_type             = "t3.micro"
#   vpc_security_group_ids    = ["sg-0017bec6ae883767e"]
#   wait_for_fulfillment      = true
#   //spot_type                 = "persistent"
#   tags                      = {
#     Name                    = element(var.COMPONENTS, count.index)
#   }
# }

resource "aws_instance" "db-instances" {
  count                       = length(var.DB_COMPONENTS)
 ami                          = "ami-0bb6af715826253bf"
  instance_type               = "t3.micro"
  vpc_security_group_ids      = ["sg-0017bec6ae883767e"]
  tags                        = {
    Name                      = "${element(var.DB_COMPONENTS, count.index)}-${var.ENV}"
  }
}

# resource "aws_ec2_tag" "name-tag" {
#   count                     = local.LENGTH
#   resource_id               = element(aws_spot_instance_request.cheap_worker.*.spot_instance_id, count.index)
#   key                       = "Name"
#   value                     = element(var.COMPONENTS, count.index)
# }


resource "aws_route53_record" "records" {
  count                     = local.LENGTH
  name                      = element(var.COMPONENTS, count.index)
  type                      = "A"
  zone_id                   = "Z064287532Z1XRTBPYJPM"
  ttl                       = 300
  records                  = [element(aws_instance.app-instances.*.private_ip, count.index)]
  //records                   = [element(aws_spot_instance_request.cheap_worker.*.private_ip, count.index)]
}

# resource "local_file" "inventory-file" {
#   content     = "[FRONTEND]\n${local.COMPONENTS[9]}\n[PAYMENT]\n${local.COMPONENTS[8]}\n[SHIPPING]\n${local.COMPONENTS[7]}\n[USER]\n${local.COMPONENTS[6]}\n[CATALOGUE]\n${local.COMPONENTS[5]}\n[CART]\n${local.COMPONENTS[4]}\n[REDIS]\n${local.COMPONENTS[3]}\n[RABBITMQ]\n${local.COMPONENTS[2]}\n[MONGODB]\n${local.COMPONENTS[1]}\n[MYSQL]\n${local.COMPONENTS[0]}\n"
#   filename    = "/tmp/inv-roboshop-${var.ENV}"
# }


resource "local_file" "inventory-file" {
  content     = "[FRONTEND]\n${local.COMPONENTS[9]}\n[PAYMENT]\n${local.COMPONENTS[8]}\n[SHIPPING]\n${local.COMPONENTS[7]}\n[USER]\n${local.COMPONENTS[6]}\n[CATALOGUE]\n${local.COMPONENTS[5]}\n[CART]\n${local.COMPONENTS[4]}\n[REDIS]\n${local.COMPONENTS[3]}\n[RABBITMQ]\n${local.COMPONENTS[2]}\n[MONGODB]\n${local.COMPONENTS[1]}\n[MYSQL]\n${local.COMPONENTS[0]}\n"
  filename    = "/tmp/inv-roboshop-${var.ENV}"
}

locals {
  LENGTH    = length(var.COMPONENTS)
}