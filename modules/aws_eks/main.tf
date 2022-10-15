resource "aws_eks_cluster" "eks" {
    name =  var.eks_cluster_name
    role_arn = aws_iam_role.eks_cluster.arn

    vpc_config {
      endpoint_private_access = false
      endpoint_public_access = true
      subnet_ids = var.subnet_ids
    }

    depends_on = [
        aws_iam_role_policy_attachment.terraform_eks_cluster_policy
    ]
    tags = var.tags
}

resource "aws_iam_role" "eks_cluster" {
    name = "my-eks-cluster"
    assume_role_policy = <<POLICY
        {
            "Version": "2012-10-17",
            "Statement": [
                {
                "Effect": "Allow",
                "Principal": {
                    "Service": "eks.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
                }
            ]
        }
        POLICY
}

resource "aws_iam_role_policy_attachment" "terraform_eks_cluster_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "terrafrom_container_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role    = aws_iam_role.eks_cluster.name
}