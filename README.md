This repository contains Github Actions pipeline and Terraform modules/resources
for Amazon VPC and EKS cluster deploy with [`Bottlerocket OS`](https://github.com/bottlerocket-os/bottlerocket) AMI in EKS node groups

## EKS Variables

- EKS version, EC2 instance types, min/max/desired size in `eks.tf`
```
cluster_version = "1.28"
instance_types = ["t2.micro", "t2.small"]
min_size     = 1
max_size     = 1
desired_size = 1
```


## Auto deploy with Github Actions pipeline

- Fork or clone the repository https://github.com/iliusa77/terraform-eks-bottlerocket

- Run the pipeline `.github/workflows/eks-deploy.yaml`

- Define the following inputs with your own values:
```
'AWS Access Key ID'     
'AWS Secret Access Key'     
'AWS region'     
'AWS account'     
'AWS IAM user'     
```


## Manual Deploy (with local Terraform)

- Configure aws-cli
```
aws configure
```

- Enable profile 

Uncomment in `providers.tf` the following:
```
provider "aws" {
  #profile    = "${var.profile}"
```

Uncomment in `vars.tf` the following:
```
#variable "profile" {
#  description = "AWS credentials profile you want to use"
#}
```

- VPC, EKS creation
```
terraform init
terraform plan
terraform apply
```

- Add EKS cluster in kube config
```
aws eks list-clusters
aws eks update-kubeconfig --region <aws_region> --name eks-bottlerocket-cluster
```

- VPC, EKS destroy
```
terraform destroy
```

Bottlerocket OS AMI version
```
region: us-east-1
k8s_version: 1.28
name: bottlerocket-aws-k8s-1.28-x86_64-v1.16.1-763f6d4c
id: ami-0d9464ba1501db1be
```
