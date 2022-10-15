resource "aws_eks_node_group" "nodes_general" {

    cluster_name = var.eks_cluster_name
    node_group_name = var.node_group_name
    node_role_arn = aws_iam_role.nodes_general.arn
    subnet_ids = var.subnet_ids

    scaling_config {
        desired_size = 1
        max_size = 1
        min_size = 1
    }

    ami_type = "AL2_x86_64"
    capacity_type = "ON_DEMAND"
    disk_size = 20
    force_update_version = false
    instance_types = ["t2.medium"]
    depends_on = [
        aws_iam_role_policy_attachment.terraform_amazon_eks_worker_node_policy,
        aws_iam_role_policy_attachment.terraform_amazon_eks_cni_policy,
        aws_iam_role_policy_attachment.terraform_amazon_ec2_container_registry_read_only,
    ]
    tags =  var.tags
}


resource "aws_iam_role" "nodes_general" {
    name = var.node_group_name
    assume_role_policy = <<POLICY
    {
        "Version": "2012-10-17",
        "Statement": [
            {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            }, 
            "Action": "sts:AssumeRole"
            }
        ]
    }
    POLICY
}



resource "aws_iam_role_policy_attachment" "terraform_amazon_eks_worker_node_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role = aws_iam_role.nodes_general.name
}

resource "aws_iam_role_policy_attachment" "terraform_amazon_eks_cni_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role = aws_iam_role.nodes_general.name
}

resource "aws_iam_role_policy_attachment" "terraform_amazon_ec2_container_registry_read_only" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role = aws_iam_role.nodes_general.name
}