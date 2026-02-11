 # Django on AWS EKS

Розгортання Django-застосунку в AWS через Terraform + EKS + Helm.  
Docker-образ зберігається в ECR, база даних — PostgreSQL у кластері.

## Стек

- Terraform  
- AWS EKS  
- AWS ECR  
- Kubernetes  
- Helm  
- PostgreSQL  

## Деплой

### 1. Інфраструктура

```bash
terraform init
terraform apply
```

### 2. Підключення до кластера

```bash
$(terraform output -raw kubeconfig_command)
kubectl get nodes
```

### 3. Пуш Docker-образу

```bash
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin $(terraform output -raw ecr_repository_url)

docker tag django-app:latest $(terraform output -raw ecr_repository_url):latest
docker push $(terraform output -raw ecr_repository_url):latest
```

### 4. Деплой через Helm

```bash
helm install django-app ./charts/django-app \
  --set image.repository=$(terraform output -raw ecr_repository_url) \
  --set image.tag=latest
```

## Видалення ресурсів

```bash
terraform destroy
```
