module "vpc" {
    source   = "./modules/aws_vpc"
    for_each = var.vpc_config
    vpc_cidr = each.value.vpc_cidr
    tags     = each.value.tags
}

module "subnets" {
    source            = "./modules/aws_subnets"
    for_each          = var.subnet_config
    vpc_id            = module.vpc[each.value.vpc_name].vpc_id
    subnet_cidr       = each.value.cidr_block
    availability_zone = each.value.availability_zone
    tags              = each.value.tags
}