provider "aws" {
  region = "us-west-2"
}


# Підключаємо модуль S3 та DynamoDB
module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "terraform-state-bucket-kvv"
  table_name  = "terraform-locks"
}

# Підключаємо модуль VPC

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
  vpc_name           = "lesson-8-9-vpc"
}

# Підключаємо модуль ECR
module "ecr" {
  source      = "./modules/ecr"
  ecr_name    = "lesson-8-9-ecr"
  scan_on_push = true
}

module "eks" {
  source          = "./modules/eks"          
  cluster_name    = "eks-cluster-demo"                # Назва кластера
  subnet_ids      = module.vpc.public_subnet_ids      # ID підмереж
  instance_type   = "t3.medium"                        # Тип інстансів
  desired_size    = 2                                 # Бажана кількість нодів
  max_size        = 3                                 # Максимальна кількість нодів
  min_size        = 2                                 # Мінімальна кількість нодів
  region          = "us-west-2"
}

module "jenkins" {
  source                     = "./modules/jenkins"
  cluster_name               = module.eks.cluster_name
  oidc_provider_arn          = module.eks.oidc_provider_arn
  oidc_provider_url          = module.eks.oidc_provider_url
  kubeconfig                 = module.eks.kubeconfig_command
  eks_cluster_endpoint       = module.eks.cluster_endpoint
  eks_cluster_ca_certificate = module.eks.eks_cluster_ca_certificate
  eks_cluster_token          = module.eks.eks_cluster_token
}

module "argo_cd" {
  source                     = "./modules/argo_cd"
  namespace                  = "argo-cd"
  chart_version              = "5.46.4"

  eks_cluster_endpoint       = module.eks.cluster_endpoint
  eks_cluster_ca_certificate = module.eks.eks_cluster_ca_certificate
  eks_cluster_token          = module.eks.eks_cluster_token
}


module "rds" {
  source = "./modules/rds"

  use_aurora     = false
  engine         = "postgres"
  engine_version = "14"
  instance_class = "db.t3.micro"

  db_name  = "appdb"
  username = "postgres"
  password = "postgres123"

  subnet_ids = module.vpc.private_subnet_ids
  vpc_id     = module.vpc.vpc_id
}

module "monitoring" {
  source = "./modules/monitoring"
  cluster_name = module.eks.cluster_name
}
