/*
terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-kvv"
    key            = "lesson-8-9/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
*/