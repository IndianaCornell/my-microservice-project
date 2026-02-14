# CI/CD: Terraform + Jenkins + Helm + Argo CD

Проєкт реалізує повний CI/CD цикл для Django-застосунку в AWS (EKS).

## Структура проєкту

```
lesson-8-9/
│
├── main.tf
├── backend.tf
├── outputs.tf
│
├── modules/
│   ├── s3-backend/     # S3 + DynamoDB для terraform state
│   ├── vpc/            # VPC, subnet, routing
│   ├── ecr/            # ECR repository
│   ├── eks/            # Kubernetes cluster
│   ├── jenkins/        # Jenkins (Helm)
│   └── argo_cd/        # Argo CD (Helm)
│
├── charts/
│   └── django-app/     # Helm chart для Django
│
├── Dockerfile
├── .dockerignore
├── manage.py
├── requirements.txt
└── project/
```

---

## Архітектура

1. Terraform створює:
   - VPC
   - EKS кластер
   - ECR репозиторій
   - Jenkins
   - Argo CD

2. Jenkins:
   - збирає Docker image через Kaniko
   - пушить образ у ECR
   - оновлює тег у Helm chart

3. Argo CD:
   - відслідковує Git-репозиторій
   - автоматично синхронізує зміни
   - оновлює деплой у кластері

---

## Налаштування секретів

### Jenkins (доступ до GitHub)

```bash
kubectl create secret generic github-credentials \
  --from-literal=username=YOUR_GITHUB_USERNAME \
  --from-literal=password=YOUR_GITHUB_PAT \
  -n jenkins
```

### Argo CD (доступ до репозиторію)

```bash
kubectl create secret generic argo-private-repo \
  --from-literal=type=git \
  --from-literal=url=https://github.com/YOUR_USERNAME/YOUR_REPO.git \
  --from-literal=username=YOUR_GITHUB_USERNAME \
  --from-literal=password=YOUR_GITHUB_PAT \
  -n argo-cd
```

---

## Запуск інфраструктури

```bash
terraform init
terraform plan
terraform apply
```

---

## Доступ до Jenkins

```bash
terraform output jenkins_url
terraform output jenkins_password
```

Pipeline виконує:
- Build Docker image
- Push в ECR
- Оновлення Helm chart

---

## Доступ до Argo CD

Отримати пароль:

```bash
kubectl -n argo-cd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d
```

Port-forward:

```bash
kubectl port-forward svc/argocd-server -n argo-cd 8080:443
```

Відкрити в браузері:

```
https://localhost:8080
```

Статус застосунку повинен бути:
- Synced
- Healthy
