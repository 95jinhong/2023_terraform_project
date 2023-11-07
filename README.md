# 개요
terraform toy project


# 생성 방법

```bash
# EKS 생성
terraform init
terraform apply

# kubectl config 생성
aws eks update-kubeconfig --region ap-northeast-2 --name eks-from-terraform

# cluster 확인
kubectl cluster-info
```

# 삭제 방법
```bash
terrform destroy
```

