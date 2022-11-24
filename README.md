## Terraform script to create an AWS EKS Cluster

### Inialize

```
terraform init
```

### Plan

```
terraform plan --var-file="./config/terraform.tfvars"
```

### Apply

```
terraform apply --var-file="./config/terraform.tfvars" --auto-approve
```