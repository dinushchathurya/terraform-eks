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

module "igw" {
    source   = "./modules/aws_igw"
    for_each = var.internet_gateway_config
    vpc_id   = module.vpc[each.value.vpc_name].vpc_id
    tags     = each.value.tags
}

module "nat_gateway" {
    source         = "./modules/aws_nat_gateway"
    for_each       = var.nat_gateway_config
    allocation_id  = module.eip[each.value.eip_name].eip_id
    subnet_id      = module.subnets[each.value.subnet_name].subnet_id
    tags           = each.value.tags
}

module "eip" {
    source   = "./modules/aws_eip"
    for_each = var.elastic_ip_config
    tags     =  each.value.tags
}

module "route_table" {
    source              = "./modules/aws_route_table"
    for_each            = var.route_table_config
    vpc_id              = module.vpc[each.value.vpc_name].vpc_id
    internet_gateway_id = each.value.private == 0 ? module.igw[each.value.gateway_name].internet_gateway_id : module.nat_gateway[each.value.gateway_name].nat_gateway_id
    tags                = each.value.tags
}

module "route_table_association" {
    source         = "./modules/aws_route_table_association"
    for_each       = var.route_table_association_config
    subnet_id      = module.subnets[each.value.subnet_name].subnet_id
    route_table_id = module.route_table[each.value.route_table_name].route_table_id
}

module "eks" {
    source = "./modules/aws_eks"
    for_each         = var.eks_config
    eks_cluster_name = var.cluster-name 
    subnet_ids       = [module.subnets[each.value.subnet1].subnet_id,module.subnets[each.value.subnet2].subnet_id,module.subnets[each.value.subnet3].subnet_id,module.subnets[each.value.subnet4].subnet_id ]
    tags             = each.value.tags
}

module "node_group" {
    source           = "./modules/aws_eks_nodeGroup"
    for_each         = var.eks_nodeGroup_config
    node_group_name  = each.value.node_group_name
    eks_cluster_name = module.eks[each.value.eks_cluster].eks_cluster_name
    subnet_ids       = [module.subnets[each.value.private_subnet1].subnet_id,module.subnets[each.value.private_subnet2].subnet_id]
    nodes_iam_role   = each.value.nodes_iam_role
    tags             = each.value.tags
}