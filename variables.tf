variable "vpc_config" {}

variable "subnet_config" {}

variable "internet_gateway_config" {}

variable "nat_gateway_config" {}

variable "elastic_ip_config" {}

variable "route_table_config" {}

variable "route_table_association_config" {}

variable "eks_config" {}

variable "eks_nodeGroup_config" {}

variable "region" {}
  
variable "access_key" {}

variable "secret_key" {}

variable "cluster-name" {
    description = "EKS cluster name."
    default     = "terraform-cluster"
    type        = string
}